import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../base/custom_app_bar_2.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : CustomAppBar2(
              title: getTranslated('help_and_support', context), ),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: !ResponsiveHelper.isDesktop(context) &&
                                _size.height < 600
                            ? _size.height
                            : _size.height - 400),
                    width: _size.width > 700 ? 700 : _size.width,
                    padding: _size.width > 700
                        ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                        : null,
                    decoration: _size.width > 700
                        ? BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                          )
                        : null,
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Image.asset(Images.help,
                                    height: 300, width: 300)),
                            // SizedBox(height: 20),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                                  Text(
                                      getTranslated(
                                          'restaurant_address', context),
                                      style: rubikMedium),
                                ]),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                Center(
                                    child: Text(
                                  '662 Street, Wakra, Qatar',
                                  style: rubikRegular,
                                )),
                                SizedBox(height: 5),
                                Center(
                                    child: Text(
                                  'Working Hours :',
                                  style: rubikRegular,
                                )),
                                SizedBox(height: 5),
                                Center(
                                    child: Text(
                                  'Saturday to Sunday - 9:30AM to 4:30PM',
                                  style: rubikRegular,
                                )),
                              ],
                            ),

                            // Text(
                            //   Provider.of<SplashProvider>(context, listen: false).configModel.ecommerceAddress,
                            //   style: rubikRegular, textAlign: TextAlign.center,
                            // ),
                            // Divider(thickness: 2),
                            SizedBox(height: 50),



                          ]),
                    ),
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
