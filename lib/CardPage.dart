import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:notfound/configurations.dart';
import 'package:intl/intl.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:notfound/ExtendedPicker.dart' as extendedPicker;

class CardPage extends StatefulWidget {
  final CreditCard? card;
  const CardPage({Key? key, this.card}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {

  bool newCard = true;
  bool showCardBack = false;
  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController cvvC = TextEditingController();
  TextEditingController expC = TextEditingController();
  CardType type = CardType.mastercard;

  @override
  void initState() {
    if (widget.card != null){
      newCard = false;
      nameC.text = widget.card!.name;
      numberC.text = widget.card!.number;
      cvvC.text = widget.card!.cvv;
      expC.text = widget.card!.expDate;
      type = widget.card!.type;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: SizedBox(
                  width: 30.w,
                  child: AspectRatio(aspectRatio:8/30,
                      child: Image(image: AssetImage('assets/images/logo.png'))),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){

                }, icon: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        child: Icon(Icons.shopping_cart, size: 7.w,)),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(// This is your Badge
                        padding: EdgeInsets.all(1.w),
                        constraints: BoxConstraints(maxHeight: 5.w, maxWidth: 5.w),
                        decoration: BoxDecoration( // This controls the shadow
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 5,
                                color: Colors.black.withAlpha(50))
                          ],
                          borderRadius: BorderRadius.circular(15.w),
                          color: Colors.grey.shade600,  // This would be color of the Badge
                        ),             // This is your Badge
                        child: Center(
                          // Here you can put whatever content you want inside your Badge
                          child: Text('9+', style: TextStyle(color: Colors.white, fontSize: 5.sp)),
                        ),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 3.h),
            CreditCardWidget(
              cardNumber: numberC.text,
              expiryDate: expC.text,
              cardHolderName: nameC.text.toUpperCase(),
              labelCardHolder: "CARD HOLDER NAME",
              cvvCode: cvvC.text,
              showBackView: showCardBack,
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
              cardType: type,
              onCreditCardWidgetChange: (creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: nameC,
                        decoration: inputDecorationStock(label: "Name"),
                        onChanged: (_){
                          setState(() {});
                        },
                        onTap: (){
                          setState(() {
                            showCardBack = false;
                          });
                        },
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: numberC,
                        inputFormatters: [CreditCardNumberFormatter()],
                        keyboardType: TextInputType.number,
                        decoration:inputDecorationStock(hint: '5678 9012 3456 7890', label: "Card Number"),
                        onChanged: (text){
                          List<CreditCardType> newType = detectCCType(text);
                          if (newType.length == 1){
                            switch(newType[0].type){
                              case 'visa' : type = CardType.visa;
                              break;
                              case 'mastercard': type = CardType.mastercard;
                              break;
                              case 'hiper': type = CardType.hipercard;
                              break;
                              case 'discover': type = CardType.discover;
                              break;
                              case 'unionpay': type = CardType.unionpay;
                              break;
                              default:
                                type = CardType.mastercard;
                            }
                          }
                          setState(() {});
                        },
                        onTap: (){
                          setState(() {
                            showCardBack = false;
                          });
                        },
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: cvvC,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration:inputDecorationStock(label: 'CVC'),
                              onChanged: (text){
                                setState(() {});
                              },
                              onTap: (){
                                setState(() {
                                  showCardBack = true;
                                });
                              },
                              onTapOutside: (tap){
                                setState(() {
                                  showCardBack = false;
                                });
                              },
                              onEditingComplete: (){
                                setState(() {
                                  showCardBack = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 1.h),
                          Flexible(
                            child: GestureDetector(
                              onTap: (){
                                _showCardDatePicker();
                                },
                              child: TextFormField(
                                enabled: false,
                                controller: expC,
                                keyboardType: TextInputType.number,
                                decoration: inputDecorationStock(hint: 'Expiry Date', label: 'Exp Date'),
                                onChanged: (text){
                                  setState(() {});
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.sp)
                              ),
                            ),
                            onPressed: (){},
                            child: Text(newCard ? 'Add New Card' : 'Apply Changes', style: TextStyle(color: Colors.white),)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showCardDatePicker() {
    final now = DateTime.now();
    int _selectedMonth;
    int _selectedYear;
    DateTime newDate = DateTime.now();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(5.sp),topLeft: Radius.circular(5.sp)),
                color: Colors.white
            ),
            height: MediaQuery
                .of(context)
                .copyWith()
                .size
                .height * 0.35,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp))
                      ),
                      child: Text('Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop(DateFormat('MM/yy').format(newDate));

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.sp)),
                      ),
                      child: Text('Done',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 10.sp,
                        ),),
                    ),
                  ],
                ),
                Flexible(
                  flex: 2,
                  child:extendedPicker.CupertinoDatePicker(
                    initialDateTime: now,
                    minimumDate: now,
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedMonth = newDateTime.month;
                        _selectedYear = newDateTime.year;
                        newDate = newDateTime;
                      });
                    },
                    mode: extendedPicker.CupertinoDatePickerMode.date,
                    use24hFormat: false,
                    backgroundColor: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          );
        }).then((value) {
      if (value != null){
        setState(() {
          expC.text = value;
        });
      }
    });
  }
}