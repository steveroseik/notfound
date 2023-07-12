import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'mainFrame.dart';


class ShopPage extends StatefulWidget {
  final GlobalKey<MainFrameState> menuKey;
  const ShopPage({Key? key, required this.menuKey}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List<String> categoriesList = ['TOPS', 'BOTTOMS', 'SETS', 'DENIM', 'HOODIES'];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final box = BlackNotifier.of(context);
    return Scaffold(
     appBar: MyAppBar(context: context, box: box),
     body: SingleChildScrollView(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 2.h),
         child: Column(
           children: [
             Hero(
               tag: 'SG_1',
               child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: 5.w),
                 child: InkWell(
                   onTap: (){
                     navKey.currentState?.pushNamed('/search');
                   },
                   child: Row(
                     children: [
                       Flexible(
                         fit: FlexFit.tight,
                         flex: 5,
                         child: IgnorePointer(
                           ignoring: true,
                           child: TextFormField(
                             decoration: InputDecoration(
                                 prefixIconColor: Colors.grey,
                                 prefixIcon: Icon(CupertinoIcons.search, size: 15.sp,) ,
                                 hintText: ' Search',
                                 hintStyle: TextStyle(fontSize: 10.sp),
                                 border: const UnderlineInputBorder(
                                     borderSide: BorderSide(
                                       width: 1,
                                     )
                                 ),
                                 focusedBorder: const UnderlineInputBorder()
                             ),
                           ),
                         ),
                       )
                     ],
                   ),
                 ),
               ),
             ),
             SizedBox(height: 4.h),
             ListView.builder(
               itemCount: categoriesList.length,
               shrinkWrap: true,
               itemBuilder: (context, index){
                 return Container(
                   height: 10.h,
                   margin: EdgeInsets.only(bottom: 2.h),
                   child: FilledButton(

                     style: FilledButton.styleFrom(
                       backgroundColor: Colors.grey.shade300,
                       foregroundColor: blueColor,
                       surfaceTintColor: blueColor,
                       shape: RoundedRectangleBorder()
                     ),
                     onPressed: (){},
                     child: Text(categoriesList[index],
                       style: TextStyle(color: darkGreyColor, fontWeight: FontWeight.w700, fontSize: 15.sp),),
                   ),
                 );
             }),
           ],
         ),
       ),
     ),
    );
  }
}
