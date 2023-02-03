import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && apiResponse.error.errors[0].message == 'Unauthenticated.') {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginRoute(), (route) => false);
    } else if(apiResponse.response.statusCode == 404) {
print('error');
    }
    else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      showCustomSnackBar(_errorMessage, context, isError: true);
    }
  }
}