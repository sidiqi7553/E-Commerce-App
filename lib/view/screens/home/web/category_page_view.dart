import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/splash_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../../utill/images.dart';
import '../../../../provider/category_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/routes.dart';
import '../../../../utill/styles.dart';
import '../../../base/on_hover.dart';
import '../../../base/text_hover.dart';
import '../../category/category_screen.dart';

class CategoryPageView extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final PageController pageController;
  const CategoryPageView({Key key, @required this.categoryProvider, @required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _totalPage = (categoryProvider.categoryList.length / 7).ceil();

    return Container(
      child: PageView.builder(
        controller: pageController,
        itemCount: _totalPage,
        onPageChanged: (index) {
          categoryProvider.updateProductCurrentIndex(index, _totalPage);
        },
        itemBuilder: (context, index) {
          int _initialLength = 7;
          int currentIndex = 7 * index;

          // ignore: unnecessary_statements
          (index + 1 == _totalPage) ? _initialLength = categoryProvider.categoryList.length - (index * 7)  : 7 ;

          return  Align(
            alignment:  _initialLength < 7 ? Alignment.centerLeft : Alignment.center,
            child: ListView.builder(
                itemCount: _initialLength, scrollDirection: Axis.horizontal, physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
                padding: _initialLength < 7 ? const EdgeInsets.only(left: 30) : EdgeInsets.zero,
                itemBuilder: (context, item) {
                  int _currentIndex = item  + currentIndex;
                  String _name = '';
                  categoryProvider.categoryList[_currentIndex].name.length > 20 ? _name = categoryProvider.categoryList[_currentIndex].name.substring(0, 20)+' ...' : _name = categoryProvider.categoryList[_currentIndex].name;
                  return Container(
                    margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () => Navigator.pushNamed(
                        context, Routes.getCategoryRoute(categoryProvider.categoryList[_currentIndex].id),
                        arguments: CategoryScreen(categoryModel: categoryProvider.categoryList[_currentIndex]),
                      ),
                      child: TextHover(
                          builder: (hovered) {
                            return Column(children: [
                              OnHover(
                                child: Container(
                                  height: 130,width: 130,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow:Provider.of<ThemeProvider>(context).darkTheme
                                          ? null
                                          : [
                                        BoxShadow(
                                          color: ColorResources.CATEGORY_SHADOW.withOpacity(0.20),
                                          blurRadius: 15,
                                          offset: Offset(3,0)
                                        )
                                      ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder(context), width: 125, height: 125, fit: BoxFit.fitHeight,
                                      image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                          ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${categoryProvider.categoryList[_currentIndex].image}':'',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 125, height: 125, fit: BoxFit.cover),

                                    ),
                                  ),
                                ),
                              ),

                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                  child:  SizedBox(
                                    width: 135,
                                    child: Text(
                                      _name,
                                      style: rubikRegular.copyWith(color: hovered ? Theme.of(context).primaryColor
                                          : ColorResources.getBlackAndWhiteColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,

                                    ),
                                  ),
                                ),
                              ),

                            ]);
                          }
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
