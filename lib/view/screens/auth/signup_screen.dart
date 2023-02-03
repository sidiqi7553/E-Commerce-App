import 'package:country_code_picker/country_code.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/email_checker.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../base/new_custom_text_field.dart';
import '../../base/phone_custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController;
  TextEditingController _numberController;
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  String _countryDialCode;
  String countryCode;
  String countryISOCode;
  String countryName;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _numberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar:  ResponsiveHelper.isDesktop(context)?
      PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : null,
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all( ResponsiveHelper.isDesktop(context)? 0 : Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context)? size.height - 400 : size.height),
                    child: Center(
                      child: Container(
                        width: size.width > 700 ? 700 : size.width,
                        margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context)? Dimensions.PADDING_SIZE_LARGE : 0),
                        padding: size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                        decoration: size.width > 700 ? BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                        ) : null,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 30),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Image.asset(Images.logo, matchTextDirection: true,height: MediaQuery.of(context).size.height / 4.5),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                  child: Text(
                                    getTranslated('signup', context),
                                    style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                                  )),

                              SizedBox(height: 35),


                              // Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                              // Text(
                              //   getTranslated('email', context),
                              //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              // ):Text(
                              //   getTranslated('mobile_number', context),
                              //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              // ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                              NewCustomTextField(
                                hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                focusNode: _emailFocus,
                                nextFocus: _numberFocus,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.emailAddress,
                                controller: _emailController,
                              ):
                              Container(
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:  PhoneCustomTextField(
                                  flagsButtonMargin: EdgeInsets.only(left: 8),
                                  labelText: "PHONE NUMBER",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  hintText: "1234567890",
                                  focusNode: _numberFocus,
                                  controller: _numberController,
                                  initialCountryCode:"QA",
                                  showDropdownIcon: false,
                                  onChanged: (phone) {
                                    print(phone.countryCode);
                                    print(phone.countryISOCode);
                                    print(phone.number);
                                    setState(() {
                                      countryCode=phone.countryCode;
                                      countryISOCode=phone.countryISOCode;
                                      countryName=phone.number;
                                    });
                                    print(phone.completeNumber);
                                  },
                                  onCountryChanged: (country) {
                                    print('Country changed to: ' + country.name);
                                  },
                                ),
                              ),

                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage.length > 0
                                      ? CircleAvatar(backgroundColor: Colors.red, radius: 5)
                                      : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // for continue button
                              SizedBox(height: 12),
                              !authProvider.isPhoneNumberVerificationButtonLoading
                                  ? CustomButton(
                                btnTxt: getTranslated('continue', context),
                                onTap: () async {

                                  if(Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                    // String countryCode;
                                    String _email = _emailController.text.trim();


                                    if (_email.isEmpty) {
                                      showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                    }else if (EmailChecker.isNotValid(_email)) {
                                      showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                    }
                                    else {
                                        authProvider.checkEmail(_email).then((value) async {
                                          if (value.isSuccess) {
                                            authProvider.updateEmail(_email);
                                            if (value.message == 'active') {

                                              Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _email));
                                            } else {
                                              print("++++");

                                              Navigator.pushNamed(context, Routes.getCreateAccountRoute(_email,"",""));
                                            }
                                          }
                                        });

                                    }
                                  }else{
                                    // String countryCode;
                                    String _number = countryCode+_numberController.text.trim();
                                    String _numberChk = countryCode+_numberController.text.trim();

                                     if (_numberChk.isEmpty) {
                                      showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                    }
                                    else {
                                      authProvider.checkPhone(_number).then((value) async {
                                        if (value.isSuccess) {
                                          authProvider.updatePhone(_number);
                                          if (value.message == 'active') {

                                            Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _numberController.text.trim()));
                                          } else {
                                            print("---");
                                            Navigator.pushNamed(context, Routes.getCreateAccountRoute(_number,countryCode,countryName));
                                          }
                                        }
                                      });


                                    }

                                  }



                                },
                              )
                                  : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  )),

                              // for create an account
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('already_have_account', context),
                                        style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated('login', context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
