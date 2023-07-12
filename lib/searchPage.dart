import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notfound/blackBox.dart';
import 'package:notfound/objects.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/searchEngine.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();


}

class _SearchPageState extends State<SearchPage> {

  int index = 0;

  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  late BlackBox box;

  bool hasText = false;
  CharNode searchNode = CharNode();
  ValueNotifier<bool> refresher = ValueNotifier(false);
  List<ProductElement> results = [];
  bool tapped = false;
  bool start = true;


  double roundDouble(double value, int places){
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  Future<List<double>>_updatePaletteGenerator (int index) async
  {
    var img = Image.asset("assets/images/photos/photo$index.jpg").image;
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
     img);

    double sumLuminance = 0;
    int k=0;
    for (int i=0; i < 5; i++){
      try{
        sumLuminance += paletteGenerator.paletteColors[i].color.computeLuminance();
        k++;
      }catch (e){
        // no more
      }
    }
    sumLuminance = sumLuminance / 5;
    return [roundDouble(sumLuminance, 2), roundDouble(paletteGenerator.dominantColor!.color.computeLuminance(), 2)];
  }

  List<String> suggestons = ["USA", "UK", "Uganda", "Uruguay", "United Arab Emirates", 'U are', 'ukraine', 'ugandoo', 'united nations'];

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) =>  postAction());
    });
    super.initState();
  }

  postAction(){
    searchFocusNode.requestFocus();
    searchNode.feed(box.extractKeywords());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    box = BlackNotifier.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  SafeArea(
          child: Column(
            children: [
              RawAutocomplete<String>(
                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  searchFocusNode = focusNode;
                  searchController = textEditingController;
                  return Hero(
                    tag: 'SG_1',
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 5,
                            child: TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                  prefixIconColor: Colors.grey,
                                  prefixIcon: IconButton( onPressed: () {
                                    navKey.currentState?.pop();
                                  }, icon: const Icon(CupertinoIcons.back)),
                                  suffixIconColor: Colors.grey,
                                  suffixIcon: hasText ? IconButton( onPressed: () {
                                      setState(() {
                                        results.clear();
                                        hasText = false;
                                        textEditingController.text = '';
                                      });
                                  }, icon: const Icon(CupertinoIcons.xmark_circle_fill)) : null,
                                  hintText: ' Search',
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      )
                                  ),
                                  focusedBorder: const UnderlineInputBorder(),
                              ),
                              onChanged: (text){
                                if (start) start = !start;
                                if (text.isNotEmpty && !hasText){
                                  hasText = true;
                                }
                                setState(() {
                                  results.clear();
                                });
                                setState(() {
                                  results.addAll(box.getElementsWhere(text));
                                });
                              },
                              onFieldSubmitted: (text){
                                setState(() {
                                  results.clear();
                                });
                                if (text.isNotEmpty){
                                  setState(() {
                                    results.addAll(box.getElementsWhere(text));
                                  });
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }

                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }else{
                    List<String> matches = <String>[];
                    matches = searchNode.autoComplete(textEditingValue.text);
                    return matches;
                  }
                },
                optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                    Iterable<String> options) {
                  return Material(
                      child:Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.grey.withOpacity(0.3)],
                                stops: const [0.7, 1],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 4.h),
                              height: 40.h,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: CupertinoScrollbar(
                                  child: ListView.separated(
                                      itemCount: options.length,
                                      separatorBuilder: (context, index) {
                                        return const Divider();
                                      },
                                      itemBuilder: (context, index){
                                    return InkWell(
                                      onTap: (){
                                        onSelected(options.toList()[index]);
                                      },
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.all(10),
                                        child:Text(options.toList()[index]),
                                      ),
                                    );
                                  },
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                },
                onSelected: (String selection) {
                  setState(() {
                    results.clear();
                  });
                  setState(() {
                    results.addAll(box.getElementsWhere(selection));
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (results.isEmpty && !start) {
                            return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: const Center(
                              child: Text('No Results Found!',
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),),
                            ),
                          );
                          }
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: results.length,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index){
                                final tag = '${Random().nextInt(50)}${results[index].mainPhotoPath}${Random().nextInt(50)}';
                                return InkWell(
                                  onTap: () async{
                                      try{
                                        final prod = box.cachedProduct(results[index].id);
                                        if (prod != null) {
                                          navKey.currentState?.pushNamed(
                                              '/productPage',
                                              arguments: [prod, tag]);
                                        } else {
                                          navKey.currentState?.pushNamed(
                                              '/productPage',
                                              arguments: [results[index].id, tag]);
                                        }
                                    }catch (e){
                                      if (kDebugMode) print('searchError: $e');
                                    }
                                },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                          child: Hero(
                                            tag: tag,
                                            child:cachedImage(results[index].mainPhotoPath),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                       FittedBox(child: Text(results[index].name.toUpperCase(),
                                       style: const TextStyle(fontWeight: FontWeight.w500),)),
                                       Spacer(),
                                       SizedBox(
                                         height: 10.h,
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             RichText(
                                               text: TextSpan(
                                                 style: TextStyle(color: Colors.black),
                                                 children: [
                                                   TextSpan(text: '${box.currentCurrency} '),
                                                   TextSpan(text: results[index].getPrice(box.currentCurrency).toString(),
                                                   style: TextStyle(fontWeight: FontWeight.w500)),

                                                 ]
                                               ),
                                             ),
                                           ],
                                         ),
                                       )
                                      ],
                                    ),
                                  ),
                                );
                          });
                        }
                      ),
                      SizedBox(height: 20.h)
                    ],
                  ),
                ),
              )
            ],
          ),
    )
    );
  }
}
