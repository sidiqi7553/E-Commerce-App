import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/body/review_body_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:emarket_user/view/screens/track/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan deliveryMan;
  final String orderID;
  DeliveryManReviewWidget({@required this.deliveryMan, @required this.orderID});

  @override
  _DeliveryManReviewWidgetState createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Column(
                    children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  widget.deliveryMan != null ? SizedBox(width:Dimensions.WEB_SCREEN_WIDTH,child: DeliveryManWidget(deliveryMan: widget.deliveryMan)) : SizedBox(),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  Container(
                    width: Dimensions.WEB_SCREEN_WIDTH,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                        blurRadius: 5, spreadRadius: 1,
                      )],
                    ),
                    child: Column(children: [
                      Text(
                        getTranslated('rate_his_service', context),
                        style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return InkWell(
                              child: Icon(
                                productProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                                size: 25,
                                color: productProvider.deliveryManRating < (i + 1)
                                    ? ColorResources.getGreyColor(context)
                                    : Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                Provider.of<ProductProvider>(context, listen: false).setDeliveryManRating(i + 1);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Text(
                        getTranslated('share_your_opinion', context),
                        style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomTextField(
                        maxLines: 5,
                        capitalization: TextCapitalization.sentences,
                        controller: _controller,
                        hintText: getTranslated('write_your_review_here', context),
                        fillColor: ColorResources.getSearchBg(context),
                      ),
                      SizedBox(height: 40),

                      // Submit button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Column(
                          children: [
                            !productProvider.isLoading ? CustomButton(
                              btnTxt: getTranslated('submit', context),
                              onTap: () {
                                if (productProvider.deliveryManRating == 0) {
                                  showCustomSnackBar('Give a rating', context);
                                } else if (_controller.text.isEmpty) {
                                  showCustomSnackBar('Write a review', context);
                                } else {
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  ReviewBody reviewBody = ReviewBody(
                                    deliveryManId: widget.deliveryMan.id.toString(),
                                    rating: productProvider.deliveryManRating.toString(),
                                    comment: _controller.text,
                                    orderId: widget.orderID,
                                  );
                                  productProvider.submitDeliveryManReview(reviewBody).then((value) {
                                    if (value.isSuccess) {
                                      showCustomSnackBar(value.message, context, isError: false);
                                      _controller.text = '';
                                    } else {
                                      showCustomSnackBar(value.message, context);
                                    }
                                  });
                                }
                              },
                            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                          ],
                        ),
                      ),
                    ]),
                  ),

                    ]);
              },
            ),
          ),
          if(ResponsiveHelper.isDesktop(context)) FooterView(),
        ],
      ),
    );
  }
}
