import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/product_type.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/product_shimmer.dart';
import 'package:emarket_user/view/base/product_widget.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constrants.dart';
import '../../../base/product_widget_3.dart';

class ProductView extends StatefulWidget {
  final ProductType productType;
  final ScrollController scrollController;
  ProductView({@required this.productType, this.scrollController});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int pageSize;

  @override
  Widget build(BuildContext context) {
    // int offset = Provider.of<ProductProvider>(context, listen: false).offset;
    void seeMoreItems(){
      if (widget.productType == ProductType.POPULAR_PRODUCT) {
        pageSize = (Provider.of<ProductProvider>(context, listen: false).popularPageSize / 10).ceil();
      }
      if (Provider.of<ProductProvider>(context, listen: false).offset < pageSize) {
        Provider.of<ProductProvider>(context, listen: false).offset ++;
        Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
        Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
          context, Provider.of<ProductProvider>(context, listen: false).offset.toString(), false, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
        );
      }
    }

    if(!ResponsiveHelper.isDesktop(context)) {
      widget.scrollController?.addListener(() {
        if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent
            && Provider.of<ProductProvider>(context, listen: false).popularProductList != null
            && !Provider.of<ProductProvider>(context, listen: false).isLoading) {

          if (widget.productType == ProductType.POPULAR_PRODUCT) {
            pageSize = (Provider.of<ProductProvider>(context, listen: false).popularPageSize / 10).ceil();
          }
          if (Provider.of<ProductProvider>(context, listen: false).offset < pageSize) {
            Provider.of<ProductProvider>(context, listen: false).offset++;
            Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
            Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
              context, Provider.of<ProductProvider>(context, listen: false).offset.toString(), false, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            );
          }
        }
      });
    }

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if (widget.productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        }

        return Column(children: [
          productList != null ? productList.length > 0
              ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 13,
                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 0.72,
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 2),
                itemCount: productList.length,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: 5),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ProductWidget3(product: productList[index]
                  );
                },
          )
              : NoDataScreen() : GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : 4,
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return ProductShimmer(isEnabled: productList == null,isWeb: ResponsiveHelper.isDesktop(context)? true : false );
              },
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL)),



          productList != null &&  productList.length > 0 ? Padding(
            padding: ResponsiveHelper.isDesktop(context)? const EdgeInsets.only(top: 40,bottom: 70) :  const EdgeInsets.all(0),
            child: ResponsiveHelper.isDesktop(context)?
            prodProvider.isLoading ?
            Center(child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ))
                :(Provider.of<ProductProvider>(context, listen: false).offset == pageSize) ? SizedBox() : SizedBox(
              width: 300,
              child: InkWell(
                onTap: (){
                  seeMoreItems();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.getWhiteAndBlackColor(context),
                    border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text(getTranslated('see_more', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_OVER_LARGE))),
                  ),
                ),
              ),
            )
                :prodProvider.isLoading ? Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                )) : SizedBox(),
          ) : SizedBox(),

        ]);
      },
    );
  }
}
