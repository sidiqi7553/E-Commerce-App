
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/body/review_body_model.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/utill/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;

  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getPopularProductList(String offset, String languageCode) async {
    try {
      final response = await dioClient.get(
        '${AppConstants.POPULAR_PRODUCT_URI}?limit=12&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOfferProductList(String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.OFFER_PRODUCT_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID, String languageCode) async {
    try {
      final response = await dioClient.get(
        '${AppConstants.PRODUCT_DETAILS_URI}$productID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId, String languageCode) async {
    try {
      final response = await dioClient.get(
        '${AppConstants.SEARCH_PRODUCT_URI}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient.post(AppConstants.REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient.post(AppConstants.DELIVER_MAN_REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductReviewList(int productID) async {
    try {
      final response = await dioClient.get('${AppConstants.PRODUCT_REVIEW_URI}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  
}
