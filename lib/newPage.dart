import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notfound/routesGenerator.dart';
import 'package:notfound/widgets.dart';
import 'package:sizer/sizer.dart';


class newPage extends StatefulWidget {
  const newPage({Key? key}) : super(key: key);

  @override
  State<newPage> createState() => _newPageState();
}



class _newPageState extends State<newPage> {

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
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
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff001BA0),

                      ),
                      child: const Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('New Arrival', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){},
                    enableFeedback: false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('SHOP ALL', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp)),
                        Icon(Icons.navigate_next, size: 20.sp,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              SizedBox(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,
                          crossAxisSpacing: 1.w,
                          childAspectRatio: 2 / 4,
                          mainAxisSpacing: 0,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder:(context, index){
                          return  CollectionItem(index: index+1,
                            hasPrice: true,
                            align: Alignment.topLeft,
                            textAlign: TextAlign.left,
                            flaggedLabel: true,
                            labelText: 'New',);
                        });
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
