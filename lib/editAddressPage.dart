import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'objects.dart';

class EditAddressPage extends StatefulWidget {
  final bool? showCart;
  const EditAddressPage({Key? key, this.showCart}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  bool visible = false;
  late List<AddressItem> addresses;

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final BlackBox box = BlackNotifier.of(context);
    addresses = box.addresses;
    return Scaffold(
      appBar: MyAppBar(context: context, box: box, showCart: widget.showCart?? true),
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
                  icon: const Icon(Icons.add_card, color: Colors.white,),
                  label: const Text('Add New Address', style: TextStyle(color: Colors.white),)
              ),
            ),
            SizedBox(height: 3.h),
            addresses.isNotEmpty ? Text('Long press to set as default address',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade600),) : Container(),
            SizedBox(height: 2.h),
            addresses.isEmpty ? const Center(
              child: Text('No address added yet!',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),),
            ) :
            SizedBox(
              height: 50.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 3.w),
                      child: AddressBox(item: addresses[index]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
