import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : _globalKey.currentState.hideCurrentSnackBar();
        _globalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', _globalKey.currentContext) : getTranslated('connected', _globalKey.currentContext),
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    print('policy page');

    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey).then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          double _minimumVersion = 0.0;
          if(Platform.isAndroid) {
            if(Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.minVersion!=null){
              _minimumVersion = Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.minVersion?? 6.0;

            }
          }else if(Platform.isIOS) {
            if(Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.minVersion!=null){
              _minimumVersion = Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.minVersion?? 6.0;
            }
          }
          if(AppConstants.APP_VERSION < _minimumVersion && !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.getUpdateRoute(), (route) => false);
          }
          else if (Provider.of<SplashProvider>(context, listen: false).configModel.maintenanceMode) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.getMaintainRoute(), (route) => false);
          }
          else{
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              await Provider.of<WishListProvider>(context, listen: false).initWishList(
                context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
              );
              Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
            } else {
              print('===intro=>${Provider.of<SplashProvider>(context, listen: false).showLang()}');
              // if(Provider.of<SplashProvider>(context, listen: false).showLang() !=null && Provider.of<SplashProvider>(context, listen: false).showLang()) {
              //   Navigator.pushNamedAndRemoveUntil(context, ResponsiveHelper.isMobile(context) ? Routes.getLanguageRoute('splash') : Routes.getMainRoute(), (route) => false);
              // }else {
                Navigator.pushNamedAndRemoveUntil(context,  Routes.getOnBoardingRoute(), (route) => false);

                // }
              }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Color(0xff721134),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.splash_logo, width: 200,),

            // Text(AppConstants.APP_NAME, style: rubikBold.copyWith(fontSize: 30, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
