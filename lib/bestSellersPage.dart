import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';

class BestSellersPage extends StatefulWidget {
  const BestSellersPage({Key? key}) : super(key: key);

  @override
  State<BestSellersPage> createState() => _BestSellersPageState();
}

class _BestSellersPageState extends State<BestSellersPage> {
  late BlackBox box;

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){},
                    enableFeedback: false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('SHOP ALL', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp)),
                        Icon(Icons.navigate_next, size: 20.sp,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              SizedBox(
                child: GridView.builder(
                    gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.135.w,
                      mainAxisSpacing: 0.w,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder:(context, index){
                      return  CollectionItem(product: box.pElements[0], hasPrice: true, align: Alignment.topLeft,);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
