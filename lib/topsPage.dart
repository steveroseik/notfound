import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';


class TopsPage extends StatefulWidget {
  const TopsPage({Key? key}) : super(key: key);

  @override
  State<TopsPage> createState() => _TopsPageState();
}



class _TopsPageState extends State<TopsPage> {

  final scrollController = InfiniteScrollController();
  final scrollController2 = InfiniteScrollController();
  final scrollController3 = InfiniteScrollController();
  final CardExtent = 70.w;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
     scrollController.dispose();
     scrollController2.dispose();
     scrollController3.dispose();
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
                SizedBox(
                  height: 40.h,
                  child: InfiniteCarousel.builder(
                    itemCount: 3,
                    controller: scrollController,
                    itemExtent: CardExtent,
                    anchor: 1,
                    velocityFactor: 1,
                    onIndexChanged: (index) {

                    },
                    axisDirection: Axis.horizontal,
                    loop: true,
                    itemBuilder: (context, itemIndex, realIndex) {
                      final currentOffset = CardExtent * realIndex;
                      return AnimatedBuilder(
                        animation: scrollController,
                        builder: (context, child) {
                          final diff = (scrollController.offset - currentOffset);
                          final maxPadding = 3.w;
                          final carouselRatio = CardExtent / maxPadding/2;
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: (diff / carouselRatio).abs(),
                              vertical: (diff / carouselRatio).abs(),
                            ),
                            child: GestureDetector(
                                onTap: (){
                                  if(itemIndex != scrollController.selectedItem){
                                    scrollController.animateToItem(itemIndex);
                                    }
                                  },
                                child: CollectionItem(index: itemIndex, round: 20)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("COLLECTION NAME"),
                SizedBox(
                  height: 30.h,
                  child: InfiniteCarousel.builder(
                    itemCount: 3,
                    controller: scrollController2,
                    itemExtent: CardExtent,
                    anchor: 1,
                    velocityFactor: 1,
                    onIndexChanged: (index) {

                    },
                    axisDirection: Axis.horizontal,
                    loop: false,
                    itemBuilder: (context, itemIndex, realIndex) {
                      final currentOffset = CardExtent * realIndex;
                      return AnimatedBuilder(
                        animation: scrollController2,
                        builder: (context, child) {
                          final diff = (scrollController2.offset - currentOffset);
                          final maxPadding = 3.w;
                          final carouselRatio = CardExtent / maxPadding/2;
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: (diff / carouselRatio).abs(),
                              vertical: (diff / carouselRatio).abs(),
                            ),
                            child: GestureDetector(
                                onTap: (){
                                  if(itemIndex != scrollController2.selectedItem){
                                    scrollController2.animateToItem(itemIndex);
                                  }

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20.sp)
                                  ),
                                )),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("COLLECTION NAME"),
                SizedBox(
                  height: 30.h,
                  child: InfiniteCarousel.builder(
                    itemCount: 3,
                    controller: scrollController3,
                    itemExtent: CardExtent,
                    anchor: 1,
                    velocityFactor: 1,
                    onIndexChanged: (index) {

                    },
                    axisDirection: Axis.horizontal,
                    loop: false,
                    itemBuilder: (context, itemIndex, realIndex) {
                      final currentOffset = CardExtent * realIndex;
                      return AnimatedBuilder(
                        animation: scrollController3,
                        builder: (context, child) {
                          final diff = (scrollController3.offset - currentOffset);
                          final maxPadding = 3.w;
                          final carouselRatio = CardExtent / maxPadding/2;
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: (diff / carouselRatio).abs(),
                              vertical: (diff / carouselRatio).abs(),
                            ),
                            child: GestureDetector(
                                onTap: (){
                                  if(itemIndex != scrollController3.selectedItem){
                                    scrollController3.animateToItem(itemIndex);
                                  }

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20.sp)
                                  ),
                                )),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
