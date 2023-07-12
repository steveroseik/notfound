import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notfound/api_lib.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'objects.dart';


class BlackNotifier extends InheritedNotifier<BlackBox>{

  const BlackNotifier({
    Key? key,
    required BlackBox blackBox,
    required Widget child}) : super (key: key, notifier: blackBox, child: child);

  static of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<BlackNotifier>()!.notifier;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}

// ======================= END OF BLACK NOTIFIER ================================
// ======================== BEGIN OF CACHE =================================


class BlackBox extends ChangeNotifier{
  bool _guest = false;
  bool _completeUser = false;
  bool cartOutdated = false;
  String currentCurrency = 'EGP';
  UserPod? _userInfo;
  List<ProductElement> pElements = [];
  List<ProductCache> products = [];

  List<Category> categories = [];
  List<Collection> collections = [];

  List<CartItem> cartItems = [];

  List<AddressItem> userAddresses = [];

  List<Receipt> pastOrders = [];

  ValueNotifier<bool> cacheFinished = ValueNotifier(false);

  LikedCache likedProducts = LikedCache();

  dynamic frameKey;

  get isGuest => _guest;
  get validUser => _completeUser;
  get cartLength => cartItems.length;
  get latestCartItems => cartItems;
  get userId => _userInfo?.id;
  get addresses => userAddresses;
  get hasDefaultAddress => userAddresses.indexWhere((e) => e.isDefault) != -1;

 UserPod? userPod(){
    if (isGuest) return null;
    return _userInfo;
  }

  int cartTotal() {
    int tt = 0;
    for (var e in cartItems){
      tt+= e.quantity;
    }
    return tt;
  }

  cartToReceipt({object = false}){
   return object ? receiptItemListFromJson(jsonEncode(cartItemsToReceipt(cartItems))) :
   cartItemsToReceipt(cartItems);
  }

  defaultAddress(){
    final index = userAddresses.indexWhere((e) => e.isDefault);
    if (index != -1) return userAddresses[index];
    return null;
  }

