import 'package:country_code_picker/country_code.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../base/new_custom_text_field.dart';
import '../../base/phone_custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  String _countryDialCode;
  bool isPhoneSelect = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false)
        .clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .countryCode)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : CustomAppBar(title: getTranslated('forgot_password', context)),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: ResponsiveHelper.isDesktop(context)
                              ? size.height - 400
                              : size.height),
                      child: Container(
                          width: _width > 700 ? 700 : _width,
                          margin: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.PADDING_SIZE_LARGE
                                  : 0),
                          padding: _width > 700
                              ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                              : null,
                          decoration: _width > 700
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel
                                      .phoneVerification
                                  ? Center(
                                      child: Text(
                                      "Please enter your email address or phone number to receive OTP.",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ))
                                  : Center(
                                      child: Text(
                                      "Please enter your email address or phone number to receive OTP.",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    )),
                              SizedBox(height: 40),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPhoneSelect = true;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,

                                          child: Text(
                                            "Phone Number",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(
                                                color: isPhoneSelect
                                                    ? Colors.white: Theme.of(context)
                                                    .primaryColor
                                                    ,
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),

                                              color: isPhoneSelect
                                                  ?Theme.of(context).primaryColor:Colors.white
                                                   ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPhoneSelect = false;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Email",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(
                                                    color: isPhoneSelect
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.white,
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),

                                              color: isPhoneSelect
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              isPhoneSelect
                                  ? Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_LARGE),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          // Text(
                                          //   getTranslated(
                                          //       'mobile_number', context),
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .headline2
                                          //       .copyWith(
                                          //           color: ColorResources
                                          //               .getHintColor(context)),
                                          // ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                  PhoneCustomTextField(
                                    flagsButtonMargin: EdgeInsets.only(left: 8),
                                    labelText: "PHONE NUMBER",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText: "1234567890",
                                    controller: _phoneNumberController,
                                    initialCountryCode:"QA",
                                    showDropdownIcon: false,
                                    onChanged: (phone) {
                                      print(phone.completeNumber);
                                    },
                                    onCountryChanged: (country) {
                                      print('Country changed to: ' + country.name);
                                    },
                                  ),
                                          SizedBox(height: 10),
                                          !auth.isForgotPasswordLoading
                                              ? CustomButton(
                                                  btnTxt: getTranslated(
                                                      'send', context),
                                                  onTap: () {
                                                    if (_phoneNumberController
                                                        .text.isEmpty) {
                                                      showCustomSnackBar(
                                                          getTranslated(
                                                              'enter_phone_number',
                                                              context),
                                                          context);
                                                    } else {
                                                      Provider.of<AuthProvider>(
                                                              context,
                                                              listen: false)
                                                          .forgetPassword(

                                                                  _phoneNumberController
                                                                      .text)
                                                          .then((value) {
                                                        if (value.isSuccess) {
                                                          Navigator.pushNamed(
                                                              context,
                                                              Routes.getVerifyRoute(
                                                                  'forget-password',
                                                                  // _countryDialCode +
                                                                      _phoneNumberController
                                                                          .text));
                                                        } else {
                                                          showCustomSnackBar(
                                                              value.message,
                                                              context);
                                                        }
                                                      });
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(Theme.of(
                                                                  context)
                                                              .primaryColor))),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_LARGE),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          // Text(
                                          //   getTranslated('email', context),
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .headline2
                                          //       .copyWith(
                                          //           color: ColorResources
                                          //               .getHintColor(context)),
                                          // ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          NewCustomTextField(
                                            labelText: "EMAIL",
                                            floatingLabelBehavior: FloatingLabelBehavior.always,

                                            hintText: getTranslated(
                                                'demo_gmail', context),
                                            isShowBorder: true,
                                            controller: _emailController,
                                            inputType:
                                                TextInputType.emailAddress,
                                            inputAction: TextInputAction.done,
                                          ),
                                          SizedBox(height: 24),
                                          !auth.isForgotPasswordLoading
                                              ? CustomButton(
                                                  btnTxt: getTranslated(
                                                      'send', context),
                                                  onTap: () {
                                                    print(Provider.of<
                                                                SplashProvider>(
                                                            context,
                                                            listen: false)
                                                        .configModel
                                                        .phoneVerification);
                                                    if (Provider.of<
                                                                SplashProvider>(
                                                            context,
                                                            listen: false)
                                                        .configModel
                                                        .phoneVerification) {
                                                      if (_phoneNumberController
                                                          .text.isEmpty) {
                                                        showCustomSnackBar(
                                                            getTranslated(
                                                                'enter_phone_number',
                                                                context),
                                                            context);
                                                      } else {
                                                        Provider.of<AuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .forgetPassword(
                                                                _countryDialCode +
                                                                    _phoneNumberController
                                                                        .text
                                                                        .trim())
                                                            .then((value) {
                                                          if (value.isSuccess) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.getVerifyRoute(
                                                                    'forget-password',
                                                                    _countryDialCode +
                                                                        _phoneNumberController
                                                                            .text
                                                                            .trim()));
                                                          } else {
                                                            showCustomSnackBar(
                                                                value.message,
                                                                context);
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      if (_emailController
                                                          .text.isEmpty) {
                                                        showCustomSnackBar(
                                                            getTranslated(
                                                                'enter_email_address',
                                                                context),
                                                            context);
                                                      } else if (!_emailController
                                                          .text
                                                          .contains('@')) {
                                                        showCustomSnackBar(
                                                            getTranslated(
                                                                'enter_valid_email',
                                                                context),
                                                            context);
                                                      } else {
                                                        Provider.of<AuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .forgetPassword(
                                                                _emailController
                                                                    .text)
                                                            .then((value) {
                                                          if (value.isSuccess) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                Routes.getVerifyRoute(
                                                                    'forget-password',
                                                                    _emailController
                                                                        .text));
                                                          } else {
                                                            showCustomSnackBar(
                                                                value.message,
                                                                context);
                                                          }
                                                        });
                                                      }
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(Theme.of(
                                                                  context)
                                                              .primaryColor))),
                                        ],
                                      ),
                                    ),
                            ],
                          )),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? FooterView()
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
