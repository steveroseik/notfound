import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as img;
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';
import 'configurations.dart';
import 'image_storage.dart';
import 'productPage.dart';



class CollectionItem extends StatelessWidget {
  final ProductElement product;
  final double? round;
  final double? width;
  final bool? hasPrice;
  final Alignment? align;
  final TextAlign? textAlign;
  final bool? flaggedLabel;
  final bool? hasLabel;
  final bool? photoOnly;
  CollectionItem({Key? key,
    required this.product,
    this.round,
    this.width,
    this.hasPrice,
    this.align,
    this.flaggedLabel,
    this.hasLabel,
    this.textAlign,
    this.photoOnly}) : super(key: key);

  bool newItem = false;

  bool loading = false;

  String? labelText;

  @override
  Widget build(BuildContext context) {
    final tag = '${Random().nextInt(50)}${product.mainPhotoPath}${Random().nextInt(50)}';
    final theme = Theme.of(context);
    final BlackBox box = BlackNotifier.of(context);
    final currentPrice = product.prices.firstWhere((e) => e.currency == box.currentCurrency);
    final onSale = (
        int.tryParse(currentPrice.priceBeforeDiscount)!
            - int.tryParse(currentPrice.priceAfterDiscount)! > 0);
    labelText = onSale ? 'Sale' : labelText;
    final oldRatio = (hasLabel?? false) || (labelText != null && labelText!.isNotEmpty) || (hasPrice?? false);
    final urlPhoto = (product.mainPhotoPath.contains('www.notfoundco.com')) ? product.mainPhotoPath :
                'https://notfoundco.com${product.mainPhotoPath}';
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: AspectRatio(
            aspectRatio: 2 / (photoOnly?? false ? 3.5 : 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: align ?? Alignment.center,
                  child: GestureDetector(
                    onTap:() async{
                      try{
                        final prod = box.cachedProduct(product.id);
                        if (prod != null){
                          navKey.currentState?.pushNamed('/productPage', arguments: [prod, tag]).then((value)
                          => Future.delayed(const Duration(milliseconds: 300)).then((value) => box.updateBox()));
                        }else{
                          navKey.currentState?.pushNamed('/productPage', arguments: [product.id, tag]).then((value)
                          => Future.delayed(const Duration(milliseconds: 300)).then((value) => box.updateBox()));
                        }
                      }catch (e){
                        print('collectionWidgetError: $e');
                      }
                    },
                    child: Hero(
                      tag: tag,
                      child: AspectRatio(
                        aspectRatio: 2/3,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(round?? 0),
                            child: cachedImage(urlPhoto)),
                      ),
                    ),
                  ),
                ),
                hasLabel?? false || (labelText != null && labelText!.isNotEmpty) && (!(photoOnly?? false)) ? AspectRatio(
                  aspectRatio: 6 / 1,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: flaggedLabel?? false ? BorderRadius.only(topRight: Radius.circular(4.sp), bottomRight:Radius.circular(4.sp))
                                  : BorderRadius.circular(3.sp),
                              color: theme.secondaryHeaderColor
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1.w),
                            child: AutoSizeText(
                              presetFontSizes: [10.sp,8.sp,6.sp,4.sp,3.sp],
                              labelText!, style: TextStyle(color: theme.cardColor),),
                          ),
                        ),
                      )
                  ),
                ) : Container(),
                (!(photoOnly?? false)) ?
                SizedBox(height: (labelText != null && labelText!.isNotEmpty) ? 0.5.h : 1.5.h) : Container(),
                (hasPrice?? false) && (!(photoOnly?? false)) ? AspectRatio(
                  aspectRatio: 6 / 1,
                  child: Align(
                    alignment: textAlign == TextAlign.left ? Alignment.topLeft : Alignment.topCenter,
                    child: AutoSizeText.rich(
                        TextSpan(
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13.sp),
                            children: [
                              TextSpan(text: '${currentPrice.currency}${onSale ? ' ': ''}'),
                              onSale ? TextSpan(text: currentPrice.priceBeforeDiscount,
                              style: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough))
                                  : const TextSpan(),
                              TextSpan(text: ' ${currentPrice.priceAfterDiscount}'),
                              TextSpan(text: '\n${product.name.toUpperCase()}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
                            ]
                        ),
                        presetFontSizes: [10.sp,9.sp,8.sp,7.sp,6.sp,5.sp],
                        softWrap: true,
                        textAlign: textAlign?? TextAlign.center),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
        loading ? const Align(
          alignment: Alignment.topCenter,
          child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Center(child: CircularProgressIndicator(color: Colors.black))),
        ) : Container()
      ],
    );
  }
}

class ColorCircle{
  Color color;
  late bool isSelected;
  ColorCircle({required this.color, bool? selected}){
    isSelected = selected?? false;
  }
}

class SizeCircle{
  AvailableSize size;
  late bool isSelected;
  SizeCircle({required this.size, bool? selected}){
    isSelected = selected?? false;
  }
}

