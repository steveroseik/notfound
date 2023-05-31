import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({Key? key}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: 3.h,),
            SizedBox(
              width: double.maxFinite,
              child: FilledButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.sp),
                    ),
                    backgroundColor: blueColor
                  ),
                  onPressed: (){
                    navKey.currentState?.pushNamed('/addressPage');
                  },
                  icon: Icon(Icons.add_card, color: Colors.white,),
                  label: Text('Add New Address', style: TextStyle(color: Colors.white),)
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
                        child: AddressItem(defaultAdd: visible));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
