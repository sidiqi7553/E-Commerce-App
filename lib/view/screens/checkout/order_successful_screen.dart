import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';

import '../../base/custom_app_bar.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;

  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : CustomAppBar(
              title: getTranslated(
                'My Order',
                context,
              ),
              Svg: 'assets/icon/bag.svg',
            ),
      body: SingleChildScrollView(
        child: Container(
          height: _size.height,
          width: _size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: ResponsiveHelper.isDesktop(context)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Padding(
                padding: ResponsiveHelper.isDesktop(context)
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE)
                    : const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    decoration: ResponsiveHelper.isDesktop(context)
                        ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                                BoxShadow(
                                  color: ColorResources.CARD_SHADOW_COLOR
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                )
                              ])
                        : BoxDecoration(),
                    constraints: BoxConstraints(
                        minHeight: !ResponsiveHelper.isDesktop(context) &&
                                _size.height < 600
                            ? _size.height
                            : _size.height - 400),
                    width: 1170,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              status == 0
                                  ? Icons.check_circle
                                  : status == 1
                                      ? Icons.sms_failed
                                      : Icons.cancel,
                              color: Theme.of(context).primaryColor,
                              size: 80,
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            getTranslated(
                                status == 0
                                    ? 'order_placed_successfully'
                                    : status == 1
                                        ? 'payment_failed'
                                        : 'payment_cancelled',
                                context),
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${getTranslated('order_id', context)}:',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(orderID,
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                              ]),
                          SizedBox(height: 30),
                          SizedBox(
                            width: ResponsiveHelper.isDesktop(context)
                                ? 400
                                : _size.width,
                            child: Padding(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                  btnTxt: getTranslated(
                                      status == 0 ? 'track_order' : 'back_home',
                                      context),
                                  onTap: () {
                                    if (status == 0) {
                                      Navigator.pushReplacementNamed(
                                          context,
                                          Routes.getOrderTrackingRoute(
                                              int.parse(orderID)));
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Routes.getMainRoute(),
                                          (route) => false);
                                    }
                                  }),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              if (ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