class SizeRadio extends StatelessWidget {
  SizeCircle item;
  SizeRadio({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IgnorePointer(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: item.isSelected ? Colors.green : Colors.black,
            foregroundColor: item.isSelected ? theme.secondaryHeaderColor : theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.sp), bottomRight: Radius.circular(10.sp)),
            )
          ),
          onPressed: (){}, child: Text(item.size.abbreviation,style: TextStyle(fontSize: 8.sp, fontWeight: item.isSelected ? FontWeight.w700 : null),)),
    );
    //   Container(
    //   width: item.size.abbreviation.length > 1 ? null : 4.h,
    //   padding: EdgeInsets.all(2.w),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10.sp),
    //     color: item.isSelected ? Colors.green : theme.secondaryHeaderColor,
    //   ),
    //   child: Center(child: FittedBox(child: Text(item.size.abbreviation, style:
    //   TextStyle(
    //     fontWeight: FontWeight.w500, color: item.isSelected ? theme.secondaryHeaderColor : theme.primaryColor),
    //     textAlign: TextAlign.center,))),
    // );
  }
}

class CreditCard{
  String number;
  String name;
  String expDate;
  String cvv;
  CardType type;

  CreditCard({
    required this.number,
    required this.name,
    required this.expDate,
    required this.cvv,
    required this.type});
}

class ObscureCard extends StatelessWidget {
  final CreditCard card;
  const ObscureCard({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreditCardWidget(
      cardNumber: card.number,
      expiryDate: card.expDate,
      cardHolderName: card.name,
      cvvCode: card.cvv,
      showBackView: false,
      cardBgColor: Colors.black,
      obscureCardNumber: true,
      obscureInitialCardNumber: true,
      obscureCardCvv: true,
      isHolderNameVisible: true,
      height: 20.h,
      isChipVisible: false,
      isSwipeGestureEnabled: true,
      animationDuration: const Duration(milliseconds: 500),
      frontCardBorder: Border.all(color: Colors.grey),
      backCardBorder: Border.all(color: Colors.grey),
      cardType: card.type,
      onCreditCardWidgetChange: (CreditCardBrand) {},
    );
  }
}

class VisibleCard extends StatelessWidget {
  final CreditCard card;
  const VisibleCard({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreditCardWidget(
      cardNumber: card.number,
      expiryDate: card.expDate,
      cardHolderName: card.name,
      cvvCode: card.cvv,
      showBackView: false,
      cardBgColor: Colors.black,
      obscureCardNumber: false,
      obscureInitialCardNumber: false,
      obscureCardCvv: false,
      isHolderNameVisible: true,
      height: 20.h,
      isChipVisible: false,
      isSwipeGestureEnabled: true,
      animationDuration: const Duration(milliseconds: 500),
      frontCardBorder: Border.all(color: Colors.grey),
      backCardBorder: Border.all(color: Colors.grey),
      cardType: card.type,
      onCreditCardWidgetChange: (CreditCardBrand) {},
    );
  }
}

class CardWidget extends StatefulWidget {
  final CreditCard card;
  const CardWidget({Key? key, required this.card}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: Colors.grey.shade300)
      ),
      child: Column(
        children: [
          ObscureCard(card: widget.card),
          Divider(height: 1.h),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 1.h),
            child: Container(
              height: 3.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Flexible(
                    child: FilledButton(onPressed: (){
                      navKey.currentState?.pushNamed('/cardPage', arguments: widget.card);
                    }, child: Icon(Icons.edit_outlined, size: 17.sp)),
                  ),
                  Flexible(
                    child: FilledButton(onPressed: (){
                      showAlertDialog(context);
                    }, child: Icon(Icons.delete_forever, color: Colors.red, size: 17.sp)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  showAlertDialog(BuildContext context) {

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.sp)
          ),
          title: Text("Delete Card", style: TextStyle(fontSize: 13.sp)),
          content: Text("Are you sure you want to delete this card?",
            style: TextStyle(fontSize: 10.sp),),
          actions: [
            FilledButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed:  () {
                Navigator.of(context).pop(false);
              },
            ),
            FilledButton(
              child: Text("Confirm"),
              onPressed:  () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }
}

class AddressBox extends StatefulWidget {
  final AddressItem item;
  const AddressBox({Key? key, required this.item}) : super(key: key);

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final def =  item.isDefault;
    final BlackBox box = BlackNotifier.of(context);
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.sp),
              border: Border.all(color: Colors.grey.shade300),
              color: def ? Colors.grey.shade300 : Colors.white,
              // gradient: def ? const LinearGradient(colors: [Colors.black, blueColor]) : null
          ),
          padding: EdgeInsets.all(10),
          duration: const Duration(milliseconds: 500),
          child: InkWell(
            onLongPress: (){
              box.setDefault(item);
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(CupertinoIcons.location_solid, color: def ? Colors.black : Colors.grey),
                            SizedBox(width: 2.w,),
                            Text(item.name, style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: def ? Colors.black : Colors.grey,)),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Container(
                          width: 60.w,
                          padding: EdgeInsets.only(left: 1.5.w),
                          child: Text('${item.address}, ${item.details}, ${item.city}, ${item.country}'
                              '${item.zipcode.isNotEmpty ? ', ${item.zipcode}' : ''}',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: def ? 3 : 1,),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        navKey.currentState?.pushNamed('/addressPage', arguments: widget.item);
                      },
                      borderRadius: BorderRadius.circular(5.sp),
                      highlightColor: Colors.greenAccent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.secondaryHeaderColor),
                          borderRadius: BorderRadius.circular(5.sp)
                        ),
                        padding: EdgeInsets.all(5.sp),
                        child: const Icon(Icons.edit_outlined, color: Colors.black,),
                      ),
                    ),
                    SizedBox(width: 1.w,),
                    InkWell(
                      onTap: () async{
                        final c = await showConfirmationBox();
                        if (c) box.deleteAddress(widget.item);
                      },
                      borderRadius: BorderRadius.circular(5.sp),
                      highlightColor: Colors.redAccent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5.sp),
                        ),
                        padding: EdgeInsets.all(5.sp),
                        child: Icon(Icons.delete_forever, color: Colors.red,),
                      ),
                    )
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: def ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.black,),
                              SizedBox(width: 1.w),
                              const Text('Default Address', style: TextStyle(color: Colors.black, fontFamily: '', fontWeight: FontWeight.w700)),
                            ],
                          )
                        ],
                      ) : Container(),
                  )
                )
              ],
            ),
          )
      ),
    );
  }

  Future<bool> showConfirmationBox() async{

    bool confirm = false;
    await showModalBottomSheet(
    backgroundColor: Colors.transparent,

    context: context,
    builder: (context){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 3.h),
        color: Colors.white,
        height: 37.h,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delete Address',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
              SizedBox(height: 5.h,),
              Text('Are you sure you want to delete this address?',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp)),
              SizedBox(height: 1.h,),
              Text('This action is cannot be undone.',
                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade700),),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.sp)
                          )
                      ),
                      onPressed:  () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.sp)
                          )
                      ),
                      onPressed:  () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    ).then((value) => {
      if (value != null && value) confirm = true
    });

    return confirm;
  }


}

