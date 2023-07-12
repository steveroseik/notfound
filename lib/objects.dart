import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



CachedNetworkImage cachedImage(String path){
  return CachedNetworkImage(
    imageUrl: path,
    fit: BoxFit.cover,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}


List<CartItem> cartItemsFromJson(String str) => List<CartItem>.from(jsonDecode(str).map((e) => CartItem.fromJson(e)));
String cartItemsToJson(List<CartItem> data) => jsonEncode(data.map((e) => e.toJson()).toList());
List<Map<String, dynamic>> cartItemsToReceipt(List <CartItem> data) => List<Map<String, dynamic>>.from(data.map((e) => e.toReceipt()));

class CartItem{
  late int quantity;
  final Product product;
  final AvailableSize size;

  CartItem({required this.product, required this.size, int? count}){
    quantity = count?? 1;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      product: Product.fromJson(json['product']),
      size: AvailableSize.fromJson(json['size']),
      count: json['quantity']);

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'product': product.toJson(),
    'size': size.toJson()
  };

  Map<String, dynamic> toReceipt() => {
    'productName': product.name,
    'productPhoto': product.mainPhotoPath,
    'quantity': quantity,
    'size': size.name,
    'price': product.getPrice('EGP') * quantity
  };

}



class UserPod{

  String firstName;
  String lastName;
  String provider;
  String phoneNumber;
  String id;
  String email;
  bool isMale;
  DateTime birthdate;
  DateTime lastModified;
  DateTime createdAt;

  UserPod({
    required this.firstName,
    required this.provider,
    required this.lastName, required this.phoneNumber, required this.id, required this.email,
    required this.birthdate, required this.lastModified, required this.createdAt, required this.isMale});

  factory UserPod.fromJson(Map<String, dynamic> data) =>
      UserPod(
          firstName: data['fname'],
          lastName: data['lname'],
          provider: data['provider'],
          phoneNumber: data['phone'],
          id: data['id'],
          email: data['email'],
          isMale: data['isMale'],
          birthdate: DateTime.fromMillisecondsSinceEpoch(data['birthdate']),
          lastModified: DateTime.fromMillisecondsSinceEpoch(data['lastModified']),
          createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at']));

  factory UserPod.fromShot(Map<String, dynamic> data) =>
      UserPod(
          firstName: data['fname'],
          lastName: data['lname'],
          provider: data['provider'],
          phoneNumber: data['phone'],
          id: data['id'],
          email: data['email'],
          isMale: data['isMale'],
          birthdate: (data["birthdate"] as Timestamp).toDate(),
          lastModified: (data["lastModified"] as Timestamp).toDate(),
          createdAt: (data["created_at"] as Timestamp).toDate());

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
    "fname": lastName,
    "lname": firstName,
    "phone": phoneNumber,
    "isMale": isMale,
    "birthdate": birthdate.millisecondsSinceEpoch,
    "created_at": createdAt.millisecondsSinceEpoch,
    "email": email,
    "lastModified": lastModified.millisecondsSinceEpoch
  };
  Map<String, dynamic> toShot() => {
    "id": id,
    "provider": provider,
    "fname": lastName,
    "lname": firstName,
    "phone": phoneNumber,
    "isMale": isMale,
    "birthdate": Timestamp.fromMillisecondsSinceEpoch(birthdate.millisecondsSinceEpoch),
    "created_at": Timestamp.fromMillisecondsSinceEpoch(createdAt.millisecondsSinceEpoch),
    "email": email,
    "lastModified": Timestamp.fromMillisecondsSinceEpoch(lastModified.millisecondsSinceEpoch)
  };
}


// TODO: FIX FROM WITHIN


// TODO: FULL PRODUCT LIST


class LikedCache{
  String uid = '';
  List<int> productIds = [];
  
  LikedCache({String? uid, List<int>? productIds}){
    this.uid = uid?? '';
    this.productIds = productIds?? [];
  }
  
  factory LikedCache.fromJson(Map<String, dynamic> json) =>
  LikedCache(
    uid: json['uid'],
    productIds: List<int>.from(json['productIds'])
  );

  Map<String, dynamic> toJson() => {
    "uid" : uid,
    "productIds":productIds
  };

  addProduct(int id){
    if (!productIds.contains(id)) productIds.add(id);
  }

