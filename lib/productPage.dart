import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:like_button/like_button.dart';
import 'package:notfound/configurations.dart';
import 'package:notfound/image_storage.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'blackBox.dart';


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
  final int? productId;
  final Product? product;
  final String tag;
  const ProductPage({Key? key, this.productId, this.product, required this.tag}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin{
  int currentImageIndex = 0;
  int previousImageIndex = 0;
  int currentColor = 0;
  int loadingColor = -1;
  List<CachedImage> imageCarousel = [];
  late AnimationController clipperAnimation;
  late BlackBox box;
  late Product mainProduct;
  late String currentImage;
  late String previousImage;
  late List<AvailableColor> colorsList;
  late List<String> imagesList = [];
  List<SizeCircle> goodSizes = [];
  late Price currentPrice;
  late LikeButtonState likeState;
  bool isLiked = false;
  List<ProductElement> mightLikeItems = [];

  ValueNotifier<bool> refreshProduct = ValueNotifier(false);

  bool loading = true;
  bool tapped = false;
  bool nullSpace = true;
  bool onSale = false;
  @override
  void initState(){
    if (widget.product != null){
      mainProduct = widget.product!;
      currentImage = mainProduct.mainPhotoPath;
      previousImage = mainProduct.mainPhotoPath;
      colorsList = mainProduct.availableColors;
      imagesList.add(currentImage);
      imagesList.addAll(mainProduct.photos);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => updateProductInfo());
    }else if (widget.productId != null){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getFullProduct(widget.productId!));
    }else{
      showErrorBar(context, 'Product Unavailable!');
      Navigator.of(context).pop();
    }
    clipperAnimation = AnimationController(
        vsync: this, duration: const Duration(seconds: 1), upperBound: 5)..forward();
    super.initState();
  }

  changeImage(String newImage) {
    imagesList.clear();
    setState(() {
      imagesList.add(mainProduct.mainPhotoPath);
      imagesList.addAll(mainProduct.photos);
    });
    clipperAnimation.forward(from: 0).whenComplete(() {
      if (imagesList.length > previousImageIndex) {
        previousImage = imagesList[previousImageIndex];
      }else{
        previousImage = imagesList.last;
      }
      nullSpace = true;
    });
    updateProductInfo();
  }

  updateLiked() async{
    if (isLiked){
      box.addToLikes(mainProduct.id);
    }else{
      box.removeFromLikes(mainProduct.id);
    }
  }

  updateProductInfo(){
    currentPrice = mainProduct.prices.firstWhere((e) => e.currency == box.currentCurrency);
    isLiked = box.productIsLiked(mainProduct.id);
    goodSizes.clear();
    mightLikeItems.clear();
    goodSizes = List<SizeCircle>.from(mainProduct.availableSizes.where((e) => e.stock > 0).toList().map((e) => SizeCircle(size: e)));
    if (goodSizes.isNotEmpty) goodSizes.first.isSelected = true;
    onSale = int.tryParse(mainProduct.prices.first.priceAfterDiscount)! < int.tryParse(mainProduct.prices.first.priceBeforeDiscount)!;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    box = BlackNotifier.of(context);
    final cartItem = loading ? null : box.itemWhere(mainProduct, chosenSize());
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                loading ? Container(
                  height: 70.h,
                  child: Shimmer(
                    gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade100]),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.sp),
                          color: Colors.white
                      ),
                    ),
                  ),
                ): SizedBox(
                  width: double.infinity,
                  height: 70.h,
                  child: Hero(
                    tag: widget.tag,
                    child: Stack(
                      children: [
                        !nullSpace ? Positioned(
                          child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.sp),
                                child: ImageSlideshow(
                                  width: double.infinity,
                                  height: double.infinity,
                                  initialPage: 0,
                                  indicatorColor: Colors.blue,
                                  indicatorRadius: 5,

                                  children: [
                                    cachedImage(previousImage)
                                  ],
                                ),
                              )),
                        ) : Container(),
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
                                    child:  Builder(
                                      builder: (context) {
                                        return ImageSlideshow(
                                          /// Width of the [ImageSlideshow].
                                          width: double.infinity,
                                          height: double.infinity,
                                          initialPage: 0,
                                          indicatorColor: Colors.blue,
                                          indicatorRadius: 5,
                                          /// The color to paint behind th indicator.
                                          indicatorBackgroundColor: Colors.grey,
                                          /// Called whenever the page in the center of the viewport changes.
                                          onPageChanged: (value) {
                                            setState(() {
                                              previousImage = imagesList[value];
                                              previousImageIndex = value;
                                            });
                                          },
                                          children: List<CachedNetworkImage>.generate(imagesList.length,
                                                  (i) => cachedImage(imagesList[i])),
                                        );
                                      }
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(2.w, 0, 0, 0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20.sp,
                                  spreadRadius: 0),

                                ]
                              ),
                              width: 8.w,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: colorsList.length,
                                  itemBuilder: (context, index){
                                    return GestureDetector(
                                      onTap: tapped ? null : () async{
                                        setState(() {
                                          tapped = true;
                                          loadingColor = index;
                                        });
                                        try{
                                          final newProd = await box.getFullProduct(colorsList[index].productId);
                                          if (newProd != null) {
                                            mainProduct = newProd;
                                            tapped = false;
                                            setState(() {
                                              loadingColor = -1;
                                              nullSpace = false;
                                            });
                                            currentImageIndex = index;
                                            changeImage(mainProduct.mainPhotoPath);
                                            return;
                                          }
                                        }catch (e){
                                          //
                                        }
                                        showErrorBar(context, 'Color not Available!');
                                        setState(() {
                                          loadingColor = -1;
                                          tapped = false;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: currentImageIndex == index ? Colors.black : Colors.transparent,
                                        radius: 15.sp,
                                        child: CircleAvatar(
                                          radius: 11.sp,
                                          backgroundColor: hexToColor(colorsList[index].hexaCode),
                                          child: loadingColor == index ? CircularProgressIndicator(color: Colors.black) : null,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                        ),

                        Positioned(
                            right: 1.w,
                            top: 63.h,
                            child: LikeButton(
                              postFrameCallback: (likeBtnState){
                                likeState = likeBtnState;
                              },
                              onTap: (liked) async{
                                isLiked = !isLiked;
                                updateLiked();
                                return isLiked;
                              },
                              isLiked: isLiked,
                              size: 10.w,
                              circleColor:
                              const CircleColor(start: Colors.pinkAccent, end: Colors.redAccent),
                              bubblesColor: BubblesColor(
                                  dotPrimaryColor: Colors.red.shade300,
                                  dotSecondaryColor: Colors.red.shade700
                              ),
                              likeBuilder: (bool liked) {
                                liked = isLiked;
                                return Icon(
                                  liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                  color: liked ? Colors.redAccent : Colors.grey,
                                  size: 10.w,
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h,),
                loading ? Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.5.h,
                        width: 80.w,
                        child: Shimmer(
                          gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.sp),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        height: 6.h,
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              return Container(
                                padding: EdgeInsets.only(right: 1.w),
                                width: 20.w,
                                child: Shimmer(
                                  gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6.sp), bottomRight: Radius.circular(6.sp)),
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 5.h,
                        child: Shimmer(
                          gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.sp),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : AnimatedBuilder(
                  animation: clipperAnimation,
                  builder: (context, builder) {
                    return FadeTransition(
                      opacity: clipperAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(mainProduct.name.toUpperCase(),),
                              SizedBox(width: 3.w),
                              Text('${currentPrice.currency} ${currentPrice.priceAfterDiscount}',
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                               onSale ?  SizedBox(width: 3.w) : Container(),
                               onSale ? Text('${currentPrice.priceAfterDiscount}',
                                  style: TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough)) : Container()
                            ],
                          ),
                          SizedBox(height: 2.h,),
                          goodSizes.isEmpty ? Container(child: Text(' SOLD OUT ', style: TextStyle(
                            fontWeight: FontWeight.w800, color: Colors.red
                          ),),) :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0,0,3.w, 0),
                                height: 5.h,
                                child: Builder(
                                    builder: (context) {
                                      return ListView.builder(
                                        itemCount: goodSizes.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index){
                                          return InkWell(
                                              borderRadius: BorderRadius.circular(15.sp),
                                              onTap: (){
                                                for (var e in goodSizes) {
                                                  e.isSelected = false;
                                                }
                                                goodSizes[index].isSelected = true;
                                                setState((){});
                                              },
                                              child: Padding(padding: EdgeInsets.all(2.sp), child: SizeRadio(item: goodSizes[index])));
                                        },);
                                    }
                                ),
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: double.infinity,
                                height: 5.h,
                                child: ElevatedButton(onPressed: (){
                                  box.addToCart(context, mainProduct, chosenSize());
                                },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3.sp)
                                        ),
                                      padding: EdgeInsets.all(2.w),
                                    ),
                                    child: Stack(
                                      children: [
                                        cartItem != null ? CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Text(cartItem.quantity.toString()))
                                        : Container(),
                                        Center(child: Text('ADD TO CART', style: TextStyle(color: theme.cardColor),)),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                ),
                SizedBox(height: 5.h,),
                loading ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2.h,
                    child: Shimmer(
                      gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.sp),
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ) : Align(alignment: Alignment.bottomLeft, child: Text(mainProduct.description,
                style: TextStyle(fontWeight: FontWeight.w600),)),
                SizedBox(height: 1.h,),
                loading ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2.h,
                    width: 50.w,
                    child: Shimmer(
                      gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.sp),
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ) : Align(alignment: Alignment.bottomLeft, child: Text(mainProduct.composition,
                    style: TextStyle(fontWeight: FontWeight.w500))),
                SizedBox(height: 3.h,),
                loading ? Container(
                  padding: EdgeInsets.all(2.w),
                  height: 7.h,
                  child: Shimmer(
                    gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.sp),
                          color: Colors.white
                      ),
                    ),
                  ),
                ) : Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.sp)
                    ),
                    onTap: (){
                      showBottomSheet(context: context, builder: (context){
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Scaffold(
                            body: Center(
                              child: Hero(
                                  tag: '${mainProduct.sizeChartPath}-${mainProduct.id}',
                                  child: cachedImage(mainProduct.sizeChartPath)),
                            ),
                          ),
                        );
                      });
                    },
                    title: Text('Size Chart'),
                    trailing: Icon(CupertinoIcons.table_fill),
                  ),
                ),
                SizedBox(height: 5.h),
                loading ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2.h,
                    width: 50.w,
                    child: Shimmer(
                      gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.sp),
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ) : Align(alignment: Alignment.bottomLeft, child: Text('You might also like')),
                SizedBox(
                  height: 30.h,
                  child: loading ?
                  ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.all(2.w),
                        width: 17.h,
                        child: Shimmer(
                          gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade300]),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.sp),
                                color: Colors.white
                            ),
                          ),
                        ),
                      );
                    },
                  ):
                  Builder(
                    builder: (context) {
                      if (mightLikeItems.isEmpty){
                        if (mainProduct.pairWithProducts.isNotEmpty){
                          mightLikeItems =  mainProduct.pairWithProducts;
                        }else{
                          mightLikeItems = getRandomSample(box.pElements, 8);
                        }
                      }
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mightLikeItems.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: EdgeInsets.all(1.w),
                              child: SizedBox(
                                  width: 35.w,
                                  child: CollectionItem(
                                      product: mightLikeItems[index], round: 1,
                                  photoOnly: true,)),
                            );
                          });
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Container(
          width: double.infinity,
          height: 5.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                  child: Icon(CupertinoIcons.back)),
              Spacer(),
              cartWidget(context: context, box: box)
            ],
          ),
        ),
      ),
    );
  }

  getFullProduct(int id)async{
    final prod = await box.getFullProduct(id);
    if (prod != null){
      mainProduct = prod;
      currentImage = mainProduct.mainPhotoPath;
      previousImage = mainProduct.mainPhotoPath;
      colorsList = mainProduct.availableColors;
      imagesList.add(currentImage);
      imagesList.addAll(mainProduct.photos);
      loading = false;
      updateProductInfo();
    }else{
      showErrorBar(context, 'Product Unavailable!');
      Navigator.of(context).pop();
      return;
    }
  }

  AvailableSize? chosenSize() {
    final index = goodSizes.indexWhere((e) => e.isSelected);
    if (index == -1) return null;
    return goodSizes[index].size;
  }

  @override
  void dispose() {
    box.updateCart();
    refreshProduct.dispose();
    clipperAnimation.dispose();
    super.dispose();
  }
}

List<T> getRandomSample<T>(List<T> list, int sampleSize) {
  final length = list.length;

  if (sampleSize >= length) {
    return list; // Return the original list if the sample size is larger or equal to the list length
  }

  final sample = <T>[];

  while (sample.length < sampleSize) {
    final randomIndex = Random().nextInt(length);
    final randomItem = list[randomIndex];

    if (!sample.contains(randomItem)) {
      sample.add(randomItem);
    }
  }

  return sample;
}