  updateAddress(AddressItem item){
    int i = userAddresses.indexWhere((e) => e.id == item.id);
    if (i != -1){
      userAddresses[i] = item;
    }else{
      userAddresses.add(item);
    }
    notifyListeners();

  }
  setDefault(AddressItem item) async{
    int _old = userAddresses.indexWhere((e) => e.isDefault);
    int _new = userAddresses.indexWhere((e) => e.id == item.id);
    userAddresses[_old].isDefault = false;
    userAddresses[_new].isDefault = true;
    notifyListeners();

    try{
      final batch = FirebaseFirestore.instance.batch();

      final docRef1 = FirebaseFirestore.instance.doc(userAddresses[_old].id);
      batch.update(docRef1, {'isDefault': false});

      final docRef2 = FirebaseFirestore.instance.doc(userAddresses[_new].id);
      batch.update(docRef2, {'isDefault': true});

      await batch.commit();
    }catch (e){
      print('defAddress Error: $e');
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addresses', jsonEncode({
      'userId': userId,
      'data': addressItemsToJson(userAddresses)
    }));
  }


  addNewAddress(AddressItem addr) async{
    userAddresses.add(addr);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addresses', jsonEncode({
      'userId': userId,
      'data': addressItemsToJson(userAddresses)
    }));
  }

  deleteAddress(AddressItem item) async{
    final index = userAddresses.indexWhere((e) => e.id == item.id);
    if (index != -1) userAddresses.removeAt(index);
    try{
      await FirebaseFirestore.instance.doc(item.id).delete();
    }catch(e){
      print('delete address error: $e');
    }
    if (item.isDefault && userAddresses.isNotEmpty) userAddresses.first.isDefault = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addresses', jsonEncode({
      'userId': userId,
      'data': addressItemsToJson(userAddresses)
    }));
  }


  fetchLatestAddresses() async{
    DateTime lastFetched = DateTime(1990);
    for (var e in userAddresses) {
      if (e.lastModified.isAfter(lastFetched)) lastFetched = e.lastModified;
    }
    lastFetched.add(const Duration(seconds: 10));

    try{
      final data = await FirebaseFirestore.instance.collection('users/$userId/addresses')
          .where('lastModified', isGreaterThan: Timestamp.fromDate(lastFetched)).get();
      final newAdds = addressItemsFromShot(data.docs);
      for (var e in newAdds){
        int index = userAddresses.indexWhere((element) => element.id == e.id);
        if (index != -1) {
          userAddresses[index] = e;
        }else{
          userAddresses.add(e);
        }
      }
    }catch (e){
      if (f.kDebugMode) print('fetch LADD: $e');
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('addresses', jsonEncode({
      'userId': userId,
      'data': addressItemsToJson(userAddresses)
    }));
  }


  int cartTotalPrice(String curr){
    int total = 0;
    for (var e in cartItems){
      total += int.tryParse(e.product.prices.firstWhere((e) => e.currency == curr).priceAfterDiscount)! * e.quantity;
    }
    return total;
  }

  List<ProductElement> productsWithinCollection(int id) => pElements.where((e) => e.collectionId == id).toList();
  List<ProductElement> productsWithinCategory(int id) => pElements.where((e) => e.categoryId == id).toList();

  CartItem? itemWhere(Product item, AvailableSize? size) {
    if (size == null) return null;
    final index = cartItems.indexWhere((e) => e.product.id == item.id &&  (e.size.id == size.id));
    if (index != -1) return cartItems[index];
    return null;
  }

  void setUserInfo(Map<String, dynamic> data){
    _userInfo = UserPod.fromShot(data);
    if (likedProducts.uid == ''){
      likedProducts.uid = _userInfo!.id;
    }else{
      if (_userInfo!.id != likedProducts.uid){
        resetLikedProducts();
      }
    }
    notifyListeners();
  }

  void resetLikedProducts() async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('likes')) prefs.remove('likes');
    likedProducts = LikedCache(uid: _userInfo!.id);
  }

  void addToLikes(int id) async{
    likedProducts.addProduct(id);
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('likes', jsonEncode(likedProducts.toJson()));
  }

  void removeFromLikes(int id) async{
    likedProducts.removeProduct(id);
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('likes', jsonEncode(likedProducts.toJson()));
  }

  bool productIsLiked(int id){
    return likedProducts.hasProduct(id);
  }

  List<ProductElement> likedProductsItems(){
    final List<ProductElement> list = [];
   for(var p in pElements){
     if (likedProducts.productIds.contains(p.id)) list.add(p);
   }
   return list;
  }

  void updateUser({String? phone, DateTime? lastModified}){
    if (_userInfo != null){
      if (phone != null) _userInfo!.phoneNumber = phone;
      if (lastModified != null) _userInfo!.lastModified = lastModified;

      notifyListeners();
    }
  }
  //TODO: THIS IS NOT A GENERAL FUNCTION, SPECIFIC FOR SOME SCENARIOS ONLY
  updateUserInfo(Map<String, dynamic> info) async{
    try{
      final now = DateTime.now();
      info['lastModified'] = Timestamp.fromDate(now);
      await FirebaseFirestore.instance.doc('users/${FirebaseAuth.instance.currentUser!.uid}')
          .update(info);
      if (_userInfo != null){
        _userInfo!.firstName = info['fname'];
        _userInfo!.lastName = info['lname'];
        _userInfo!.birthdate = info['birthdate'].toDate();
        _userInfo!.isMale = info['isMale'];
        _userInfo!.lastModified = now;

        notifyListeners();
        return true;
      }
    }catch (e){}

    return false;
  }
  void completeUser({UserPod? data}){
    _completeUser = true;
    if (data != null) _userInfo = data;

    notifyListeners();

  }
  void invalidateUser(){
    _completeUser = false;
    notifyListeners();
  }

  void setGuest(bool b) async{
    _guest = b;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final bPref = prefs.getBool('guest');
    if (bPref == null || !bPref) prefs.setBool('guest', true);
  }


  void updateCurrentCurrency(int i) async{
    switch(i){
      case 1: {
        if (currentCurrency != 'USD') {
          currentCurrency = 'USD';
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('currency', 'USD');
        }
      }
      break;
      case 2: {
        if (currentCurrency != 'EUR') {
          currentCurrency = 'EUR';
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('currency', 'EUR');
        }
      }
      break;
      default:
        if (currentCurrency != 'EGP') {
          currentCurrency = 'EGP';
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('currency', 'EGP');
        }
    }
  }


  void addToCart(BuildContext context, Product item, AvailableSize? size) async{
    final index = cartItems.indexWhere((e) => (e.product.id == item.id) && (e.size.id == size!.id));
    if (index != -1) {
      incrementCartItem(context, cartItems[index]);
    }else{
      cartItems.add(CartItem(product: item, size: size!));
    }
    notifyListeners();
    cartOutdated = true;

  }

  bool incrementCartItem(BuildContext context, CartItem item){
    if (item.size.stock > item.quantity){
      item.quantity++;
      cartOutdated = true;
      notifyListeners();
      return false;
    }else{
      showErrorBar(context, 'You have reached the maximum ${item.product.name.capitalizeAllWords()} to be ordered in the mean time.');
      return true;
    }
  }

  updateCart() async{
    if (!cartOutdated) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', cartItemsToJson(cartItems));
    cartOutdated = false;
    notifyListeners();
  }

  updateBox(){
    notifyListeners();
  }

  CartItem? decrementCartItem(CartItem item){
    bool deleted = false;
    if (item.quantity == 1) {
      cartItems.remove(item);
      deleted = true;
    }else{
      item.quantity--;
    }
    cartOutdated = true;
    notifyListeners();
    if (deleted) return item;
    return null;
  }

  void removeFromCart(CartItem item){
    final index = cartItems.indexWhere((element) => element == item);
    if (index != -1 ) {
      cartItems.removeAt(index);
    } else {
      print('error');
    }
    notifyListeners();
  }

  updateProductCache() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('products', productCacheListToJson(products));
  }

  Product? cachedProduct(int id){
    final index = products.indexWhere((e) => e.product.id == id);
    if ( index != -1){
      if (products[index].ttl.isAfter(DateTime.now())) return products[index].product;
      products.removeAt(index);
    }
    return null;
  }


  Future<Product?> getFullProduct(int id) async{
    int index = products.indexWhere((e) => e.product.id == id);
    if ( index != -1){
      if (products[index].ttl.isAfter(DateTime.now())) return products[index].product;
      products.removeAt(index);
    }
    int i = 2;
    do{
      try{
        final data = await getFromNotfound('product/$id');
        final newProduct = productFromJson(data);
        products.add(ProductCache(product: newProduct));
        updateProductCache();
        return newProduct;
      }catch (e){
        i--;
        print('error product fetch: $e');
      }
    }while(i > 0);
    index = pElements.indexWhere((e) => e.id == id);
    if (index != -1) pElements.removeAt(index);

    return null;
  }

  initCache(SharedPreferences prefs) async{
    bool eCached = false;
    bool catCached = false;
    bool colCached = false;
    pElements.clear();
    products.clear();
    categories.clear();
    collections.clear();
    cartItems.clear();
    notifyListeners();

    if (prefs.containsKey('currency')) {
      currentCurrency = prefs.getString('currency')!;
    }else{
      prefs.setString('currency', 'EGP');
    }

    if (prefs.containsKey('ttl')){
      final date = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('ttl')!);
      if (date.isBefore(DateTime.now())){
        prefs.remove('productElement');
        prefs.remove('products');
        prefs.remove('collections');
        prefs.remove('categories');
        prefs.setInt('ttl', date.add(const Duration(hours: 3)).millisecondsSinceEpoch);
      }
    }else{
      prefs.setInt('ttl', DateTime.now().add(const Duration(hours: 3)).millisecondsSinceEpoch);
    }

    if (prefs.containsKey('productElement')){
      final cachedElements = productElementsFromJson(prefs.getString('productElement')!);
      pElements.addAll(cachedElements);
      eCached = true;
    }

    if (prefs.containsKey('cart')){
      cartItems.addAll(cartItemsFromJson(prefs.getString('cart')!));
    }

    if (prefs.containsKey('products')){
      products.addAll(productCacheListFromJson(prefs.getString('products')!));
    }

    if (prefs.containsKey('likes')){
      likedProducts = LikedCache.fromJson(jsonDecode(prefs.getString('likes')!));
    }

    if (prefs.containsKey('categories')){
      categories.addAll(categoryFromJson(prefs.getString('categories')!));
      catCached = true;
    }

    if (prefs.containsKey('collections')){
      collections.addAll(collectionFromJson(prefs.getString('collections')!));
      colCached = true;
    }


    if (!eCached){
      try{
        final data = await getFromNotfound('products');
        prefs.setString('productElement', data);
        pElements.addAll(productElementsFromJson(data));
      }catch (e){
        print('box error 32: $e');
      }
    }

    if (!catCached){
      try{
        final data = await getFromNotfound('categories');
        prefs.setString('categories', data);
        categories.addAll(categoryFromJson(data));
      }catch (e){
        print('box error 33: $e');
      }
    }
    if (!colCached){
      final data = await getFromNotfound('collections');
      prefs.setString('collections', data);
      collections.addAll(collectionFromJson(data));
      try{

      }catch (e){
        print('box error 34: $e');
      }
    }
    cacheFinished.value = true;
    notifyListeners();
    fetchAddresses(prefs);
  }

  fetchAddresses(SharedPreferences prefs){
    if (_guest){
      prefs.remove('addresses');
    }else{
      if (prefs.containsKey('addresses')){
        final data = jsonDecode(prefs.getString('addresses')!);
        if (data['userId'] == userId) {
          userAddresses.addAll(addressItemsFromJson(data['data']));
        }else{
          userAddresses.clear();
          prefs.remove('addresses');
          fetchLatestAddresses();
        }
      }else{
        fetchLatestAddresses();
      }
    }
  }

  List<String> extractKeywords(){
    List<String> words = [];
    for (var e in pElements){
      final eList = e.name.split(' ');
      eList.removeWhere((e) => e.length < 2);
      words.addAll(eList);
    }
    words = words.toSet().toList();
    print(words);
    return words;
  }

  clearCart() async{
    cartItems.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }

  getElementsWhere(String s){
    return pElements.where((e) => e.name.toLowerCase().contains(s.toLowerCase()));
  }

  addNewReceipt(Receipt data) async{
    pastOrders.add(data);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pastOrders', jsonEncode({
      'id': _userInfo!.id,
      'exp': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch,
      'receipts': receiptsToJson(pastOrders)
    }));
  }

  fulfillReceipt(String id) async{
    final index = pastOrders.indexWhere((e) => e.id == id);
    if (index != -1) pastOrders[index].state = 'SUCCESSFUL';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pastOrders', jsonEncode({
      'id': _userInfo!.id,
      'exp': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch,
      'receipts': receiptsToJson(pastOrders)
    }));
  }

  Future<List<Receipt>?> getUserReceipts() async{
    if (_userInfo == null) return null;
    final prefs = await SharedPreferences.getInstance();

    if (pastOrders.isNotEmpty) return pastOrders;

    if (prefs.containsKey('pastOrders')){
      final data = jsonDecode(prefs.getString('pastOrders')!);
      final DateTime exp = DateTime.fromMillisecondsSinceEpoch(data['exp']);
      if (exp.isBefore(DateTime.now()) || (data['id'] != _userInfo!.id)){
        prefs.remove('pastOrders');
      }else{
        final list = receiptsFromJson(data['receipts']);
        final DateTime latest = lastOrderCreated(list);
        final resp = await FirebaseFirestore.instance.collection('orders')
            .where('userId', isEqualTo: _userInfo!.id)
            .where('createdAt', isGreaterThan: Timestamp.fromDate(latest)).get();
        if (resp.docs.isNotEmpty){
          list.addAll(receiptsFromShot(resp.docs));

          prefs.setString('pastOrders', jsonEncode({
            'id': _userInfo!.id,
            'exp': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch,
            'receipts': receiptsToJson(list)
          }));
        }
        pastOrders = list;
        return pastOrders;
      }

    }

    final resp = await FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: _userInfo!.id).get();
    if (resp.docs.isNotEmpty) {
      final receipts = receiptsFromShot(resp.docs);
      prefs.setString('pastOrders', jsonEncode({
        'id': _userInfo!.id,
        'exp': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch,
        'receipts': receiptsToJson(receipts)
      }));
      return receipts;
    }
    return <Receipt>[];
    try{

    }catch (e){
      if (f.kDebugMode) print('receiptError: $e');
    }
    return null;
  }


  void signOut() async{
    _completeUser = false;
    _guest = false;
    _userInfo = null;
    notifyListeners();
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('completeUser', false);
    prefs.setBool('guest', false);
    //TODO: delete cart AND -> favourites
    prefs.remove('cart');
  }
}



DateTime lastOrderCreated(List<Receipt> items){
  DateTime lastDate = DateTime(1990);
  for ( var i in items){
    if (i.createdAt.isAfter(lastDate)) lastDate = i.createdAt;
  }
  return lastDate.add(const Duration(seconds: 10));
}



