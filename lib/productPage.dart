import 'dart:math';
import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
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
                      bottom: 0,
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
                                  backgroundColor: currentImageIndex == index ? theme.textSelectionTheme.selectionColor : Colors.transparent,
                                  child: CircleAvatar(
                                    radius: 11.sp,
                                    backgroundColor: Color(Random().nextInt(0xFFFFFFF)).withAlpha(0xFF),
                                  ),
                                ),
                              );
                            }),
                  )),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.heart)))
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
                      backgroundColor: theme.textSelectionTheme.selectionColor,
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
            Align(alignment: Alignment.bottomLeft, child: Text('SIZE CHART'))
          ],
        ),
      ),
    );
  }
}
