import 'dart:math';
import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';


class ImageClipper extends CustomClipper<Path> {
  final double animationValue;

  ImageClipper({required this.animationValue});

  @override
  getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCenter(
        center: Offset(0, size.height / 4),
        width: size.width * animationValue,
        height: size.height * animationValue));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class ProductPage extends StatefulWidget {
  final int index;
  final String tag;
  const ProductPage({Key? key, required this.index, required this.tag}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin{
  List<SizeCircle> sizes = [SizeCircle(size: 'L'),
  SizeCircle(size: 'M'),
  SizeCircle(size: 'S')];
  int currentImageIndex = 0;
  int previousImageIndex = 0;
  int currentColor = 0;
  late AnimationController clipperAnimation;


  @override
  void initState(){
    currentImageIndex = widget.index;
    previousImageIndex = widget.index;
    clipperAnimation = AnimationController(
        vsync: this, duration: const Duration(seconds: 1), upperBound: 5);
    super.initState();
  }

  changeImage(int newImageIndex) {
    if (newImageIndex != currentImageIndex) {
      setState(() {
        currentImageIndex = newImageIndex;
      });
      clipperAnimation.forward(from: 0).whenComplete(() {
        setState(() {
          previousImageIndex = currentImageIndex;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 70.h,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Center(
                            child: Hero(
                              tag: widget.tag,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.sp),
                                child: Image.asset(
                                  'assets/images/photos/photo$previousImageIndex.jpg',
                                  key: Key(currentImageIndex.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                        child: AnimatedBuilder(
                          animation: clipperAnimation,
                          builder: (context, child) {
                            return ClipPath(
                              clipper: ImageClipper(
                                  animationValue: clipperAnimation.value),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.sp),
                                  child: Image.asset(
                                      'assets/images/photos/photo$currentImageIndex.jpg',
                                      key: Key(currentImageIndex.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                          left: 2.w,
                          top: 25.h,
                          child: SizedBox(
                            height: 30.h,
                            width: 8.w,
                            child: ListView.builder(
                              itemCount: 3,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    onTap: (){
                                      changeImage(index);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: currentImageIndex == index ? theme.secondaryHeaderColor : Colors.transparent,
                                      child: CircleAvatar(
                                        radius: 11.sp,
                                        backgroundColor: Color(Random().nextInt(0xFFFFFFF)).withAlpha(0xFF),
                                      ),
                                    ),
                                  );
                                }),
                      )),

                      Positioned(
                          right: 1.w,
                          top: 63.h,
                          child: LikeButton(
                            size: 10.w,
                            circleColor:
                            const CircleColor(start: Colors.pinkAccent, end: Colors.redAccent),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: Colors.red.shade300,
                              dotSecondaryColor: Colors.red.shade700
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                color: isLiked ? Colors.redAccent : Colors.grey,
                                size: 10.w,
                              );
                            },
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 2.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SLICED DENIM'),
                    VerticalDivider(color: Colors.black, width: 20,),
                    Text('200 EGP')
                  ],
                ),
                SizedBox(height: 2.h,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 4.5.h,
                        child: ListView.builder(
                            itemCount: sizes.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                  for (var e in sizes) {
                                    e.isSelected = false;
                                  }
                                  sizes[index].isSelected = true;
                                  setState((){});
                                  },
                                  child: Padding(padding: EdgeInsets.all(2.sp), child: SizeRadio(item: sizes[index],)));
                            }),
                      ),
                    ),
                    ElevatedButton(onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondaryHeaderColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.sp)
                          )
                        ),
                        child: Text('ADD TO CART', style: TextStyle(color: theme.cardColor),))
                  ],
                ),
                SizedBox(height: 5.h,),
                Align(alignment: Alignment.bottomLeft, child: Text('DESCRIPTION')),
                Align(alignment: Alignment.bottomLeft, child: Text('All about products')),
                SizedBox(height: 2.h),
                Align(alignment: Alignment.bottomLeft, child: Text('SIZE CHART')),
                SizedBox(height: 5.h),
                Align(alignment: Alignment.bottomLeft, child: Text('You might also like')),
                SizedBox(
                  height: 30.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: EdgeInsets.all(1.w),
                          child: SizedBox(
                              width: 35.w,
                              child: CollectionItem(index: index+1, round: 1)),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                navKey.currentState?.pop();
              },
                child: Icon(CupertinoIcons.back)),
            Spacer(),
            IconButton(onPressed: (){

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
            ))
          ],
        ),
      ),
    );
  }
}