  removeProduct(int id){
    if (productIds.contains(id)) productIds.remove(id);
  }

  bool hasProduct(int id){
   return productIds.contains(id);
  }
}

List<ProductCache> productCacheListFromJson (String str) => List<ProductCache>.from(jsonDecode(str).map((x) => ProductCache.fromJson(x)));
String productCacheListToJson (List<ProductCache> data) => jsonEncode(data.map((e) => e.toJson()).toList());

class ProductCache {
  late DateTime ttl;
  Product product;

  ProductCache({required this.product, DateTime? exp}){
    ttl = exp?? DateTime.now().add(const Duration(hours: 16));
  }

  factory ProductCache.fromJson(Map<String, dynamic> json) =>
      ProductCache(
          product: Product.fromJson(json['product']),
          exp: DateTime.fromMillisecondsSinceEpoch(json['ttl']));

  Map<String, dynamic> toJson() => {
    'ttl': ttl.millisecondsSinceEpoch,
    'product': product.toJson()
  };

}
Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

List<Product> productListFromJson (String str) => List<Product>.from(json.decode(str).map((e) => Product.fromJson(e)));

String productListToJson (List<Product> data) => jsonEncode(data.map((e) => e.toJson()).toList());

class Product {
  int id;
  int collectionId;
  int categoryId;
  String name;
  String mainPhotoPath;
  String modelPhotoPath;
  String sizeChartPath;
  List<Price> prices;
  String colorName;
  String description;
  String composition;
  String careInstructions;
  List<AvailableSize> availableSizes;
  List<String> photos;
  List<ProductElement> pairWithProducts;
  List<AvailableColor> availableColors;

