import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/view/screens/home/web/arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/category_pop_up.dart';
import 'category_page_view.dart';
class CategoriesWebView extends StatefulWidget {
  const CategoriesWebView({Key key}) : super(key: key);

  @override
  _CategoriesWebViewState createState() => _CategoriesWebViewState();
}

class _CategoriesWebViewState extends State<CategoriesWebView> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  void _previousPage() {
    pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryProvider>(builder: (context,category,child){

      return category.categoryList != null? category.categoryList.length > 0 ?
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 220,
                    child:  category.categoryList != null ? category.categoryList.length > 0 ?
                    CategoryPageView(categoryProvider: category, pageController: pageController)
                        : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),

                  ),
                ),
              ],
            ),
          ),
          if(category.categoryList != null) Positioned.fill(child: Align(child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ArrowButton(isLeft: true, isLarge: true, onTop: _previousPage, isVisible: !category.pageFirstIndex),
          ), alignment: Alignment.centerLeft)),
          if(category.categoryList != null) Positioned.fill(child: Align(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ArrowButton(isLeft: false, isLarge: true, onTop: _nextPage,
                    isVisible:  !category.pageLastIndex && (category.categoryList != null ? category.categoryList.length > 7 : false)),
              ), alignment: Alignment.centerRight)),

        ],
      ): Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer();
    });
  }
}
