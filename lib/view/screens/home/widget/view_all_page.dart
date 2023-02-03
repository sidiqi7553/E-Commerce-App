import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../helper/responsive_helper.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/category_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/routes.dart';
import '../../../../utill/styles.dart';
import '../../../base/title_widget.dart';
import '../../category/category_screen.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Categories",
          style: rubikMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_DEFAULT,
              color: ColorResources.getBlackAndWhiteColor(context)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, Routes.getNotificationRoute()),
            icon: SvgPicture.asset("assets/icon/bag.svg",
                semanticsLabel: 'A red up arrow'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, category, child) {
                return Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                    //   child: TitleWidget(
                    //       title: getTranslated('all_categories', context)),
                    // ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: category.categoryList != null
                            ? category.categoryList.length > 0
                                ? ListView.builder(
                                    itemCount: category.categoryList.length,
                                    padding: EdgeInsets.only(),
                                    physics: BouncingScrollPhysics(),
                                    // gridDelegate:
                                    // SliverGridDelegateWithFixedCrossAxisCount(
                                    //   childAspectRatio: 1.1,
                                    //   crossAxisCount: ResponsiveHelper.isDesktop(context)?5:3,
                                    // ),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            // right:
                                            //     Dimensions.PADDING_SIZE_SMALL
                                        ),
                                        child: InkWell(
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            Routes.getCategoryRoute(category
                                                .categoryList[index].id),
                                            arguments: CategoryScreen(
                                                categoryModel: category
                                                    .categoryList[index]),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.bottomLeft,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: 140,
                                                      decoration: BoxDecoration(
                                                        // borderRadius:
                                                        //     BorderRadius.all(
                                                        //         Radius.circular(
                                                        //             40))
                                                      ),
                                                      child: ClipRRect(
                                                        // borderRadius:
                                                        //     BorderRadius.all(
                                                        //         Radius.circular(
                                                        //             40)
                                                        //     ),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                          Images.placeholder(
                                                              context),
                                                          image:
                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}'
                                                              '/${category.categoryList[index].image}',
                                                          width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                          imageErrorBuilder: (c, o,
                                                              t) =>
                                                              Image.asset(
                                                                  Images
                                                                      .placeholder(
                                                                      context),
                                                                  fit:
                                                                  BoxFit.contain),
                                                          // width: 100, height: 100, fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Text(

                                                        category
                                                            .categoryList[index].name,
                                                        style: rubikMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_SMALL),
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 1,),

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
                  ],
                );
              },
            ),
          ),
        ],
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
            padding: EdgeInsets.only(
                right: ResponsiveHelper.isDesktop(context)
                    ? 30
                    : Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled:
                  Provider.of<CategoryProvider>(context).categoryList == null,
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
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
