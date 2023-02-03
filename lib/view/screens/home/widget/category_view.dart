import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/screens/category/category_screen.dart';
import 'package:emarket_user/view/screens/home/widget/view_all_page.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../utill/color_resources.dart';
import '../web/categories_web_view.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            ResponsiveHelper.isDesktop(context)
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        bottom: Dimensions.PADDING_SIZE_LARGE),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Categories",
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_THIRTY,
                              color: ColorResources.getBlackAndWhiteColor(
                                  context)),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: TitleWidget(
                      title: "Categories",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ViewAll()));
                      },
                    ),
                  ),
            ResponsiveHelper.isDesktop(context)
                ? CategoriesWebView()
                : Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 90,
                          child: category.categoryList != null
                              ? category.categoryList.length > 0
                                  ? ListView.builder(
                                      itemCount: category.categoryList.length,
                                      padding: EdgeInsets.only(
                                          left: Dimensions.PADDING_SIZE_SMALL),
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: InkWell(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              Routes.getCategoryRoute(category
                                                  .categoryList[index].id),
                                              arguments: CategoryScreen(
                                                  categoryModel: category
                                                      .categoryList[index]),
                                            ),
                                            child: Column(children: [
                                              Container(
                                                width: 65,
                                                height: 65,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                40)),
                                                    border: Border.all(
                                                        width: .5,
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(40)),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        Images.placeholder(
                                                            context),
                                                    image:
                                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                                    width: 65,
                                                    height: 65,
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder:
                                                        (c, o, t) =>
                                                            Image.asset(
                                                      Images.placeholder(
                                                          context),
                                                      width: 65,
                                                      height: 65,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 60,
                                                child: Center(
                                                  child: Text(
                                                    category.categoryList[index]
                                                        .name,
                                                    style: rubikMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_SMALL),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(getTranslated(
                                          'no_category_available', context)))
                              : CategoryShimmer(),
                        ),
                      ),
                      ResponsiveHelper.isMobile(context)
                          ? SizedBox()
                          : category.categoryList != null
                              ? Column(
                                  children: [
                                    // InkWell(
                                    //   onTap: (){
                                    //     showDialog(context: context, builder: (con) => Dialog(
                                    //         child: Container(height: 550, width: 600, child: CategoryPopUp())
                                    //     ));
                                    //   },
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                    //     child: CircleAvatar(
                                    //       radius: 35,
                                    //       backgroundColor: Theme.of(context).primaryColor,
                                    //       child: Text(getTranslated('view_all', context), style: TextStyle(fontSize: 14,color: Colors.white)),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                              : CategoryAllShimmer()
                    ],
                  ),
          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled:
                  Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 100, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
