import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'configurations.dart';

class AddressPage extends StatefulWidget {
  final AddressItem? item;
  const AddressPage({Key? key, this.item}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {


  late BlackBox box;

  bool newAddress = false;
  TextEditingController zone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController apartment = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController name = TextEditingController();


  final ScrollController _scrollController = ScrollController();

  List<String> addressNameSuggestions = [
    'Home',
    'Work',
    'Office',
    'School',
    'Vacation Home',
    "Parent's House",
    "Friend's House",
    'Favorite Place',
    'Business Client',
    'Other',
  ];

  @override
  void initState() {
    if (widget.item != null){
      zone.text = widget.item!.zone;
      country.text = widget.item!.country;
      city.text = widget.item!.city;
      state.text = widget.item!.state;
      address.text = widget.item!.address;
      apartment.text = widget.item!.details;
      zipCode.text = widget.item!.zipcode;
      name.text = widget.item!.name;
    }else{
      newAddress = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    zipCode.dispose();
    apartment.dispose();
    state.dispose();
    city.dispose();
    country.dispose();
    zone.dispose();
    address.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: MyAppBar(context: context, box: box),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Align(alignment: Alignment.bottomLeft, child: Text(newAddress ? 'New Address Details' : 'Change Address Details',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),)),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: (){
                    showZonePicker(context);
                  },
                  child: TextFormField(
                    enabled: false,
                    style: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.next,
                    controller: zone,
                    decoration: inputDecorationStock(label: 'Zone'),
                    onChanged: (_){
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text){
                      if (text == null || text.isEmpty) return '';
                      return null;
                    },
                    onTap: (){

                    },
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child,),
                      child: (zone.text == 'Other') ? Column(
                        children: [
                          SizedBox(height: 1.h),
                          InkWell(
                            onTap: (){
                              selectCountry();
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: country,
                              style: const TextStyle(color: Colors.black),
                              textInputAction: TextInputAction.next,
                              decoration:inputDecorationStock(label: 'Country'),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text){
                                if (text == null || text.isEmpty) return '';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ) : Container()),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child,),
                    child: zone.text == 'United States' ||
                        zone.text == 'Other' ? Column(
                      children: [
                        SizedBox(height: 1.h),
                        TextFormField(
                          controller: state,
                          decoration: inputDecorationStock(hint: 'State'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text){
                            if (text == null || text.isEmpty) return '';
                            return null;
                          },
                        ),
                      ],
                    ) : Container(),
                  ),
                ),
                zone.text == 'United States' ||
                    zone.text == 'Other' ? SizedBox(height: 1.h) : Container(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child,),
                    child:  zone.text == 'United States' ||
                        zone.text == 'Other' ? Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: city,
                            textInputAction: TextInputAction.next,
                            decoration:inputDecorationStock(label: 'City'),
                            inputFormatters: [LengthLimitingTextInputFormatter(15)],
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if (text == null || text.length < 2) return '';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 1.h),
                        Flexible(
                          child: TextFormField(
                            controller: zipCode,
                            decoration: inputDecorationStock(hint: 'Zip Code'),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [LengthLimitingTextInputFormatter(15)],
                            validator: (text){
                              if (text == null || text.isEmpty) return '';
                              return null;
                            },
                          ),
                        )
                      ],
                    ) : Container(),
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: address,
                  decoration:inputDecorationStock(label: 'Address'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [AddressInputFormatter(), LengthLimitingTextInputFormatter(100)],
                  validator: (text){
                    if (text == null || text.length < 5) return '';
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: apartment,
                  decoration:inputDecorationStock(label: 'Apartment details', hint: 'Apartment, Suit, unit.. (optional)'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [AddressInputFormatter(), LengthLimitingTextInputFormatter(50)],
                  validator: (text){
                    if (text == null || text.isEmpty) return '';
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: name,
                  decoration:inputDecorationStock(label: 'Name', hint: "Home, Work, Office, ..."),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [AddressInputFormatter()],
                  onTap: (){
                    Future.delayed(const Duration(milliseconds: 500)).then((value) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });

                  },
                  validator: (text){
                    if (text == null || text.isEmpty) return '';
                    return null;
                  },
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text('Name Suggestions', style: TextStyle(fontSize: 10.sp),)),
                SizedBox(height: 0.5.h),
                SizedBox(
                  height: 3.5.h,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: addressNameSuggestions.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){
                          name.text = addressNameSuggestions[index];
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 1.w, 0),
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
                          padding: EdgeInsets.all(2.w),
                          child: FittedBox(child: Text(addressNameSuggestions[index],
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),)),
                        ),
                      );
                    },
                  ),
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
                      onPressed: (){
                        if (newAddress){
                          submitNewAddress();
                        }else{
                          updateAddress();
                        }
                      },
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

  selectCountry(){
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500, // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(1),
          topRight: Radius.circular(1),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country c) => country.text = c.name,
    );
  }
  showZonePicker(context) async{

    int number = 0;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,

        context: context,
        builder: (context){
          return Container(
            color: Colors.white,
            height: 37.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Row(
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1.sp)
                              )
                          ),
                          onPressed:  () {
                            Navigator.of(context).pop(-1);
                          },
                          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.sp)
                            )
                          ),
                          onPressed:  () {
                            Navigator.of(context).pop(number);
                          },
                          child: const Text("Done", style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                  child: CupertinoPicker(
                    magnification: 1.2,
                    backgroundColor: Colors.white,
                    itemExtent: 50, //height of each item
                    looping: true,
                    children: [
                      Center(
                        child: Text('Cairo',
                          style: TextStyle(fontSize: 15.sp),),
                      ),
                      Center(
                        child: Text('Alexandria',
                          style: TextStyle(fontSize: 15.sp),),
                      ),
                      Center(
                        child: Text('North Coast',
                          style: TextStyle(fontSize: 15.sp),),
                      ),
                      Center(
                        child: Text('United States',
                          style: TextStyle(fontSize: 15.sp),),
                      ),
                      Center(
                        child: Text('Other',
                          style: TextStyle(fontSize: 15.sp),),
                      ),
                    ],
                    onSelectedItemChanged: (index) {
                      number = index;
                    },
                  ),
                ),
              ],
            ),
          );
        }
    ).then((value) {
      if (value != null){
        switch(value as int){
          case -1:
            break;
          case 0:
            {
              zone.text = 'Cairo';
              country.text = 'Egypt';
              city.text = 'Cairo';
            }
            break;
          case 1:
            {
              zone.text = 'Alexandria';
              country.text = 'Egypt';
              city.text = 'Alexandria';
            }
            break;
          case 2:
            {
              zone.text = 'North Coast';
              country.text = 'Egypt';
              city.text = 'North Coast';
            }
            break;
          case 3:
            {
              zone.text = 'United States';
              country.text = 'United States';
              city.text = '';
            }
            break;
          case 4:
            {
              zone.text = 'Other';
              country.text = '';
              city.text = '';
            }
            break;
        }
        state.text = '';
        zipCode.text = '';
        setState(() {});
      }
    });
  }

  submitNewAddress() async{
    bool validAddress = true;
    if (zone.text.isEmpty) {
      showErrorBar(context, 'Complete Your Address Info');
      return;
    }
    switch(zone.text){
      case 'Other':
        {
          if (country.text.isEmpty) validAddress = false;
          if (state.text.isEmpty) validAddress = false;
          if (city.text.length < 2) validAddress = false;
          if (zone.text.isEmpty) validAddress = false;
          if (zipCode.text.isEmpty) validAddress = false;
        }
        break;
      case 'United States':
        {
          if (state.text.isEmpty) validAddress = false;
          if (city.text.length < 2) validAddress = false;
          if (zone.text.isEmpty) validAddress = false;
          if (zipCode.text.isEmpty) validAddress = false;
        }
        break;
    }
    if (address.text.length < 5) validAddress = false;
    if (apartment.text.isEmpty) validAddress = false;
    if (name.text.isEmpty) validAddress = false;

    if (!validAddress){
      showErrorBar(context, 'Please complete all address details.');
      return;
    }

    try{
      final userId = box.userId;
      if (userId == null){
        showErrorBar(context, 'Something went wring');
        box.signOut();
        return;
      }

      final now = DateTime.now();
      final newData = {
        'zone': zone.text,
        'country': country.text,
        'state': state.text,
        'city': city.text,
        'zipCode': zipCode.text,
        'address': address.text,
        'details': apartment.text,
        'name': name.text,
        'lastModified': Timestamp.fromDate(now),
        'isDefault': !box.hasDefaultAddress
      };

      final ref = await FirebaseFirestore.instance
          .collection('users/$userId/addresses')
          .add(newData);
      box.addNewAddress(AddressItem.fromShot(newData, ref.path));
      navKey.currentState?.pop();
    }catch(e){
      print(e);
    }
  }

  updateAddress() async{
    bool validAddress = true;
    if (zone.text.isEmpty) {
      showErrorBar(context, 'Complete Your Address Info');
      return;
    }
    switch(zone.text){
      case 'Other':
        {
          if (country.text.isEmpty) validAddress = false;
          if (state.text.isEmpty) validAddress = false;
          if (city.text.length < 2) validAddress = false;
          if (zone.text.isEmpty) validAddress = false;
          if (zipCode.text.isEmpty) validAddress = false;
        }
        break;
      case 'United States':
        {
          if (state.text.isEmpty) validAddress = false;
          if (city.text.length < 2) validAddress = false;
          if (zone.text.isEmpty) validAddress = false;
          if (zipCode.text.isEmpty) validAddress = false;
        }
        break;
    }
    if (address.text.length < 5) validAddress = false;
    if (apartment.text.isEmpty) validAddress = false;
    if (name.text.isEmpty) validAddress = false;

    if (!validAddress){
      showErrorBar(context, 'Please complete all address details.');
      return;
    }

    try{
      final userId = box.userId;
      if (userId == null){
        showErrorBar(context, 'Something went wring');
        box.signOut();
        return;
      }

      final now = DateTime.now();
      final newData = {
        'zone': zone.text,
        'country': country.text,
        'state': state.text,
        'city': city.text,
        'zipCode': zipCode.text,
        'address': address.text,
        'details': apartment.text,
        'name': name.text,
        'lastModified': Timestamp.fromDate(now),
        'isDefault': widget.item!.isDefault
      };

      await FirebaseFirestore.instance
          .doc(widget.item!.id)
          .update(newData);
      final newAddressDetails = AddressItem.fromShot(newData, widget.item!.id);
      box.updateAddress(newAddressDetails);

      navKey.currentState?.pop();
    }catch(e){
      print(e);
    }
  }
}
