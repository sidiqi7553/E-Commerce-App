import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/menu/web/menu_screen_web.dart';
import 'package:emarket_user/view/screens/menu/widget/options_view.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../base/custom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  final Function onTap;

  MenuScreen({this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    super.initState();
  }

  XFile file;
  XFile data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    XFile pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  _pickImage() async {
    data =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(
              title: getTranslated('my_profile', context),
              Svg: 'assets/icon/bag.svg', isBackButtonExist: false,),
      body: ResponsiveHelper.isDesktop(context)
          ? MenuScreenWeb(isLoggedIn: _isLoggedIn)
          : Column(children: [
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) => Center(
                  child: Container(
                    width: 1170,
                    padding: EdgeInsets.symmetric(vertical: 50),
                    decoration:
                        BoxDecoration(color: ColorResources.COLOR_WHITE),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_LARGE),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorResources.BORDER_COLOR,
                              border: Border.all(
                                  color: ColorResources.COLOR_GREY_CHATEAU,
                                  width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: _choose,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: file != null
                                        ? ResponsiveHelper.isMobilePhone()
                                            ? Image.file(File(file.path),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill)
                                            : Image.network(file.path,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill)
                                        : FadeInImage.assetNetwork(
                                            placeholder:
                                                Images.placeholder(context),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            image:
                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                                '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(
                                                    Images.placeholder(context),
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: -6,
                                    child: InkWell(
                                        onTap: _choose,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorResources.BORDER_COLOR,
                                            border: Border.all(
                                                width: 2,
                                                color: ColorResources
                                                    .COLOR_GREY_CHATEAU),
                                          ),
                                          child: Icon(Icons.edit, size: 15),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(children: [
                            _isLoggedIn
                                ? profileProvider.userInfoModel != null
                                    ? Text(
                                        '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                        style: rubikRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE,
                                            color: ColorResources.COLOR_BLACK),
                                      )
                                    : Container(
                                        height: 15,
                                        width: 150,
                                        color: Colors.grey[300])
                                : Text(
                                    getTranslated('guest', context),
                                    style: rubikRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_LARGE,
                                        color: ColorResources.COLOR_BLACK),
                                  ),
                            SizedBox(height: 10),
                            _isLoggedIn
                                ? profileProvider.userInfoModel != null
                                    ? Text(
                                        '${profileProvider.userInfoModel.email ?? ''}',
                                        style: rubikRegular.copyWith(
                                            color: ColorResources.COLOR_BLACK),
                                      )
                                    : Container(
                                        height: 15,
                                        width: 100,
                                        color: Colors.grey[300])
                                : Text(
                                    'demo@demo.com',
                                    style: rubikRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_LARGE,
                                        color: ColorResources.COLOR_BLACK),
                                  ),
                          ])
                        ]),
                  ),
                ),
              ),
              Expanded(child: OptionsView(onTap: widget.onTap)),
            ]),
    );
  }
}