  Product({
    required this.id,
    required this.collectionId,
    required this.categoryId,
    required this.name,
    required this.mainPhotoPath,
    required this.modelPhotoPath,
    required this.sizeChartPath,
    required this.prices,
    required this.colorName,
    required this.description,
    required this.composition,
    required this.careInstructions,
    required this.availableSizes,
    required this.photos,
    required this.pairWithProducts,
    required this.availableColors,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    collectionId: json["collectionId"],
    categoryId: json["categoryId"],
    name: json["name"],
    mainPhotoPath: json["mainPhotoPath"],
    modelPhotoPath: json["modelPhotoPath"],
    sizeChartPath: json["sizeChartPath"],
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
    colorName: json["colorName"],
    description: json["description"],
    composition: json["composition"],
    careInstructions: json["careInstructions"],
    availableSizes: List<AvailableSize>.from(json["availableSizes"].map((x) => AvailableSize.fromJson(x))),
    photos: List<String>.from(json["photos"].map((x) => x)),
    pairWithProducts: List<ProductElement>.from(json["pairWithProducts"].map((x) => ProductElement.fromJson(x))),
    availableColors: List<AvailableColor>.from(json["availableColors"].map((x) => AvailableColor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collectionId": collectionId,
    "categoryId": categoryId,
    "name": name,
    "mainPhotoPath": mainPhotoPath,
    "modelPhotoPath": modelPhotoPath,
    "sizeChartPath": sizeChartPath,
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
    "colorName": colorName,
    "description": description,
    "composition": composition,
    "careInstructions": careInstructions,
    "availableSizes": List<dynamic>.from(availableSizes.map((x) => x.toJson())),
    "photos": List<dynamic>.from(photos.map((x) => x)),
    "pairWithProducts": List<dynamic>.from(pairWithProducts.map((x) => x.toJson())),
    "availableColors": List<dynamic>.from(availableColors.map((x) => x.toJson())),
  };

  int getPrice(String curr){
    final i = prices.indexWhere((e) => e.currency.toUpperCase().contains(curr.toUpperCase()));
    if (i != -1) return int.tryParse(prices[i].priceAfterDiscount)!;
    return 0;
  }
}

class AvailableColor {
  int productId;
  int id;
  String name;
  String hexaCode;

  AvailableColor({
    required this.productId,
    required this.id,
    required this.name,
    required this.hexaCode,
  });

  factory AvailableColor.fromJson(Map<String, dynamic> json) => AvailableColor(
    productId: json["productId"],
    id: json["id"],
    name: json["name"],
    hexaCode: json["hexaCode"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "id": id,
    "name": name,
    "hexaCode": hexaCode,
  };
}

class AvailableSize {
  int id;
  String name;
  String abbreviation;
  int stock;

  AvailableSize({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.stock,
  });

  factory AvailableSize.fromJson(Map<String, dynamic> json) => AvailableSize(
    id: json["id"],
    name: json["name"],
    abbreviation: json["abbreviation"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "abbreviation": abbreviation,
    "stock": stock,
  };
}

List<ProductElement> productElementsFromJson(String str) => List<ProductElement>.from(json.decode(str)['products'].map((x) => ProductElement.fromJson(x)));

String productElementsToJson(List<ProductElement> data ) => jsonEncode({
  'products': List<dynamic>.from(data.map((x) => x.toJson()))
});

// TODO: MAIN PRODUCT LIST ( NOT ALL DATA )

class ProductElement {
  int id;
  int collectionId;
  int categoryId;
  String name;
  String mainPhotoPath;
  String modelPhotoPath;
  List<Price> prices;

  ProductElement({
    required this.id,
    required this.collectionId,
    required this.categoryId,
    required this.name,
    required this.mainPhotoPath,
    required this.modelPhotoPath,
    required this.prices,
  });

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    id: json["id"],
    collectionId: json["collectionId"],
    categoryId: json["categoryId"],
    name: json["name"],
    mainPhotoPath: json["mainPhotoPath"],
    modelPhotoPath: json["modelPhotoPath"],
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collectionId": collectionId,
    "categoryId": categoryId,
    "name": name,
    "mainPhotoPath": mainPhotoPath,
    "modelPhotoPath": modelPhotoPath,
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
  };

  int getPrice(String curr){
    final i = prices.indexWhere((e) => e.currency.toUpperCase().contains(curr.toUpperCase()));
    if (i != -1) return int.tryParse(prices[i].priceAfterDiscount)!;
    return 0;
  }
}

class Price {
  String priceAfterDiscount;
  String priceBeforeDiscount;
  String currency;

  Price({
    required this.priceAfterDiscount,
    required this.priceBeforeDiscount,
    required this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    priceAfterDiscount: json["priceAfterDiscount"],
    priceBeforeDiscount: json["priceBeforeDiscount"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "priceAfterDiscount": priceAfterDiscount,
    "priceBeforeDiscount": priceBeforeDiscount,
    "currency": currency,
  };
}

List<Collection> collectionFromJson(String str) => List<Collection>.from(json.decode(str)['categories'].map((x) => Collection.fromJson(x)));

String collectionToJson(List<Collection> data) => json.encode({
  'categories': List<dynamic>.from(data.map((x) => x.toJson()))
});

class Collection {
  int id;
  String name;
  String bannerPhoto;
  String shopBannerPhoto;
  List<CollectionPhoto> collectionPhotos;
  String? description;
  String comingSoonText;
  bool isComingSoon;

  Collection({
    required this.id,
    required this.name,
    required this.bannerPhoto,
    required this.shopBannerPhoto,
    required this.collectionPhotos,
    required this.description,
    required this.comingSoonText,
    required this.isComingSoon,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    id: json["id"],
    name: json["name"],
    bannerPhoto: json["bannerPhoto"],
    shopBannerPhoto: json["shopBannerPhoto"],
    collectionPhotos: List<CollectionPhoto>.from(json["collectionPhotos"].map((x) => CollectionPhoto.fromJson(x))),
    description: json["description"],
    comingSoonText: json["comingSoonText"],
    isComingSoon: json["isComingSoon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bannerPhoto": bannerPhoto,
    "shopBannerPhoto": shopBannerPhoto,
    "collectionPhotos": List<dynamic>.from(collectionPhotos.map((x) => x.toJson())),
    "description": description,
    "comingSoonText": comingSoonText,
    "isComingSoon": isComingSoon,
  };
}

class CollectionPhoto {
  int id;
  String photo;

  CollectionPhoto({
    required this.id,
    required this.photo,
  });

  factory CollectionPhoto.fromJson(Map<String, dynamic> json) => CollectionPhoto(
    id: json["id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
  };
}

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str)['categories'].map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode({
  'categories': List<dynamic>.from(data.map((x) => x.toJson()))
});

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

List<AddressItem> addressItemsFromJson(String str) => List<AddressItem>.from(json.decode(str).map((x) => AddressItem.fromJson(x)));
List<AddressItem> addressItemsFromShot(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) =>
    List<AddressItem>.from(docs.map((e) => AddressItem.fromShot(e.data(), e.reference.path)));

String addressItemsToJson(List<AddressItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
String addressItemsToShot(List<AddressItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toShot())));


class AddressItem {
  String id;
  String zone;
  String country;
  String state;
  String city;
  String zipcode;
  String address;
  String details;
  String name;
  bool isDefault;
  DateTime lastModified;

  AddressItem({
    required this.id,
    required this.zone,
    required this.country,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.address,
    required this.details,
    required this.isDefault,
    required this.lastModified,
    required this.name
  });

  factory AddressItem.fromJson(Map<String, dynamic> json) => AddressItem(
    id: json["id"],
    zone: json["zone"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipcode: json["zipCode"],
    address: json["address"],
    details: json["details"],
    isDefault: json["isDefault"],
    name: json["name"],
    lastModified: DateTime.fromMillisecondsSinceEpoch(json['lastModified'])
  );

  factory AddressItem.fromShot (Map<String, dynamic> json, String id) =>  AddressItem(
    id: id,
    zone: json["zone"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipcode: json["zipCode"],
    address: json["address"],
    details: json["details"],
    isDefault: json["isDefault"],
    name: json["name"],
    lastModified: json['lastModified'].toDate()
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "zone": zone,
    "country": country,
    "state": state,
    "city": city,
    "zipCode": zipcode,
    "address": address,
    "details": details,
    "isDefault": isDefault,
    "name": name,
    'lastModified': lastModified.millisecondsSinceEpoch
  };

  Map<String, dynamic> toShot() => {
    "zone": zone,
    "country": country,
    "state": state,
    "city": city,
    "zipCode": zipcode,
    "address": address,
    "details": details,
    "isDefault": isDefault,
    "name": name,
    'lastModified': Timestamp.fromDate(lastModified)
  };
}

Receipt receiptFromJson(String str) => Receipt.fromJson(json.decode(str));
Receipt receiptFromShot(dynamic doc) => Receipt.fromShot(doc.data(), doc.id);

List<Receipt> receiptsFromShot(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs)
=> List<Receipt>.from(docs.map((e) => Receipt.fromShot(e.data(), e.id)));

List<Receipt> receiptsFromJson(String data) =>
List<Receipt>.from(jsonDecode(data).map((e) => Receipt.fromJson(e)));

String receiptsToJson(List<Receipt> receipts) => jsonEncode(List<Map<String, dynamic>>.from(receipts.map((e) => e.toJson())));

String receiptToJson(Receipt data) => json.encode(data.toJson());

class Receipt {
  String id;
  String type;
  String userId;
  List<Item> items;
  int amount;
  String state;
  DateTime createdAt;

  Receipt({
    required this.id,
    required this.type,
    required this.userId,
    required this.items,
    required this.amount,
    required this.state,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    id: json["id"],
    type: json['type'],
    userId: json["userId"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    amount: json["amount"],
    state: json["state"],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
  );


  factory Receipt.fromShot(Map<String, dynamic> json, String id) => Receipt(
    id: id,
    type: json['type'],
    userId: json["userId"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    amount: json["amount"],
    state: json["state"],
    createdAt: json['createdAt'].toDate()
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "userId": userId,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "amount": amount,
    "state": state,
    "createdAt": createdAt.millisecondsSinceEpoch
  };
  Map<String, dynamic> toShot() => {
    "userId": userId,
    "type": type,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "amount": amount,
    "state": state,
    "createdAt": Timestamp.fromDate(createdAt)
  };
}

List<Item> receiptItemListFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

class Item {
  String productName;
  String productPhoto;
  int quantity;
  String size;
  String price;

  Item({
    required this.productName,
    required this.productPhoto,
    required this.quantity,
    required this.size,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productName: json["productName"],
    productPhoto: json["productPhoto"],
    quantity: json["quantity"],
    size: json["size"],
    price: json["price"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "productPhoto": productPhoto,
    "quantity": quantity,
    "size": size,
    "price": price,
  };
}





