import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
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

                  },
                  icon: Icon(Icons.add_card),
                  label: Text('Add New Address')
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 50.h,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index){
                    return InkWell(
                        onTap: (){
                          setState(() {
                            visible = !visible;
                          });
                        },
                        child: AddressItem(visible: visible));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
