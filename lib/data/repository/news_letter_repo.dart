import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:flutter/material.dart';

class NewsLetterRepo {
  final DioClient dioClient;

  NewsLetterRepo({@required this.dioClient});

  Future<ApiResponse> addToNewsLetter(String  email) async {
    try {
      final response = await dioClient.post(AppConstants.EMAIL_SUBSCRIBE_URI, data : {'email':email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}