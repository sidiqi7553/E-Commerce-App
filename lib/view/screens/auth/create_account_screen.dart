import 'package:country_code_picker/country_code.dart';
import 'package:emarket_user/helper/email_checker.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/signup_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../utill/images.dart';
import '../../base/new_custom_text_field.dart';
import '../../base/phone_custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {

  final String email;
  final String countryCode;
  final String countryName;

  CreateAccountScreen({@required this.email,@required this.countryCode,@required this.countryName});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    // _numberController.text = widget.email;
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.countryName);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : AppBar(

        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Image.asset(
          Images.logo,

          height: ResponsiveHelper.isDesktop(context) ? 100.0 : 50,
          // fit: BoxFit.scaleDown,
          matchTextDirection: true,
        ),),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all( ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: ResponsiveHelper.isDesktop(context)? MainAxisAlignment.center:MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context)? size.height - 400 : size.height),
                    child: Container(
                      width: size.width > 700 ? 700 : size.width,
                      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context)? Dimensions.PADDING_SIZE_LARGE : 0),
                      padding: size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE) : null,
                      decoration: size.width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                                getTranslated('create_account', context),
                                style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                          SizedBox(height: 20),

                          // for first name section
                          // Text(
                          //   getTranslated('first_name', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          NewCustomTextField(
                            labelText: "NAME",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'John',
                            isShowBorder: true,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for last name section
                          // Text(
                          //   getTranslated('last_name', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ),
                          // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          // Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                          // CustomTextField(
                          //   hintText: 'Doe',
                          //   isShowBorder: true,
                          //   controller: _lastNameController,
                          //   focusNode: _lastNameFocus,
                          //   nextFocus: _numberFocus,
                          //   inputType: TextInputType.name,
                          //   capitalization: TextCapitalization.words,
                          // )
                          //     :CustomTextField(
                          //   hintText: 'Doe',
                          //   isShowBorder: true,
                          //   controller: _lastNameController,
                          //   focusNode: _lastNameFocus,
                          //   nextFocus: _emailFocus,
                          //   inputType: TextInputType.name,
                          //   capitalization: TextCapitalization.words,
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for email section
                          // Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                          // Text(
                          //   getTranslated('mobile_number', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ):Text(
                          //   getTranslated('email', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          // Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                          PhoneCustomTextField(
                            flagsButtonMargin: EdgeInsets.only(left: 8),
                            labelText: "PHONE NUMBER",
                            initialValue: "+${widget.email}",

                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "1234567890",
                            focusNode: _numberFocus,
                            controller: _numberController,
                            nextFocus: _emailFocus,

                            // initialCountryCode:"${widget.countryName}",
                            showDropdownIcon: false,
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ' + country.name);
                            },
                          ),
                              NewCustomTextField(
                                labelText: "EMAIL",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: getTranslated('demo_gmail', context),
                            isShowBorder: true,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for password section
                          // Text(
                          //   getTranslated('password', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          NewCustomTextField(
                            labelText: "PASSWORD",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                          ),
                          SizedBox(height: 22),

                          // for confirm password section
                          // Text(
                          //   getTranslated('confirm_password', context),
                          //   style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          NewCustomTextField(
                            labelText: "CONFIRM PASSWORD",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),

                          SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.registrationErrorMessage.length > 0
                                  ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                  : SizedBox.shrink(),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage ?? "",
                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),

                          // for signup button
                          SizedBox(height: 10),
                          !authProvider.isLoading
                              ? CustomButton(
                            btnTxt: getTranslated('signup', context),
                            onTap: () {

                              String _firstName = _firstNameController.text.trim();
                              String _lastName = _lastNameController.text.trim();
                              String _number = _numberController.text.trim();
                              String _email = _emailController.text.trim();
                              String _password = _passwordController.text.trim();
                              String _confirmPassword = _confirmPasswordController.text.trim();
                              if(Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                if (_firstName.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                }else if (_number.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                }else if (_password.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_password', context), context);
                                }else if (_password.length < 6) {
                                  showCustomSnackBar(getTranslated('password_should_be', context), context);
                                }else if (_confirmPassword.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                }else if(_password != _confirmPassword) {
                                  showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                }else {
                                  SignUpModel signUpModel = SignUpModel(
                                    fName: _firstName,
                                    lName: _lastName,
                                    email: widget.email,
                                    password: _password,
                                    phone: _number,
                                  );
                                  authProvider.registration(signUpModel).then((status) async {
                                    if (status.isSuccess) {
                                      await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                        context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                      );
                                      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                    }
                                  });
                                }
                              }else {
                                if (_firstName.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                }
                                // else if (_lastName.isEmpty) {
                                //   showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                // }
                                else if (_email.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                }else if (EmailChecker.isNotValid(_email)) {
                                  showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                }else if (_password.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_password', context), context);
                                }else if (_password.length < 6) {
                                  showCustomSnackBar(getTranslated('password_should_be', context), context);
                                }else if (_confirmPassword.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                }else if(_password != _confirmPassword) {
                                  showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                }else {
                                  SignUpModel signUpModel = SignUpModel(
                                    fName: _firstName,
                                    lName: "1",
                                    email: _email,
                                    password: _password,
                                    phone: widget.email.trim(),
                                  );
                                  authProvider.registration(signUpModel).then((status) async {
                                    if (status.isSuccess) {
                                      await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                        context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                      );

                                      Navigator.pushNamedAndRemoveUntil(context, Routes.getAccountCreatedRoute(), (route) => false);
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

                          // for already an account
                          SizedBox(height: 11),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