void showErrorBar(BuildContext context, String message, {bool? good}) {
  final snackBar = SnackBar(content: Text(message),
      backgroundColor: good?? false ? blueColor : Colors.red);

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget loadingWidget(bool loading, {double? opacity}){
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
    child: loading ? Scaffold(
      backgroundColor: Colors.white.withOpacity(opacity?? 0.5),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    ) : Container(),
  );
}

AppBar MyAppBar({required BuildContext context,
  required BlackBox box,
  bool showCart = true,
  bool showBackBtn = true,
  bool showLogo = true,
  bool homePage = false,
  bool restricted = false,
  String? title}){
  return AppBar(
    automaticallyImplyLeading: false,
    title: SizedBox(
      width: double.infinity,
      height: 8.h,
      child: Stack(
        children: [
          showBackBtn ? Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              highlightColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  if (homePage && !restricted){
                    box.frameKey.currentState!.toggleMenu();
                  }else{
                    Navigator.of(context).pop();
                  }
                },
                onLongPress: (){
                  if (!homePage && !restricted){
                    box.frameKey.currentState!.toggleMenu();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: Icon(homePage ? CupertinoIcons.line_horizontal_3_decrease : CupertinoIcons.back),
                )),
          ) : Container(),
          (title != null) && !showLogo ? Center(
            child: Text(title.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),),
          ) : Container(),
          showLogo ? Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 35.w,
              child: const AspectRatio(aspectRatio:8/30,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
            ),
          ) : Container(),
          showCart ? Align(
            alignment: Alignment.centerRight,
            child: cartWidget(context: context, box: box),
          ) : Container()
        ],
      ),
    ),
  );
}

Widget cartWidget({required BuildContext context, required BlackBox box}){

  return InkWell(
    onTap: (){
      Navigator.of(context).pushNamed('/cart');
    },
    child: SizedBox(
      width: 10.w,
      height: 5.h,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Icon(box.cartLength == 0 ? Icons.shopping_bag_outlined : Icons.shopping_bag, size: 7.w,)),
          box.cartLength == 0 ? Container() : Positioned(
            right: 5,
            bottom: 6,
            child: Container(// This is your Badge
              padding: EdgeInsets.all(1.w),
              constraints: BoxConstraints(maxHeight: 5.w, maxWidth: 5.w),
              decoration: BoxDecoration( // This controls the shadow
                borderRadius: BorderRadius.circular(15.w),
                color: Colors.redAccent,  // This would be color of the Badge
              ),             // This is your Badge
              child: Center(
                // Here you can put whatever content you want inside your Badge
                child: FittedBox(child: Text(box.cartTotal() > 9 ? '9+' : box.cartTotal().toString(), style: TextStyle(color: Colors.black, fontSize: 8.sp, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


