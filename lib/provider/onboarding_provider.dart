import 'package:emarket_user/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/onboarding_model.dart';
import 'package:emarket_user/data/repository/onboarding_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo onboardingRepo;
  final SharedPreferences sharedPreferences;

  OnBoardingProvider({@required this.onboardingRepo, @required this.sharedPreferences}) {
    _loadShowOnBoardingStatus();
  }
  List<OnBoardingModel> _onBoardingList = [];

  List<OnBoardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  bool _showOnBoardingStatus = false;
  int get selectedIndex => _selectedIndex;
  bool get showOnBoardingStatus => _showOnBoardingStatus;

  changeSelectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
  void _loadShowOnBoardingStatus() async {
    _showOnBoardingStatus = sharedPreferences.getBool(AppConstants.ON_BOARDING_SKIP) ?? false;
  }
  void toggleShowOnBoardingStatus() {
    sharedPreferences.setBool(AppConstants.ON_BOARDING_SKIP, true);
  }

  void initBoardingList(BuildContext context) async {
    ApiResponse apiResponse = await onboardingRepo.getOnBoardingList(context);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _onBoardingList.clear();
      _onBoardingList.addAll(apiResponse.response.data);

    }
    notifyListeners();
  }
}
