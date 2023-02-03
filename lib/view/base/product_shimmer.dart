import 'package:flutter/material.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isWeb;
  ProductShimmer({@required this.isEnabled, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 85,
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          horizontal: Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey[200], blurRadius: 10, spreadRadius: 1)
        ],
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnabled,
        child: isWeb
            ? Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        height: 15,
                        width: double.maxFinite,
                        color: Colors.grey[300]),
                    SizedBox(height: 5),
                    RatingBar(rating: 0.0, size: 12),
                    SizedBox(height: 10),
                    Container(
                        height: 10, width: 50, color: Colors.grey[300]),
                  ]),
                  SizedBox(width: 10),
                  ],
              )
            : Row(children: [
                Container(
                  height: 70,
                  width: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Container(
                          height: 15,
                          width: double.maxFinite,
                          color: Colors.grey[300]),
                      SizedBox(height: 5),
                      RatingBar(rating: 0.0, size: 12),
                      SizedBox(height: 10),
                      Container(height: 10, width: 50, color: Colors.grey[300]),
                    ])),
                SizedBox(width: 10),
                Column(children: [
                  Icon(Icons.favorite_border, color: ColorResources.COLOR_GREY),
                  Expanded(child: SizedBox()),
                  Icon(Icons.add, color: ColorResources.COLOR_BLACK),
                ]),
              ]),
      ),
    );
  }
}
