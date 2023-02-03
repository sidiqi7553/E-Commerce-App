import 'package:emarket_user/helper/rating_percentage_count.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RatingLine extends StatelessWidget {
  const RatingLine({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        double five = (productProvider.fiveStarLength * 100)/5;
        double four = (productProvider.fourStar * 100)/4;
        double three = (productProvider.threeStar * 100)/3;
        double two = (productProvider.twoStar * 100)/2;
        double one = (productProvider.oneStar * 100)/1;

        return Column(children: [
          Row(children: [
            Expanded(flex: ResponsiveHelper.isDesktop(context) ? 3 : 4,child: Text('Excellent',style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT))),
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 8 : 9,child: Stack(
              children: [
                Container(
                  height: Dimensions.RATING_HEIGHT,width: 300,
                  decoration: BoxDecoration(color: ColorResources.getGreyColor(context).withOpacity(0.3),borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  height: Dimensions.RATING_HEIGHT,width: RatingCount.convertPercentage(five),
                  decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Row(children: [
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 3 : 4,child: Text('Good',style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT))),
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 8 : 9,child: Stack(
              children: [
                Container(
                  height: Dimensions.RATING_HEIGHT,width: 300,
                  decoration: BoxDecoration(color: ColorResources.getGreyColor(context).withOpacity(0.3),borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  height: Dimensions.RATING_HEIGHT,width: RatingCount.convertPercentage(four),
                  decoration: BoxDecoration(color: Colors.greenAccent,borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Row(children: [
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 3 : 4,child: Text('Average',style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT))),
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 8 : 9,child: Stack(
              children: [
                Container(
                  height: Dimensions.RATING_HEIGHT,width: 300,
                  decoration: BoxDecoration(color: ColorResources.getGreyColor(context).withOpacity(0.3),borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  height: Dimensions.RATING_HEIGHT,width: RatingCount.convertPercentage(three),
                  decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Row(children: [
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 3 : 4,child: Text('Below Average',style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT))),
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 8 : 9,child: Stack(
              children: [
                Container(
                  height: Dimensions.RATING_HEIGHT,width: 300,
                  decoration: BoxDecoration(color: ColorResources.getGreyColor(context).withOpacity(0.3),borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  height: Dimensions.RATING_HEIGHT,width: RatingCount.convertPercentage(two),
                  decoration: BoxDecoration(color: Colors.deepOrange,borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Row(children: [
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 3 : 4,child: Text('Poor',style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT))),
            Expanded(flex:ResponsiveHelper.isDesktop(context) ? 8 : 9,child: Stack(
              children: [
                Container(
                  height: Dimensions.RATING_HEIGHT,width: 300,
                  decoration: BoxDecoration(color: ColorResources.getGreyColor(context).withOpacity(0.3),borderRadius: BorderRadius.circular(20)),
                ),
                Container(
                  height: Dimensions.RATING_HEIGHT,width: RatingCount.convertPercentage(one),
                  decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),),
          ]),
        ],);
      }
    );
  }
}
