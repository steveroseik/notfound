import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';


class TopsPage extends StatefulWidget {
  const TopsPage({Key? key}) : super(key: key);

  @override
  State<TopsPage> createState() => _TopsPageState();
}



class _TopsPageState extends State<TopsPage> {

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
            SizedBox(height: 15.h),
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                      height: 30.h,
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
                          child: CollectionItem(index: itemIndex, round: 2.sp)),
                ),
              ],
            ),
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 15,
                  options: CarouselOptions(
                    enlargeFactor: 0.5,
                    enableInfiniteScroll: true
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                          onTap: (){
                            // if(itemIndex != scrollController2.selectedItem){
                            //   scrollController2.animateToItem(itemIndex);
                            // }

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.sp)
                            ),
                          )),
                ),
              ],
            ),
            Column(
              children: [
                Text("COLLECTION NAME"),
                CarouselSlider.builder(
                  itemCount: 15,
                  options: CarouselOptions(
                      enlargeFactor: 0.5,
                      enableInfiniteScroll: true
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      GestureDetector(
                          onTap: (){
                            // if(itemIndex != scrollController2.selectedItem){
                            //   scrollController2.animateToItem(itemIndex);
                            // }

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.sp)
                            ),
                          )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
