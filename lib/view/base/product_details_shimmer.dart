import 'package:flutter/material.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductDetailsShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isWeb;
  ProductDetailsShimmer({@required this.isEnabled, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    final Size size  = MediaQuery.of(context).size;
    return Container(

      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnabled,
        child: isWeb
            ? SingleChildScrollView(
              child: Column(
          children: [
              SizedBox(
                height: size.height*0.7,
                width: Dimensions.WEB_SCREEN_WIDTH,
                child: Row(
                  children: [
                    Expanded(child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Container(width: double.infinity,height: size.height*0.45,color: Colors.grey[300],),
                          SizedBox(height: 50),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(right: 10),
                                itemBuilder: (context, index) {
                              return Container(margin: EdgeInsets.only(right: 10),width: 100,height: 100,color: Colors.grey[300]);
                            }),
                          )

                        ],
                      ),
                    )),
                    SizedBox(width: 20,),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      SizedBox(height: 100),
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(children: [
                        Container(
                          height: 20,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 20,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                      ],),
                        SizedBox(height: 50),
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                      ),
                        SizedBox(height: 50),
                      Row(children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                      ],)
                    ],)),

                  ],
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Container(
                      height: 15,
                      width: 200,
                      color: Colors.grey[300]
                  ),
                  SizedBox(width: 20,),
                  Container(
                      height: 15,
                      width: 200,
                      color: Colors.grey[300]
                  ),
                ],),
              ),
              SizedBox(height: 20),
              SizedBox(
                  width: Dimensions.WEB_SCREEN_WIDTH,
                child: Container(
                    height: 100,
                    width: double.maxFinite,
                    color: Colors.grey[300]),
              ),

          ],
        ),
            )
            : SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.65,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],),
                    Divider(height: 20, thickness: 2),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE) ,

                    // Quantity
                    Row(children: [
                      Container(
                        height: Dimensions.FONT_SIZE_LARGE,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Container(
                      height: Dimensions.FONT_SIZE_EXTRA_LARGE,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                    // Tab Bar
                    Row(children: [
                      Expanded(child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),),
                      SizedBox(width: 20),
                      Expanded(child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),),
                    ]),

                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),


                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
