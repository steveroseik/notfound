import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/main.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';
import 'blackBox.dart';

class ProductsViewPage extends StatefulWidget {
  final Collection? collection;
  final Category? category;
  final List<ProductElement>? productList;
  final bool? fav;
  const ProductsViewPage({super.key, this.collection,
    this.productList, this.category, this.fav});

  @override
  State<ProductsViewPage> createState() => _ProductsViewPageState();
}

class _ProductsViewPageState extends State<ProductsViewPage> {
  late BlackBox box;
  bool loading = false;
  bool fromCollection = true;

  List<ProductElement> products = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => refreshProduct());
    super.initState();
  }

  refreshProduct(){
    if (widget.collection != null){
      products = box.productsWithinCollection(widget.collection!.id);
    }else if (widget.category != null){
      products = box.productsWithinCategory(widget.category!.id);

    }else if (widget.fav?? false){
      products = box.likedProductsItems();
    }

    if (products.isEmpty){
      Future.delayed(const Duration(milliseconds: 200)).then((value){
        Navigator.of(context).pop(false);
      });
    }

    if (loading && mounted){
      setState(() {
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    refreshProduct();
    return Scaffold(
      appBar: MyAppBar(context: context, box: box),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'SG_1',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed('/search');
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
            SizedBox(height: 3.h),
            Builder(
              builder: (context) {
                return products.isEmpty ?
                SizedBox(
                  height: 10.h,
                  child: Center(

                    child: Text('NO PRODUCTS TO DISPLAY',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 8.sp,
                            color: Colors.grey
                        ),),
                  ),
                ) :
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        widget.collection != null ?
                        SizedBox(
                          height: 15.h,
                          width: 98.w,
                          child: Stack(
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: cachedImage(widget.collection!.bannerPhoto)
                              ),
                              Center(child: Text(widget.collection!.name.toUpperCase(),
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
                        ): Container(),
                        SizedBox(height: 3.h),
                        Builder(
                          builder: (context) {
                            return LayoutBuilder(
                                builder: (context, constraints) {
                                  return GridView.builder(
                                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,
                                        crossAxisSpacing: 1.w,
                                        childAspectRatio: 2 / 4,
                                        mainAxisSpacing: 0,
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: products.length,
                                      itemBuilder:(context, index){
                                        return  CollectionItem(
                                          product: products[index],
                                          hasPrice: true,
                                          align: Alignment.topLeft,
                                          textAlign: TextAlign.left,
                                          flaggedLabel: true,);
                                      });
                                }
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),

          ],
        ),
      ),
    );
  }
}
