import 'package:emarket_user/view/screens/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 500,
        child: Consumer<CategoryProvider>(
          builder: (context, category, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child:
                      TitleWidget(title: getTranslated('all_categories', context)),
                ),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: category.categoryList != null
                        ? category.categoryList.length > 0
                            ? GridView.builder(
                                itemCount: category.categoryList.length,
                                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  physics: BouncingScrollPhysics(),
                                  gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1.1,
                                        crossAxisCount: ResponsiveHelper.isDesktop(context)?5:3,
                                    ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                    child: InkWell(
                                      onTap: () => Navigator.pushNamed(
                                        context, Routes.getCategoryRoute(category.categoryList[index].id),
                                        arguments: CategoryScreen(categoryModel: category.categoryList[index]),
                                      ),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                        Container( width: 65, height: 65,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(40))
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(40)),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Images.placeholder(context),
                                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}'
                                                  '/${category.categoryList[index].image}',
                                              width: 65, height: 65,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (c,o,t)=> Image.asset(Images.placeholder(context),fit: BoxFit.cover),
                                              // width: 100, height: 100, fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          category.categoryList[index].name,
                                          style: rubikMedium.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                              ) : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isDesktop(context) ? 220 : 80,
      child: ListView.builder(
        itemCount: ResponsiveHelper.isDesktop(context) ? 7 : 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: ResponsiveHelper.isDesktop(context) ? 30 : Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: ResponsiveHelper.isDesktop(context) ? 130 : 65,
                  width: ResponsiveHelper.isDesktop(context) ? 130 : 65,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
