import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/coupon_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_divider.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/screens/cart/widget/cart_product_widget.dart';
import 'package:emarket_user/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utill/images.dart';

class CartScreen extends StatelessWidget {
  final bool fromDetails;

  CartScreen({this.fromDetails = false});

  @override
  Widget build(BuildContext context) {
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);
    final TextEditingController _couponController = TextEditingController();
    final _height = MediaQuery.of(context).size.height;
    bool _isSelfPickupActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .selfPickup ==
            1;
    bool _kmWiseCharge = Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .deliveryManagement
            .status ==
        1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : CustomAppBar(
              title: getTranslated('my_cart', context , ),
              isBackButtonExist: fromDetails,
        Svg: 'assets/icon/bag.svg',
            ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          double deliveryCharge = 0;
          (Provider.of<OrderProvider>(context).orderType == 'delivery' &&
                  !_kmWiseCharge)
              ? deliveryCharge =
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .deliveryCharge
              : deliveryCharge = 0;
          double _itemPrice = 0;
          double _discount = 0;
          double _tax = 0;
          cart.cartList.forEach((cartModel) {
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
            _discount =
                _discount + (cartModel.discountAmount * cartModel.quantity);
            _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _tax;
          double _total = _subTotal -
              _discount -
              Provider.of<CouponProvider>(context).discount +
              deliveryCharge;

          return cart.cartList.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  constraints: BoxConstraints(
                                      minHeight: !ResponsiveHelper.isDesktop(
                                                  context) &&
                                              _height < 600
                                          ? _height
                                          : _height - 400),
                                  width: 1170,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!ResponsiveHelper.isDesktop(
                                            context))
                                          productView(cart, _total,
                                              _couponController, context),
                                        // Product
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        if (!ResponsiveHelper.isDesktop(
                                            context))
                                          detailsView(
                                              _isSelfPickupActive,
                                              context,
                                              _kmWiseCharge,
                                              _itemPrice,
                                              _tax,
                                              _discount,
                                              deliveryCharge,
                                              _total,
                                              _couponController),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              Expanded(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: ColorResources
                                                            .CARD_SHADOW_COLOR
                                                            .withOpacity(0.2),
                                                        blurRadius: 10,
                                                      )
                                                    ]),
                                                //margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                                                padding: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_LARGE,
                                                        vertical: Dimensions
                                                            .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.zero,
                                                child: productView(cart, _total,
                                                    _couponController, context),
                                              )),
                                            // Product
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_LARGE),

                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              Expanded(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: ColorResources
                                                            .CARD_SHADOW_COLOR
                                                            .withOpacity(0.2),
                                                        blurRadius: 10,
                                                      )
                                                    ]),
                                                //margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                                                padding: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_LARGE,
                                                        vertical: Dimensions
                                                            .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.zero,
                                                child: detailsView(
                                                    _isSelfPickupActive,
                                                    context,
                                                    _kmWiseCharge,
                                                    _itemPrice,
                                                    _tax,
                                                    _discount,
                                                    deliveryCharge,
                                                    _total,
                                                    _couponController),
                                              )),
                                          ],
                                        )
                                        // Order type
                                      ]),
                                ),
                              ),
                              if (ResponsiveHelper.isDesktop(context))
                                FooterView(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!ResponsiveHelper.isDesktop(context))
                      buttonView(context, _itemPrice, _total),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: !ResponsiveHelper.isDesktop(context) &&
                                    _height < 600
                                ? _height
                                : _height - 400),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15.0),
                              child: SvgPicture.asset('assets/icon/img.svg',
                                  matchTextDirection: true,
                                  height: MediaQuery.of(context).size.height / 4.5),
                            ),
                            Center(
                                child: Text(
                                  "Your cart is empty!",
                                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                                )),
                            SizedBox(height: 10,),
                            Center(
                                child: Text(
                                  "Looks like you have not added  any \n items to your cart yet.",
                                  style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 12, color: ColorResources.getGreyBunkerColor(context)),
                                )),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomButton(
                                btnTxt: "Shop Now",
                                onTap: () async {
                                  Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);

                                },

                              ),
                            )


                          ],
                        ),

                      ),
                      if (ResponsiveHelper.isDesktop(context)) FooterView(),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Container buttonView(BuildContext context, double _itemPrice, double _total) {
    return Container(
      width: 1170,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: CustomButton(
          btnTxt: getTranslated('continue_checkout', context),
          onTap: () {
            if (_itemPrice <
                Provider.of<SplashProvider>(context, listen: false)
                    .configModel
                    .minimumOrderValue) {
              showCustomSnackBar(
                  'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _itemPrice)} in your cart, please add more item.',
                  context);
            } else {
              Navigator.pushNamed(
                  context,
                  Routes.getCheckoutRoute(
                      _total,
                      'cart',
                      Provider.of<OrderProvider>(context, listen: false)
                          .orderType));
            }
          }),
    );
  }

  Column productView(CartProvider cart, double _total,
      TextEditingController _couponController, BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cart.cartList.length,
          itemBuilder: (context, index) {
            return CartProductWidget(
                cart: cart.cartList[index], cartIndex: index);
          },
        ),

        // Coupon
        if (!ResponsiveHelper.isDesktop(context))
          cupponView(context, _couponController, _total)
      ],
    );
  }

  Column detailsView(
      bool _isSelfPickupActive,
      BuildContext context,
      bool _kmWiseCharge,
      double _itemPrice,
      double _tax,
      double _discount,
      double deliveryCharge,
      double _total,
      TextEditingController _couponController) {
    return Column(
      children: [
        if (ResponsiveHelper.isDesktop(context))
          cupponView(context, _couponController, _total),
        if (ResponsiveHelper.isDesktop(context))
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        _isSelfPickupActive
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Text(getTranslated('delivery_option', context),
                //     style: rubikMedium.copyWith(
                //         fontSize: Dimensions.FONT_SIZE_LARGE)),
                // DeliveryOptionButton(
                //     value: 'delivery',
                //     title: getTranslated('delivery', context),
                //     kmWiseFee: _kmWiseCharge),
                // DeliveryOptionButton(
                //     value: 'self_pickup',
                //     title: getTranslated('self_pickup', context),
                //     kmWiseFee: _kmWiseCharge),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ])
            : SizedBox(),

        // Total
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('items_price', context),
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text(PriceConverter.convertPrice(context, _itemPrice),
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('tax', context),
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(+) ${PriceConverter.convertPrice(context, _tax)}',
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('discount', context),
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(-) ${PriceConverter.convertPrice(context, _discount)}',
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('coupon_discount', context),
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text(
            '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
            style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
        ]),
        SizedBox(height: 10),

        _kmWiseCharge
            ? SizedBox()
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  getTranslated('delivery_fee', context),
                  style: rubikRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                Text(
                  '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                  style: rubikRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ]),

        Padding(
          padding:
              EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Container(
            height: 1,
            color: Colors.black54,
          ),
        ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
              getTranslated(
                  _kmWiseCharge ? 'subtotal' : 'total_amount', context),
              style: rubikMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                color: Theme.of(context).primaryColor,
              )),
          Text(
            PriceConverter.convertPrice(context, _total),
            style: rubikMedium.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                color: Theme.of(context).primaryColor),
          ),
        ]),

        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        if (ResponsiveHelper.isDesktop(context))
          buttonView(context, _itemPrice, _total),
      ],
    );
  }

  Container cupponView(BuildContext context,
      TextEditingController _couponController, double _total) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
              blurRadius: 10,
            )
          ]),
      child: Consumer<CouponProvider>(
        builder: (context, coupon, child) {
          return Row(children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                style: rubikRegular,
                decoration: InputDecoration(
                  hintText: getTranslated('enter_promo_code', context),
                  hintStyle: rubikRegular.copyWith(
                      color: ColorResources.getHintColor(context)),
                  isDense: true,
                  filled: true,
                  enabled: coupon.discount == 0,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(Provider.of<LocalizationProvider>(
                                  context,
                                  listen: false)
                              .isLtr
                          ? 10
                          : 0),
                      right: Radius.circular(Provider.of<LocalizationProvider>(
                                  context,
                                  listen: false)
                              .isLtr
                          ? 0
                          : 10),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_couponController.text.isNotEmpty && !coupon.isLoading) {
                  if (coupon.discount < 1) {
                    coupon
                        .applyCoupon(_couponController.text, _total)
                        .then((discount) {
                      if (discount > 0) {
                        showCustomSnackBar(
                            'You got ${Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol}$discount discount',
                            context,
                            isError: false);
                      } else {
                        showCustomSnackBar(
                            getTranslated('invalid_code_or', context), context);
                      }
                    });
                  } else {
                    coupon.removeCouponData(true);
                  }
                } else if (_couponController.text.isEmpty) {
                  showCustomSnackBar(
                      getTranslated('enter_a_Coupon_code', context), context);
                }
              },
              child: Container(
                height: 50,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  // borderRadius: BorderRadius.horizontal(
                  //   left: Radius.circular(Provider.of<LocalizationProvider>(
                  //               context,
                  //               listen: false)
                  //           .isLtr
                  //       ? 0
                  //       : 10),
                  //   right: Radius.circular(Provider.of<LocalizationProvider>(
                  //               context,
                  //               listen: false)
                  //           .isLtr
                  //       ? 10
                  //       : 0),
                  // ),
                ),
                child: coupon.discount <= 0
                    ? !coupon.isLoading
                        ? Text(
                            getTranslated('apply', context),
                            style: rubikMedium.copyWith(color: Colors.white),
                          )
                        : CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                    : Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
