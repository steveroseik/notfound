import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';
import 'objects.dart';


class LatestPage extends StatefulWidget {
  const LatestPage({Key? key}) : super(key: key);

  @override
  State<LatestPage> createState() => _LatestPageState();
}



class _LatestPageState extends State<LatestPage> {

  final CardExtent = 70.w;
  late BlackBox box;


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
    box = BlackNotifier.of(context);
    return ValueListenableBuilder(
      valueListenable: box.cacheFinished,
      builder: (context, value, child) {

        return !value ? loadingWidget(true) : SingleChildScrollView(
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
              SizedBox(height: 2.h,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: box.collections.length,
                  itemBuilder: (context, index){
                    final collProducts = box.productsWithinCollection(box.collections[index].id);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 25.h,
                          width: 98.w,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: cachedImage(box.collections[index].bannerPhoto)
                              ),
                              Center(child: Text(box.collections[index].name.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, color: Colors.white, fontSize: 25.sp,
                                    shadows: const <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3,
                                        color: Colors.black26,
                                      )
                                    ],),))
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/productsView', arguments: box.collections[index]);
                            },
                            child: Text('View All')),
                        SizedBox(height: 3.h),
                        CarouselSlider.builder(
                          itemCount: min(collProducts.length, 3),
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
                                product: collProducts[itemIndex],
                                round: 2.sp,
                                hasPrice: true),
                        ),
                      ],
                    );
                  }),
              SizedBox(height: 4.h),
            ],
          ),
        );
      }
    );
  }
}
