import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/onboarding_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/images.dart';

class OnBoardingRepo {
  final DioClient dioClient;
  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onboarding_one, "Welcome to Garey!", "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit."),
        OnBoardingModel(Images.onboarding_two, "Easy Track Order!", "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit."),
        OnBoardingModel(Images.onboarding_three, "Door to Door Delivery!", "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit."),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
