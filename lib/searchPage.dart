import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
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
  late FocusNode searchNode;
  bool hasText = false;


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
      Future.delayed(const Duration(milliseconds: 300)).then((value) =>  searchNode.requestFocus());
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  SafeArea(
          child: Column(
            children: [
              Autocomplete(
                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  searchNode = focusNode;
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
                                  }, icon: Icon(CupertinoIcons.back)),
                                  suffixIconColor: Colors.grey,
                                  suffixIcon: hasText ? IconButton( onPressed: () {
                                      setState(() {
                                        hasText = false;
                                        textEditingController.text = '';
                                      });
                                  }, icon: Icon(CupertinoIcons.xmark_circle_fill)) : null,
                                  hintText: ' Search',
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      )
                                  ),
                                  focusedBorder: UnderlineInputBorder(),
                              ),
                              onChanged: (text){
                                setState(() {
                                  hasText = text.isNotEmpty;
                                });
                              },
                              onFieldSubmitted: (text){
                                print('submitted $text');
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
                    matches.addAll(suggestons);

                    matches.retainWhere((s){
                      return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                    return matches;
                  }
                },
                optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                    Iterable<String> options) {
                  return Material(
                      child:Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 4.h,
                            child: ListView.builder(
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index){
                                  return CircleAvatar(backgroundColor: Colors.blueAccent,);
                                }),
                          ),
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.grey.withOpacity(0.3)],
                                stops: [0.7, 1],
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
                                  child: ListView.builder(
                                      itemCount: options.length,
                                      itemBuilder: (context, index){
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            onSelected(options.toList()[index]);
                                          },
                                          child: Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.all(10),
                                            child:Text(options.toList()[index]),
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                },
                onSelected: (String selection) {
                  print('You just selected $selection');
                },
              ),
              SizedBox(height: 5.h),
              SizedBox(
                height: 20.h,
                child: Image.asset("assets/images/photos/photo$index.jpg"),
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    setState(() {
                      index--;
                    });
                  }, child: Text('-')),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      index++;
                    });
                  }, child: Text('+'))
                ],
              ),
              FutureBuilder<List<double>>(
                future: _updatePaletteGenerator(index),
                builder: (context, AsyncSnapshot<List<double>> snapshot){
                  if (snapshot.hasData){
                    return Text('${snapshot.data![0]} :${snapshot.data![0] > 0.2 ? 'light' : 'dark'}');
                  }else{
                    return Text('Loading data');
                  }

              },
              ),
            ],
          ),
    )
    );
  }
}
