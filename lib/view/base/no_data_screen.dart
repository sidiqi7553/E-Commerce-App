import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  final bool isCategory;
  final bool showFooter;
  NoDataScreen({this.isCart = false, this.isNothing = false, this.isOrder = false, this.isCategory = false, this.showFooter = false});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context)? size.height - 400 : size.height),
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

        Image.asset(
          isOrder ? Images.clock : isCart ? Images.shopping_cart : Images.notefound,
          width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
          color: Theme.of(context).primaryColor,
        ),
                SizedBox(height: 20,),

                Text(
                  getTranslated(isOrder ? 'no_order_history_available' : isCart ? 'empty_cart' : 'nothing_found', context),
                  style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.height*0.023),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                Text(
                  isOrder ? getTranslated('buy_something_to_see', context) : isCart ? getTranslated('look_like_have_not_added', context) : 'Looks like you have not selected your favourite products yet.',
                  style: rubikMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175), textAlign: TextAlign.center,
                ),

              ]),
            ),
          ),

          ResponsiveHelper.isDesktop(context) ? showFooter ? FooterView() : SizedBox.shrink(): SizedBox.shrink(),

        ],
      ),
    );
  }
}
