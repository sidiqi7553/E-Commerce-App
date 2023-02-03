import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/repository/news_letter_repo.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';


class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo newsLetterRepo;
  NewsLetterProvider({@required this.newsLetterRepo});


  Future<void> addToNewsLetter(BuildContext context, String email) async {
    ApiResponse apiResponse = await newsLetterRepo.addToNewsLetter(email);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      showCustomSnackBar(getTranslated('successfully_subscribe', context), context,isError: false);
    } else {
      showCustomSnackBar(getTranslated('mail_already_exist', context), context);
    }
  }
  notifyListeners();
}