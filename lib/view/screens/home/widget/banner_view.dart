import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/screens/category/category_screen.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/banner_provider.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../helper/responsive_helper.dart';

class BannerView extends StatefulWidget {
  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  final PageController _pageController = PageController();

  int selectedIndex = 0 ;

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == selectedIndex ? 20 : 7,
          height: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              color: i == selectedIndex ? Colors.transparent: Theme.of(context).primaryColor ,
              borderRadius: i == selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
              border:Border.all(color: Theme.of(context).primaryColor)
          ),
        ),
      );
    }
    return _indicators;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        // Padding(
        //   padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        //   child: TitleWidget(title: getTranslated('banner', context)),
        // ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

        SizedBox(
          height: 170,
          child: Consumer<BannerProvider>(
            builder: (context, banner, child) {
              return
                banner.bannerList != null ?
                banner.bannerList.length > 0 ?
                ResponsiveHelper.isDesktop(context) ?
                ListView.builder(
                itemCount: banner.bannerList.length,
                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if(banner.bannerList[index].productId != null) {
                        Product product;
                        for(Product prod in banner.productList) {
                          if(prod.id == banner.bannerList[index].productId) {
                            product = prod;
                            break;
                          }
                        }
                        if(product != null) {
                          Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(product.id),
                              arguments: ProductDetailsScreen(product: product));
                        }

                      }else if(banner.bannerList[index].categoryId != null) {
                        CategoryModel category;
                        for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList) {
                          if(categoryModel.id == banner.bannerList[index].categoryId) {
                            category = categoryModel;
                            break;
                          }
                        }
                        if(category != null) {
                          Navigator.pushNamed(
                            context, Routes.getCategoryRoute(category.id),
                            arguments: CategoryScreen(categoryModel: category),
                          );
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        boxShadow: [
                          Provider.of<ThemeProvider>(context).darkTheme ? BoxShadow() :BoxShadow(
                            color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                            spreadRadius: 1, blurRadius: 5),
                        ],
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder(context),
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                          width: 250, height: 85, fit: BoxFit.cover,
                          imageErrorBuilder: (context,a,b) => Image.asset(Images.placeholder(context),width: 250, height: 85, fit: BoxFit.cover,),

                        ),
                      ),
                    ),
                  );
                },
              ):
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        itemCount: banner.bannerList.length,
                        controller: _pageController,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(left:Dimensions.PADDING_SIZE_SMALL,right: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              boxShadow: [
                                Provider.of<ThemeProvider>(context).darkTheme ? BoxShadow() :BoxShadow(
                                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                                    spreadRadius: 1, blurRadius: 5),
                              ],
                              color: ColorResources.COLOR_WHITE,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder(context),
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                                width: 250, height: 150, fit: BoxFit.cover,
                                imageErrorBuilder: (context,a,b) => Image.asset(Images.placeholder(context),width: 250, height: 150, fit: BoxFit.cover,),

                              ),
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          setState((){
                            selectedIndex = index;
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _pageIndicators(banner.bannerList, context),
                    ),
                  ],
                )

                : Center(child: Text(getTranslated('no_banner_available', context))) : BannerShimmer();
            },
          ),
        ),

      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250, height: 85,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

