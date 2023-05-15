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
  CreditCard? card;
  CardPage({Key? key, this.card}) : super(key: key);

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
        body: Column(
          children: [
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
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: nameC,
                        decoration: inputDecorationStock(hint: 'Card Holder Name'),
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
                        decoration:inputDecorationStock(hint: 'Card Number'),
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
                              decoration:inputDecorationStock(hint: 'CVV'),
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
                                _showDatePicker();
                                },
                              child: TextFormField(
                                enabled: false,
                                controller: expC,
                                keyboardType: TextInputType.number,
                                decoration: inputDecorationStock(hint: 'Expiry Date'),
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
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.sp)
                              ),
                            ),
                            onPressed: (){},
                            child: Text(newCard ? 'Add New Card' : 'Apply Changes')),
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
  void _showDatePicker() {
    int _selectedMonth;
    int _selectedYear;
    DateTime newDate = DateTime.now();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return Container(
            margin: EdgeInsets.all(5.sp),
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
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
                              borderRadius: BorderRadius.circular(20.0))
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
                              borderRadius: BorderRadius.circular(20.0))
                      ),
                      child: Text('Done',
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontSize: 10.sp,
                        ),),
                    ),
                  ],
                ),
                Flexible(
                  flex: 2,
                  child:extendedPicker.CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
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