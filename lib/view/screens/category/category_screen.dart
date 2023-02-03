
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/product_shimmer.dart';
import 'package:emarket_user/view/base/product_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../provider/cart_provider.dart';
import '../../../utill/routes.dart';
import '../../base/web_header/productWidget2.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  CategoryModel _categoryModel;

  void _loadData() async {
    _categoryModel = widget.categoryModel;
     Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(
      context, widget.categoryModel.id.toString(), Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double xyz = MediaQuery.of(context).size.width-Dimensions.WEB_SCREEN_WIDTH ;
    final double realSpaceNeeded =xyz/2;


    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : null,
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.subCategoryList != null ?
          Center(
            child: Scrollbar(
              child: Container(
                // width: Dimensions.WEB_SCREEN_WIDTH,
                child: CustomScrollView(
                  physics: ResponsiveHelper.isDesktop(context) ? AlwaysScrollableScrollPhysics() : BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      elevation: 0,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Theme.of(context).cardColor,
                      pinned: ResponsiveHelper.isTab(context) ? true : false,
                      leading: ResponsiveHelper.isTab(context) ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu,color: Colors.black),
                      ): IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back_ios,color: Colors.black),

                        // icon:SvgPicture.asset(
                        //     "assets/icon/bell.svg",
                        //     semanticsLabel: 'A red up arrow'
                        // ),
                      ),

                      title:  Image.asset(Images.logo, width: 70, height: 80),
                      actions: [
                        // IconButton(
                        //   onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                        //   icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).textTheme.bodyText1.color),
                        // ),
                        // ResponsiveHelper.isTab(context) ?
                        IconButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                  "assets/icon/bag.svg",
                                  semanticsLabel: 'A red up arrow'
                              ),
                              Positioned(
                                bottom: -7, left: -7,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                  child: Center(
                                    child: Text(
                                      "\$"+Provider.of<CartProvider>(context).cartList.length.toString(),
                                      style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        // : SizedBox(),
                      ],
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height -560 : MediaQuery.of(context).size.height),
                            child: Container(width: Dimensions.WEB_SCREEN_WIDTH,
                              child: category.categoryProductList != null ? category.categoryProductList.length > 0 ? GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                                    mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 0.72,
                                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 2),
                                itemCount: category.categoryProductList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: 5),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ProductWidget2(product: category.categoryProductList[index]);
                              },
                            ) : NoDataScreen(isCategory: true) : GridView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 11 : 5,
                                mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 11 : 5,
                                childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 1,
                              ),
                              itemBuilder: (context, index) {
                                return ProductShimmer(isEnabled: category.categoryProductList == null,isWeb:  ResponsiveHelper.isDesktop(context) ? true : false);
                              },
                            ),
                              ),
                          ),

                          ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

                        ],
                      ),
                    ),



                  ],
                ),
              ),
            ),
          ) : SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: Dimensions.WEB_SCREEN_WIDTH,
                child: Column(
                  children: [
                    Shimmer(
                        duration: Duration(seconds: 2),
                        enabled: true,
                        child: Container(height: 200,width: double.infinity,color: Colors.grey[300])),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                          childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 0.72,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 2),
                      itemCount: category.categoryProductList.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: 5),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ProductShimmer(isEnabled: category.categoryProductList == null,isWeb:  ResponsiveHelper.isDesktop(context) ? true : false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Tab> _tabs(CategoryProvider category) {
    List<Tab> tabList = [];
    tabList.add(Tab(text: 'All'));
    category.subCategoryList.forEach((subCategory) => tabList.add(Tab(text: subCategory.name.length >= 30 ? subCategory.name.substring(0,30 )+ '...' : subCategory.name)));
    return tabList;
  }
}
