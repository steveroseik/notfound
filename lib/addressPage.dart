import 'package:flutter/material.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'configurations.dart';

class AddressPage extends StatefulWidget {
  AddressInfo? addressInfo;
  AddressPage({Key? key, this.addressInfo}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  bool newAddress = false;
  TextEditingController zone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController zipCode = TextEditingController();

  @override
  void initState() {
    if (widget.addressInfo != null){
      zone.text = widget.addressInfo!.zone;
      country.text = widget.addressInfo!.country;
      city.text = widget.addressInfo!.city;
      state.text = widget.addressInfo!.state;
      address.text = widget.addressInfo!.address;
      apartment.text = widget.addressInfo!.apartment?? '';
      zipCode.text = widget.addressInfo!.zipCode;
    }else{
      newAddress = true;
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Align(alignment: Alignment.bottomLeft, child: Text(newAddress ? 'New Address Details' : 'Change Address Details',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),)),
                SizedBox(height: 2.h),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: zone,
                  decoration: inputDecorationStock(label: 'Zone'),
                  onChanged: (_){
                  },
                  onTap: (){

                  },
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: country,
                        textInputAction: TextInputAction.next,
                        decoration:inputDecorationStock(label: 'Country'),
                        onChanged: (text){
                          setState(() {});
                        },
                        onTap: (){
                        },
                        onTapOutside: (tap){

                        },
                        onEditingComplete: (){

                        },
                      ),
                    ),
                    SizedBox(width: 1.h),
                    Flexible(
                      child: TextFormField(
                          controller: state,
                          decoration: inputDecorationStock(hint: 'State'),
                          onChanged: (text){
                            setState(() {});
                          }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: city,
                        textInputAction: TextInputAction.next,
                        decoration:inputDecorationStock(label: 'City'),
                        onChanged: (text){
                          setState(() {});
                        },
                        onTap: (){
                        },
                        onTapOutside: (tap){

                        },
                        onEditingComplete: (){

                        },
                      ),
                    ),
                    SizedBox(width: 1.h),
                    Flexible(
                      child: TextFormField(
                          controller: zipCode,
                          decoration: inputDecorationStock(hint: 'Zip Code'),
                          onChanged: (text){
                            setState(() {});
                          }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: address,
                  decoration:inputDecorationStock(label: 'Address'),
                  onChanged: (text){

                  },
                  onTap: (){

                  },
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: apartment,
                  decoration:inputDecorationStock(label: 'Apartment details', hint: 'Apartment, Suit, unit.. (optional)'),
                  onChanged: (text){

                  },
                  onTap: (){

                  },
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: 80.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.sp)
                        ),
                      ),
                      onPressed: (){},
                      child: Text(newAddress ? 'Add New Address' : 'Apply Changes',
                        style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
