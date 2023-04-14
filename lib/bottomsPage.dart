import 'package:flutter/material.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';

class BottomsPage extends StatefulWidget {
  const BottomsPage({Key? key}) : super(key: key);

  @override
  State<BottomsPage> createState() => _BottomsPageState();
}

class _BottomsPageState extends State<BottomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 13.h),
          Expanded(
            child: GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.185.w,
                  mainAxisSpacing: 1.2.w,
                ),
                itemCount: 10,
                itemBuilder:(context, index){
                  return CollectionItem(index: index+1);
                }),
          ),
        ],
      ),
    );
  }
}
