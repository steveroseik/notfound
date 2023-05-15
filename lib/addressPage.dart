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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Align(alignment: Alignment.bottomLeft, child: Text(newAddress ? 'New Address Details' : 'Change Address Details', style: TextStyle(fontSize: 15.sp),)),
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
                  width: double.maxFinite,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp)
                        ),
                      ),
                      onPressed: (){},
                      child: Text(newAddress ? 'Add New Address' : 'Apply Changes')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
