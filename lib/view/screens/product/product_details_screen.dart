import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/product_details_shimmer.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/screens/product/details_app_bar.dart';
import 'package:emarket_user/view/screens/product/widget/product_image_view.dart';
import 'package:emarket_user/view/screens/product/widget/product_title_view.dart';
import 'package:emarket_user/view/screens/product/widget/rating_bar.dart';
import 'package:emarket_user/view/screens/product/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../provider/wishlist_provider.dart';
import '../../../utill/images.dart';
import '../../base/custom_snackbar.dart';
import '../../base/web_header/web_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final CartModel cart;

  ProductDetailsScreen({@required this.product, this.cart});

  final GlobalKey<DetailsAppBarState> _key = GlobalKey();

  _loading(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getProductDetails(
      context, product, cart, Provider
        .of<LocalizationProvider>(context, listen: false)
        .locale
        .languageCode,
    );
    await Provider.of<ProductProvider>(context, listen: false)
        .getProductReviews(context, product.id);
    print('review list Widget: ${Provider
        .of<ProductProvider>(context, listen: false)
        .productReviewList
        .length}');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final CartProvider _cartProvider = Provider.of<CartProvider>(
        context, listen: false);
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false)
        .isLoggedIn();
    Variation _variation = Variation();
    GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

    _loading(context);

    Provider.of<CartProvider>(context, listen: false).setSelect(0, false);

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        int _stock = 0;
        List _tabChildren;
        double priceWithQuantity;
        bool isExistInCart = false;
        CartModel _cartModel;
        List _variationList;
        if (productProvider.product != null &&
            productProvider.productReviewList != null) {
          _tabChildren = [

            (productProvider.product.description == null ||
                productProvider.product.description.isEmpty) ? Center(
                child: Text(getTranslated('no_description_found', context),
                    style: TextStyle(
                        fontSize: ResponsiveHelper.isDesktop(context)
                            ? 20
                            : 16)))
                : HtmlWidget(productProvider.product.description ?? '',
              textStyle: TextStyle(
                  fontSize: ResponsiveHelper.isDesktop(context) ? 20 : 12),),


            (productProvider.productReviewList == null &&
                productProvider.productReviewList.length == 0)
                ? Center(child: Text(getTranslated('no_review_found', context),
                style: TextStyle(
                    fontSize: ResponsiveHelper.isDesktop(context) ? 20 : 16)))
                : Column(
              children: [
                Container(
                  width: 700,
                  child: ResponsiveHelper.isDesktop(context) ?
                  Row(
                    children: [
                      Expanded(flex: 4, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${ productProvider.product.rating.length > 0
                              ? double.parse(
                              productProvider.product.rating.first.average)
                              .toStringAsFixed(1)
                              : 0.0}', style: TextStyle(fontSize: 70,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepOrange)),
                          RatingBar(
                              rating: productProvider.product.rating.length > 0
                                  ? double.parse(
                                  productProvider.product.rating[0].average)
                                  : 0.0,
                              size: 30,
                              color: Colors.deepOrangeAccent),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                              Text(productProvider.productReviewList.length
                                  .toString() + ' Reviews',
                                  style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      color: Colors.deepOrange)),
                            ],),
                        ],)),
                      Expanded(flex: 6, child: RatingLine()),
                    ],
                  ) : Column(children: [
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    SizedBox(
                      height: 150, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBar(
                            rating: productProvider.product.rating.length > 0
                                ? double.parse(
                                productProvider.product.rating[0].average)
                                : 0.0,
                            size: 30,
                            color: Colors.deepOrangeAccent),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Text('${productProvider.product.rating.length > 0
                            ? double.parse(
                            productProvider.product.rating.first.average)
                            .toStringAsFixed(1)
                            : 0.0}', style: TextStyle(fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrange)),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                        Text(productProvider.productReviewList.length
                            .toString() + ' Reviews',
                            style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: Colors.deepOrange))

                      ],),),


                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  ]),
                ),
                Builder(
                    builder: (context) {
                      return ListView.builder(
                        itemCount: productProvider.productReviewList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        itemBuilder: (context, index) {
                          return productProvider.productReviewList != null
                              ? ReviewWidget(reviewModel: productProvider
                              .productReviewList[index])
                              : ReviewShimmer();
                        },

                      );
                    })
              ],
            ),
          ];

          _variationList = [];
          for (int index = 0; index <
              productProvider.product.choiceOptions.length; index++) {
            _variationList.add(productProvider.product.choiceOptions[index]
                .options[productProvider.variationIndex[index]].replaceAll(
                ' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          _variationList.forEach((variation) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          });

          double price = productProvider.product.price;

          _stock = productProvider.product.totalStock;
          for (Variation variation in productProvider.product.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              _stock = variation.stock;
              break;
            }
          }

          double priceWithDiscount = PriceConverter.convertWithDiscount(
              context, price, productProvider.product.discount,
              productProvider.product.discountType);
          _cartModel = CartModel(
            price,
            priceWithDiscount,
            [_variation],
            (price - PriceConverter.convertWithDiscount(
                context, price, productProvider.product.discount,
                productProvider.product.discountType)),
            productProvider.quantity ?? 0.0,
            price - PriceConverter.convertWithDiscount(
                context, price, productProvider.product.tax,
                productProvider.product.taxType),
            _stock,
            productProvider.product,
          );
          isExistInCart = Provider.of<CartProvider>(context).isExistInCart(
              _cartModel, false, null);
          if (isExistInCart) {
            priceWithQuantity = priceWithDiscount *
                _cartProvider.cartList[_cartProvider.getCartProductIndex(
                    _cartModel, false, null)].quantity;
          } else {
            priceWithQuantity =
                priceWithDiscount * productProvider.quantity ?? 0.0;
          }
        }

        return Scaffold(
          key: _globalKey,
          backgroundColor: Theme
              .of(context)
              .cardColor,

          appBar: ResponsiveHelper.isDesktop(context)
              ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
              : DetailsAppBar(key: _key),

          body: productProvider.product != null
              ? ResponsiveHelper.isDesktop(context)
              ?
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery
                  .of(context)
                  .size
                  .height - 560),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: Dimensions.WEB_SCREEN_WIDTH,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 4, child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.5,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder(context),
                                      fit: BoxFit.cover,
                                      image: '${Provider
                                          .of<SplashProvider>(
                                          context, listen: false)
                                          .baseUrls
                                          .productImageUrl}/${productProvider
                                          .product.image[Provider
                                          .of<CartProvider>(
                                          context, listen: false)
                                          .productSelect]}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                              Images.placeholder(context),
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(height: 100,
                                    child: productProvider.product.image != null
                                        ? ListView.builder(
                                        itemCount: productProvider.product.image
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5),
                                            child: InkWell(
                                              onTap: () {
                                                Provider.of<CartProvider>(
                                                    context, listen: false)
                                                    .setSelect(index, true);
                                              },
                                              child: Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                        .RADIUS_SIZE_SMALL),
                                                    border: Border.all(
                                                        color: index == Provider
                                                            .of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                            .productSelect
                                                            ? Theme
                                                            .of(context)
                                                            .primaryColor
                                                            : ColorResources
                                                            .getGreyColor(
                                                            context),
                                                        width: index == Provider
                                                            .of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                            .productSelect
                                                            ? 2
                                                            : 1)
                                                ),
                                                padding: const EdgeInsets.all(
                                                    2),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: Images
                                                      .placeholder(context),
                                                  fit: BoxFit.cover,
                                                  image: '${Provider
                                                      .of<SplashProvider>(
                                                      context, listen: false)
                                                      .baseUrls
                                                      .productImageUrl}/${productProvider
                                                      .product.image[index]}',
                                                  imageErrorBuilder: (c, o,
                                                      s) =>
                                                      Image.asset(Images
                                                          .placeholder(context),
                                                          width: 100,
                                                          fit: BoxFit.cover),
                                                ),),
                                            ),
                                          );
                                        })
                                        : SizedBox(),)
                                ],
                              ),
                            ),),
                            Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        ProductTitleView(
                                            productModel: productProvider
                                                .product),
                                        SizedBox(height: 35),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: productProvider.product
                                              .choiceOptions.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start, children: [
                                              Text(productProvider.product
                                                  .choiceOptions[index].title,
                                                  style: rubikMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              SizedBox(height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                              GridView.builder(
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: ResponsiveHelper
                                                      .isDesktop(context)
                                                      ? 6.5
                                                      : (1 / 0.25),
                                                ),
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: productProvider
                                                    .product
                                                    .choiceOptions[index]
                                                    .options.length,
                                                itemBuilder: (context, i) {
                                                  return InkWell(
                                                    onTap: () {
                                                      productProvider
                                                          .setCartVariationIndex(
                                                          index, i);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      alignment: Alignment
                                                          .center,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions
                                                              .PADDING_SIZE_EXTRA_SMALL),
                                                      decoration: BoxDecoration(
                                                        color: productProvider
                                                            .variationIndex[index] !=
                                                            i
                                                            ? ColorResources
                                                            .BACKGROUND_COLOR
                                                            : Theme
                                                            .of(context)
                                                            .primaryColor,
                                                        borderRadius: BorderRadius
                                                            .circular(12),
                                                        border: productProvider
                                                            .variationIndex[index] !=
                                                            i ? Border.all(
                                                            color: ColorResources
                                                                .BORDER_COLOR,
                                                            width: 2) : null,
                                                      ),
                                                      child: Text(
                                                        productProvider.product
                                                            .choiceOptions[index]
                                                            .options[i].trim(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: rubikRegular
                                                            .copyWith(
                                                          color: productProvider
                                                              .variationIndex[index] !=
                                                              i
                                                              ? ColorResources
                                                              .COLOR_BLACK
                                                              : ColorResources
                                                              .COLOR_WHITE,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(height: index !=
                                                  productProvider.product
                                                      .choiceOptions.length - 1
                                                  ? Dimensions
                                                  .PADDING_SIZE_LARGE
                                                  : 0),
                                            ]);
                                          },
                                        ),

                                        SizedBox(height: 30),
                                        Row(children: [
                                          QuantityButton(isIncrement: false,
                                              quantity: isExistInCart
                                                  ? _cartProvider
                                                  .cartList[_cartProvider
                                                  .getCartProductIndex(
                                                  _cartModel, false, null)]
                                                  .quantity
                                                  : productProvider.quantity,
                                              stock: _stock,
                                              isExistInCart: isExistInCart,
                                              cart: _cartModel),
                                          SizedBox(width: 30),
                                          Text(isExistInCart ? _cartProvider
                                              .cartList[_cartProvider
                                              .getCartProductIndex(
                                              _cartModel, false, null)].quantity
                                              .toString() : productProvider
                                              .quantity.toString(),
                                              style: rubikBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_LARGE)),
                                          SizedBox(width: 30),
                                          QuantityButton(isIncrement: true,
                                              quantity: isExistInCart
                                                  ? _cartProvider
                                                  .cartList[_cartProvider
                                                  .getCartProductIndex(
                                                  _cartModel, false, null)]
                                                  .quantity
                                                  : productProvider.quantity,
                                              stock: _stock,
                                              cart: _cartModel,
                                              isExistInCart: isExistInCart),
                                        ]
                                        ),
                                        SizedBox(height: 30),

                                        Row(children: [
                                          // Text('${getTranslated(
                                          //     'total_amount', context)}:',
                                          //     style: rubikMedium.copyWith(
                                          //         fontSize: Dimensions
                                          //             .FONT_SIZE_LARGE)),
                                          SizedBox(width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          Text(PriceConverter.convertPrice(
                                              context,
                                              priceWithQuantity ?? 0.0),
                                              style: rubikBold.copyWith(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor,
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE,
                                              )),
                                        ]),
                                        SizedBox(height: 30),

                                        SizedBox(
                                          width: 400,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  child: CustomButton(
                                                    btnTxt: getTranslated(
                                                        isExistInCart
                                                            ? 'already_added_in_cart'
                                                            : _stock <= 0
                                                            ? 'out_of_stock'
                                                            : 'add_to_cart',
                                                        context),
                                                    backgroundColor: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    radius: Dimensions
                                                        .RADIUS_SIZE_SMALL,
                                                    onTap: (!isExistInCart &&
                                                        _stock > 0) ? () {
                                                      if (!isExistInCart &&
                                                          _stock > 0) {
                                                        Provider.of<
                                                            CartProvider>(
                                                            context,
                                                            listen: false)
                                                            .addToCart(
                                                            _cartModel, null);
                                                        showCustomSnackBar(
                                                            getTranslated(
                                                                'added_to_cart',
                                                                context),
                                                            context,
                                                            isError: false);
                                                      }
                                                    } : null,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                        .RADIUS_SIZE_SMALL),
                                                  ),
                                                  child: Consumer<
                                                      WishListProvider>(
                                                      builder: (context,
                                                          wishList, child) {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if (_isLoggedIn) {
                                                                  if (wishList
                                                                      .wishIdList
                                                                      .contains(
                                                                      productProvider
                                                                          .product
                                                                          .id)) {
                                                                    wishList
                                                                        .removeFromWishList(
                                                                        productProvider
                                                                            .product, (
                                                                        message) {
                                                                      showCustomSnackBar(
                                                                          message,
                                                                          context,
                                                                          isError: true);
                                                                    });
                                                                  } else {
                                                                    wishList
                                                                        .addToWishList(
                                                                        productProvider
                                                                            .product, (
                                                                        message) {
                                                                      showCustomSnackBar(
                                                                          message,
                                                                          context,
                                                                          isError: false);
                                                                    });
                                                                  }
                                                                } else
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'not_logged_in',
                                                                          context),
                                                                      context);
                                                              },
                                                              child: Icon(
                                                                wishList
                                                                    .wishIdList
                                                                    .contains(
                                                                    productProvider
                                                                        .product
                                                                        .id)
                                                                    ? Icons
                                                                    .favorite
                                                                    : Icons
                                                                    .favorite_border,
                                                                size: 25,
                                                                color: wishList
                                                                    .wishIdList
                                                                    .contains(
                                                                    productProvider
                                                                        .product
                                                                        .id)
                                                                    ? Theme
                                                                    .of(context)
                                                                    .cardColor
                                                                    : ColorResources
                                                                    .getGreyColor(
                                                                    context),
                                                              ),
                                                            ),

                                                            SizedBox(width: 5),

                                                            Text(
                                                              wishList
                                                                  .localWishes
                                                                  .contains(
                                                                  productProvider
                                                                      .product
                                                                      .id)
                                                                  ? (productProvider
                                                                  .product
                                                                  .wishlistCount +
                                                                  1).toString()
                                                                  : wishList
                                                                  .localRemovedWishes
                                                                  .contains(
                                                                  productProvider
                                                                      .product
                                                                      .id)
                                                                  ? (productProvider
                                                                  .product
                                                                  .wishlistCount -
                                                                  1).toString()
                                                                  : productProvider
                                                                  .product
                                                                  .wishlistCount
                                                                  .toString(),
                                                              style: rubikMedium
                                                                  .copyWith(
                                                                  color: ColorResources
                                                                      .COLOR_WHITE,
                                                                  fontSize: Dimensions
                                                                      .FONT_SIZE_EXTRA_LARGE),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),


                                      ],),
                                  ),
                                )),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tab Bar
                  SizedBox(
                    width: 500,
                    child: Row(children: [
                      Expanded(child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => productProvider.setTabIndex(0),
                        child: Column(children: [
                          Center(child: Text(
                              getTranslated('description', context),
                              style: productProvider.tabIndex == 0 ? rubikBold
                                  .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                                      .withOpacity(1))
                                  : rubikMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                  color: ColorResources.getTextColor(
                                      context)))),
                          Divider(thickness: 3,
                              color: Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(
                                  productProvider.tabIndex == 0 ? 1 : 0.0),
                              endIndent: 20,
                              indent: 20),
                        ]),
                      )),
                      Expanded(child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => productProvider.setTabIndex(1),
                        child: Column(children: [
                          Center(child: Text(getTranslated('review', context),
                              style: productProvider.tabIndex == 1 ? rubikBold
                                  .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                  color: Theme
                                      .of(context)
                                      .primaryColor
                                      .withOpacity(1))
                                  : rubikMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                  color: ColorResources.getTextColor(
                                      context)))),
                          Divider(thickness: 3,
                              color: Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(
                                  productProvider.tabIndex == 1 ? 1 : 0.0),
                              endIndent: 20,
                              indent: 20),
                        ]),
                      )),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 100,
                        minWidth: Dimensions.WEB_SCREEN_WIDTH,
                        maxWidth: Dimensions.WEB_SCREEN_WIDTH),
                    child: _tabChildren[productProvider.tabIndex],
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  ResponsiveHelper.isDesktop(context)
                      ? FooterView()
                      : SizedBox(),
                ],),
            ),
          )

          ///mobile view.....
              : Column(children: [
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductImageView(
                                productModel: productProvider.product),
                            Divider(height: 10, thickness: 1),
                            SizedBox(height: 10),
                            ProductTitleView(
                                productModel: productProvider.product),
                            // Divider(height: 20, thickness: 2),

                            // Variation
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: productProvider.product.choiceOptions
                                  .length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, children: [
                                  Text(productProvider.product
                                      .choiceOptions[index].title,
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_LARGE)),
                                  SizedBox(height: Dimensions
                                      .PADDING_SIZE_EXTRA_SMALL),
                                  GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: (1 / 0.25),
                                    ),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: productProvider.product
                                        .choiceOptions[index].options.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          productProvider.setCartVariationIndex(
                                              index, i);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          decoration: BoxDecoration(
                                            color: productProvider
                                                .variationIndex[index] != i
                                                ? ColorResources
                                                .BACKGROUND_COLOR
                                                : Theme
                                                .of(context)
                                                .primaryColor,
                                            borderRadius: BorderRadius.circular(
                                                20),
                                            border: productProvider
                                                .variationIndex[index] != i
                                                ? Border.all(
                                                color: ColorResources
                                                    .BORDER_COLOR, width: 2)
                                                : null,
                                          ),
                                          child: Text(
                                            productProvider.product
                                                .choiceOptions[index].options[i]
                                                .trim(), maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: rubikRegular.copyWith(
                                              color: productProvider
                                                  .variationIndex[index] != i
                                                  ? ColorResources.COLOR_BLACK
                                                  : ColorResources.COLOR_WHITE,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: index !=
                                      productProvider.product.choiceOptions
                                          .length - 1 ? Dimensions
                                      .PADDING_SIZE_LARGE : 0),
                                ]);
                              },
                            ),
                            productProvider.product.choiceOptions.length > 0
                                ? SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE)
                                : SizedBox(),
                            // Quantity
                            Row(children: [
                              Text(getTranslated('quantity', context),
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Expanded(child: SizedBox()),
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorResources.getBackgroundColor(
                                        context),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      if (isExistInCart) {
                                        if (_cartProvider.cartList[_cartProvider
                                            .getCartProductIndex(
                                            _cartModel, false, null)].quantity >
                                            1) {
                                          _cartProvider.setQuantity(
                                              false, _cartModel,
                                              _cartModel.maxQty, context, true,
                                              _cartProvider.getCartProductIndex(
                                                  _cartModel, false, null));
                                        }
                                      } else {
                                        if (productProvider.quantity > 1) {
                                          productProvider.setQuantity(
                                              false, _stock, context);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .PADDING_SIZE_SMALL,
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Text(isExistInCart ? _cartProvider
                                      .cartList[_cartProvider
                                      .getCartProductIndex(
                                      _cartModel, false, null)].quantity
                                      .toString()
                                      : productProvider.quantity.toString(),
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_EXTRA_LARGE)),
                                  InkWell(
                                    onTap: () =>
                                    isExistInCart
                                        ? _cartProvider.setQuantity(
                                        true, _cartModel, 50, context, true,
                                        _cartProvider.getCartProductIndex(
                                            _cartModel, false, null))
                                        : productProvider.setQuantity(
                                        true, _stock, context),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .PADDING_SIZE_SMALL,
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                ]),
                              ),
                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // Row(children: [
                            //   Text('${getTranslated('total_amount', context)}:',
                            //       style: rubikMedium.copyWith(
                            //           fontSize: Dimensions.FONT_SIZE_LARGE)),
                            //   SizedBox(
                            //       width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            //   Text(PriceConverter.convertPrice(
                            //       context, priceWithQuantity ?? 0.0),
                            //       style: rubikBold.copyWith(
                            //         color: Theme
                            //             .of(context)
                            //             .primaryColor,
                            //         fontSize: Dimensions.FONT_SIZE_LARGE,
                            //       )),
                            // ]),
                            SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            // Tab Bar
                            Row(
                                children: [

                              Expanded(child: InkWell(
                                onTap: () => productProvider.setTabIndex(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                      getTranslated('description', context),
                                      style: productProvider.tabIndex == 0
                                          ? rubikMedium
                                          : rubikRegular),
                                  SizedBox(height: 20,),

                                  // Divider(thickness: 3, color: Theme
                                  //     .of(context)
                                  //     .primaryColor
                                  //     .withOpacity(
                                  //     productProvider.tabIndex == 0 ? 1 : 0.2)),
                                ]),
                              )),
                              SizedBox(height: 12,),

                              // Expanded(child: InkWell(
                              //   onTap: () => productProvider.setTabIndex(1),
                              //   child: Column(children: [
                              //     Center(child: Text(getTranslated('review', context), style: productProvider.tabIndex == 1 ? rubikMedium : rubikRegular)),
                              //     Divider(thickness: 3, color: Theme.of(context).primaryColor.withOpacity(productProvider.tabIndex == 1 ? 1 : 0.2)),
                              //   ]),
                              // )),
                            ]),

                            (productProvider.product != null &&
                                productProvider.productReviewList != null) ?
                            _tabChildren[productProvider.tabIndex] : SizedBox(),

                            // Column(children: [
                            //   Center(child: Text(getTranslated('review', context), style: productProvider.tabIndex == 1 ? rubikMedium : rubikRegular)),
                            //   Divider(thickness: 3, color: Theme.of(context).primaryColor.withOpacity(productProvider.tabIndex == 1 ? 1 : 0.2)),
                            // ]),
                          ]
                      ),



                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: 1170,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(
                btnTxt: getTranslated(
                    isExistInCart ? 'already_added_in_cart' : _stock <= 0
                        ? 'out_of_stock'
                        : 'add_to_cart', context),
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                onTap: (!isExistInCart && _stock > 0) ? () {
                  if (!isExistInCart && _stock > 0) {
                    Provider.of<CartProvider>(context, listen: false).addToCart(
                        _cartModel, null);
                    _key.currentState.shake();
                    showCustomSnackBar(getTranslated('added_to_cart', context),
                        context, isError: false);
                  }
                } : null,
              ),

            ),

            SizedBox(height: 12,),






          ]) : ProductDetailsShimmer(isEnabled: true,
              isWeb: ResponsiveHelper.isDesktop(context)
                  ? true
                  : false) /*Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))*/,
        );
      },
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;
  final bool isExistInCart;
  final CartModel cart;

  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    @required this.isExistInCart,
    @required this.cart,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isExistInCart) {
          if (!isIncrement && quantity > 1) {
            Provider.of<CartProvider>(context, listen: false).setQuantity(
                false, cart, cart.maxQty, context, true,
                Provider.of<CartProvider>(context, listen: false)
                    .getCartProductIndex(cart, false, null));
          } else if (isIncrement) {
            if (quantity < stock) {
              Provider.of<CartProvider>(context, listen: false).setQuantity(
                  true, cart, cart.maxQty, context, true,
                  Provider.of<CartProvider>(context, listen: false)
                      .getCartProductIndex(cart, false, null));
            } else {
              showCustomSnackBar(
                  getTranslated('out_of_stock', context), context);
            }
          }
        } else {
          if (!isIncrement && quantity > 1) {
            Provider.of<ProductProvider>(context, listen: false).setQuantity(
                false, stock, context);
          } else if (isIncrement) {
            if (quantity < stock) {
              Provider.of<ProductProvider>(context, listen: false).setQuantity(
                  true, stock, context);
            } else {
              showCustomSnackBar(
                  getTranslated('out_of_stock', context), context);
            }
          }
        }
      },
      child: Container(
        // padding: EdgeInsets.all(3),
        height: 50, width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Theme
            .of(context)
            .primaryColor),
        child: Center(
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: isIncrement
                ? ColorResources.COLOR_WHITE
                : quantity > 1
                ? ColorResources.COLOR_WHITE
                : ColorResources.COLOR_WHITE,
            size: isCartWidget ? 26 : 20,
          ),
        ),
      ),
    );
  }
}
