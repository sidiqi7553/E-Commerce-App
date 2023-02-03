import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emarket_user/helper/date_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/coupon_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:provider/provider.dart';

import '../../base/custom_app_bar_2.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : CustomAppBar2(title: getTranslated('coupon', context),),
      body: _isLoggedIn ? Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return coupon.couponList != null ? coupon.couponList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _size.height < 600 ? _size.height : _size.height - 400),
                        child: Container(
                          padding: _size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.zero,
                          child: Container(
                            width: _size.width > 700 ? 700 : _size.width,
                            padding: _size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                            decoration: _size.width > 700 ? BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),

                            ) : null,
                          child: SizedBox(
                            width: 1170,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: coupon.couponList.length,
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                                  child: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: coupon.couponList[index].code));
                                      showCustomSnackBar(getTranslated('coupon_code_copied', context), context, isError: false);
                                    },
                                    child: Stack(children: [

                                      Image.asset(Images.coupon_bg, height: 100, width: 1170, fit: BoxFit.fitWidth, color: Theme.of(context).primaryColor),

                                      Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: Row(children: [

                                          SizedBox(width: 50),
                                          Image.asset(Images.percentage, height: 50, width: 50),

                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                                            child: Image.asset(Images.line, height: 100, width: 5),
                                          ),

                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                              SelectableText(
                                                coupon.couponList[index].code,
                                                style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE),
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              Text(
                                                '${coupon.couponList[index].discount}${coupon.couponList[index].discountType == 'percent' ? '%'
                                                    : Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol} off',
                                                style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              Text(
                                                '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList[index].expireDate)}',
                                                style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_SMALL),
                                              ),
                                            ]),
                                          ),

                                        ]),
                                      ),

                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                     ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),
                  ],
                ),
              ),
            ),
          ) : NoDataScreen(showFooter: true) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
