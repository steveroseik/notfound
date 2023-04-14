import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class EditCardsPage extends StatefulWidget {
  const EditCardsPage({Key? key}) : super(key: key);

  @override
  State<EditCardsPage> createState() => _EditCardsPageState();
}

class _EditCardsPageState extends State<EditCardsPage> {
  CreditCard card = CreditCard(number: "55555555",
      name: "Steve Roseik", expDate: "12/24", cvv: "887", type: CardType.mastercard);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp)
                    ),
                  ),
                onPressed: (){
                    navKey.currentState?.pushNamed('/cardPage');
                },
                icon: Icon(Icons.add_card),
                label: Text('Add New Card')
              ),
            ),
            SizedBox(height: 5.h,),
            CardWidget(card: card)
          ],
        ),
      ),
    );
  }
}
