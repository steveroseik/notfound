import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:sizer/sizer.dart';
import 'productPage.dart';



class CollectionItem extends StatelessWidget {
  final int index;
  double? round;
  double? width;
  CollectionItem({Key? key, required this.index, this.round, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String rand = 'assets/images/photos/photo${index}.jpg';
    final tag = Random().nextDouble().toString();
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: (){
              navKey.currentState?.pushNamed('/productPage', arguments: [index, tag]);
            },
            child: Hero(
              tag: tag,
              child: ClipRRect(
                  borderRadius: round != null ? BorderRadius.circular(round!.sp) : BorderRadius.circular(0),
                  child: Image.asset(rand, fit: BoxFit.cover,)),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width != null ? width! / 10 : 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(fit: BoxFit.fitWidth, child: Text('Product Name \n \$1200', textAlign: TextAlign.center,)),
                  ],
                ))),
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
  String size;
  late bool isSelected;
  SizeCircle({required this.size, bool? selected}){
    isSelected = selected?? false;
  }
}

class SizeRadio extends StatefulWidget {
  SizeCircle item;
  SizeRadio({Key? key, required this.item}) : super(key: key);

  @override
  State<SizeRadio> createState() => _SizeRadioState();
}

class _SizeRadioState extends State<SizeRadio> {
  late SizeCircle circle = widget.item;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: 15.sp,
      backgroundColor: circle.isSelected ? Colors.green : theme.textSelectionTheme.selectionColor,
      child: Text(circle.size, style: TextStyle(fontWeight: FontWeight.w500, color: circle.isSelected ? Colors.black : theme.textSelectionTheme.selectionHandleColor, ),),
    );
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

class AddressInfo{
  String zone;
  String country;
  String city;
  String state;
  String address;
  String? apartment;
  String? note;
  String zipCode;

  AddressInfo(this.zone, this.country, this.city, this.state, this.address,
    this.zipCode, this.apartment, this.note);
}

class AddressItem extends StatefulWidget {
  final bool visible;
  const AddressItem({Key? key, required this.visible}) : super(key: key);

  @override
  State<AddressItem> createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {

  bool _visible = false;
  bool _visible1 = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.visible && !_visible) _toggleDefault();
    if (!widget.visible && _visible1) _toggleDefault();
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.sp),
              border: Border.all(color: Colors.grey.shade300)
          ),
          padding: EdgeInsets.all(10),
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.location_solid, color: Colors.grey),
                          SizedBox(width: 2.w,),
                          Text('My Home', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w800, color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text('12 Bay Street, Cairo, Egypt',
                          style: TextStyle(fontFamily: '', fontWeight: FontWeight.w500),),),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: Colors.greenAccent,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.textSelectionTheme.selectionColor!),
                        borderRadius: BorderRadius.circular(10.sp)
                      ),
                      padding: EdgeInsets.all(5.sp),
                      child: Icon(Icons.edit_outlined),
                    ),
                  ),
                  SizedBox(width: 1.w,),
                  InkWell(
                    onTap: (){
                    },
                    borderRadius: BorderRadius.circular(10.sp),
                    highlightColor: Colors.redAccent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.sp)
                      ),
                      padding: EdgeInsets.all(5.sp),
                      child: Icon(Icons.delete_forever, color: Colors.red,),
                    ),
                  )
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _visible1 ? 5.h : 0,
                onEnd: (){
                  if (_visible1 && !_visible){
                    setState(() {
                      _visible = !_visible;
                    });
                  }
                },
                child: AnimatedOpacity(
                    opacity: _visible ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    onEnd: (){
                      if (_visible1 && !_visible){
                        setState(() {
                          _visible1 = !_visible1;
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Row(
                          children: [
                            Icon(CupertinoIcons.checkmark_alt_circle_fill),
                            SizedBox(width: 1.w),
                            Text('Default Address', style: TextStyle(fontFamily: '', fontWeight: FontWeight.w700)),
                          ],
                        )
                      ],
                    )),
              )
            ],
          )
      ),
    );
  }

  _toggleDefault(){
    setState(() {
      if (!_visible1){
        _visible1 = !_visible1;
      }else{
        _visible = !_visible;
      }

    });
  }
}


