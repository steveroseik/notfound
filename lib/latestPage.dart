import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';


class LatestPage extends StatefulWidget {
  const LatestPage({Key? key}) : super(key: key);

  @override
  State<LatestPage> createState() => _LatestPageState();
}



class _LatestPageState extends State<LatestPage> {

  final CardExtent = 70.w;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                      height: 50.h,
                      viewportFraction: 0.5,
                      animateToClosest: true,
                      enlargeFactor: 0.2,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      CollectionItem(
                        index: itemIndex,
                        round: 2.sp,
                        hasPrice: true,
                        labelText: 'New',),
                ),
              ],
            ),
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                      height: 50.h,
                      viewportFraction: 0.5,
                      animateToClosest: true,
                      enlargeFactor: 0.2,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      CollectionItem(
                        index: itemIndex,
                        round: 2.sp,
                        hasPrice: true,
                        labelText: 'Sale',),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                      height: 45.h,
                      viewportFraction: 0.5,
                      animateToClosest: true,
                      enlargeFactor: 0.2,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                          onTap: (){
                            // if(itemIndex != scrollController.selectedItem){
                            //   scrollController.animateToItem(itemIndex);
                            // }
                          },
                          child: CollectionItem(index: itemIndex+6, round: 2.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
