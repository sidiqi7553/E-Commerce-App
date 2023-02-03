import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/screens/home/web/offer_product_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'arrow_button.dart';


class OfferProductWebView extends StatefulWidget {
  @override
  State<OfferProductWebView> createState() => _OfferProductWebViewState();
}

class _OfferProductWebViewState extends State<OfferProductWebView> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  void _previousPage() {
    pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, offerProduct, child) {
        return Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, Dimensions.PADDING_SIZE_EXTRA_LARGE, 0, 20),
                      child: Text(getTranslated('offer_product', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_THIRTY)),
                    ),
                  ],
                ),
                Positioned.fill(
                  right: 10,top: 5,
                    child: SizedBox(
                      height: 40, width: 20,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ArrowButton(isLeft: true, isLarge: false,onTop:  _previousPage, isVisible: !offerProduct.pageFirstIndex), SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            ArrowButton(isLeft: false, isLarge: false, onTop: _nextPage,isVisible:   !offerProduct.pageLastIndex && (offerProduct.offerProductList!= null ? offerProduct.offerProductList.length > 5 : false)  )
                          ]
                      ),
                    )
                )
              ],
            ),

            SizedBox(
              height: 350,
              child: offerProduct.offerProductList != null ? offerProduct.offerProductList.length > 0 ? OfferProductPageView(offerProduct: offerProduct, pageController: pageController) : Center(child: Text(getTranslated('no_offer_product_available', context))) : OfferProductShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class OfferProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: ResponsiveHelper.isDesktop(context) ? 5 : 4,
      itemBuilder: (context, index){
        return Container(
          height: 360,
          width: ResponsiveHelper.isDesktop(context) ? 215 : 280,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 1),
            interval: Duration(seconds: 1),
            enabled: Provider.of<ProductProvider>(context).offerProductList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 225.0, width: 368,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Container(height: 15, color: Colors.grey[300]),
                    ),
                    RatingBar(rating: 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: Dimensions.PADDING_SIZE_SMALL, width: 30, color: Colors.grey[300]),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(height: Dimensions.PADDING_SIZE_SMALL,width: 30, color: Colors.grey[300]),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 240, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

