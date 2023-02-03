import 'package:emarket_user/data/model/response/review_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../helper/date_converter.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel reviewModel;
  ReviewWidget({@required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorResources.getSearchBg(context),
      ),*/
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: FadeInImage.assetNetwork(
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${
                  reviewModel.customer != null ? reviewModel.customer.image : getTranslated('user_not_available', context)
                }',
              placeholder: Images.placeholder(context),
              width: 50, height: 50, fit: BoxFit.cover,
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 50, height: 50,fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reviewModel.customer != null ?
                '${reviewModel.customer.fName} ${reviewModel.customer.lName}' : getTranslated('user_not_available', context),
                style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RatingBar(rating: reviewModel.rating != null ? double.parse(reviewModel.rating.toString()) : 0.0, size: 16,color: Colors.deepOrangeAccent),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Text(reviewModel.rating.toStringAsFixed(1), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: ColorResources.getGreyColor(context))),

                ],
              ),

            ],
          ),
          Spacer(),
          Text(
            DateConverter.convertToAgo(reviewModel.createdAt),
            // DateConverter.dateTimeInDays(reviewModel.createdAt) == '0' ? getTranslated('today', context) : DateConverter.dateTimeInDays(reviewModel.createdAt) == '1'? getTranslated('tomorrow', context) : DateConverter.dateTimeInDays(reviewModel.createdAt) + ' ' + getTranslated('days_ago', context),
            style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,color: ColorResources.getGreyColor(context)),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        Text(reviewModel.comment, style: TextStyle(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.FONT_SIZE_LARGE : Dimensions.FONT_SIZE_DEFAULT ,color: ColorResources.getGreyColor(context),fontStyle: FontStyle.italic)),
      ]),
    );
  }
}

class ReviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorResources.getSearchBg(context),
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(height: 30, width: 30, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
            SizedBox(width: 5),
            Container(height: 15, width: 100, color: Colors.grey[300]),
            Expanded(child: SizedBox()),
            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
            SizedBox(width: 5),
            Container(height: 15, width: 20, color: Colors.grey[300]),
          ]),
          SizedBox(height: 5),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.grey[300]),
          SizedBox(height: 3),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.grey[300]),
        ]),
      ),
    );
  }
}

