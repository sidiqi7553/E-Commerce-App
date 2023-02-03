import 'package:country_code_picker/country_code.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../base/new_custom_text_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../base/phone_custom_text_field.dart';

class AccountCreated extends StatefulWidget {
  @override
  _AccountCreatedState createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {



  @override
  void initState() {
    super.initState();
    }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))
          :
      AppBar(

        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Image.asset(
          Images.logo,

          height: ResponsiveHelper.isDesktop(context) ? 100.0 : 50,
          // fit: BoxFit.scaleDown,
          matchTextDirection: true,
        ),),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment:ResponsiveHelper.isDesktop(context) ?  MainAxisAlignment.center:MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? size.height - 400 : size.height),
                  child: Container(
                    width: size.width > 700 ? 700 : size.width,
                    margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.FONT_SIZE_THIRTY : 0),
                    // padding: size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE) : null,
                    decoration: size.width > 700 ? BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[700], blurRadius: 1, spreadRadius: .11)],
                    ) : null,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => Container(
                        padding: size.width > 700 ? EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE) : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Image.asset(Images.account_created, matchTextDirection: true,height: MediaQuery.of(context).size.height / 4.5),
                              ),
                            ),                            SizedBox(height: 20),
                            Center(
                                child: Text(
                                  "Account Created!",
                                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                                )),
                            Center(
                                child: Text(
                                  "Your account has beed created successfully.",
                                  style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 16, color: ColorResources.getGreyBunkerColor(context)),
                                )),




                            // for login button
                            SizedBox(height: 10),
                            !authProvider.isLoading
                                ? CustomButton(
                              btnTxt: "Shop Now",
                              onTap: () async {
                                Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);

                              },

                            )
                                : Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                )),

                            // for create an account

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
