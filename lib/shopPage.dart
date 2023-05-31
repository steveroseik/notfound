import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/routesGenerator.dart';
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
     appBar: AppBar(
       title: Row(
         children: [
           Container(height: 20.h,
               child: Image(image: AssetImage('assets/images/logo.png'))),
           Spacer(),
           Align(
             alignment: Alignment.topLeft,
             child: IconButton(onPressed: (){
               // print(FirebaseAuth.instance.currentUser!.uid);
               if (FirebaseAuth.instance.currentUser != null){
                 FirebaseAuth.instance.signOut();
               }else{
                 if (box.isGuest) box.setGuest(false);
               }

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
