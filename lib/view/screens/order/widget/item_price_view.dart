import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_divider.dart';
import 'package:flutter/material.dart';

class ItemPriceView extends StatelessWidget {
  final double itemsPrice;
  final double tax;
  final double subTotal;
  final double discount;
  final double extraDiscount;
  final OrderProvider order;
  final double deliveryCharge;
  final double total;
  const ItemPriceView({Key key, @required this.itemsPrice, @required this.tax, @required this.subTotal, @required this.discount, @required this.order, @required this.deliveryCharge, @required this.total, this.extraDiscount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text(PriceConverter.convertPrice(context, itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('tax', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(+) ${PriceConverter.convertPrice(context, tax)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: CustomDivider(),
        ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text(PriceConverter.convertPrice(context, subTotal), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(-) ${PriceConverter.convertPrice(context, discount)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),
        order.trackModel.orderType=="pos"?
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(getTranslated('extra_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            Text('(-) ${PriceConverter.convertPrice(context, extraDiscount ?? 0.0)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          ]),
        ):SizedBox(),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('coupon_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text(
            '(-) ${PriceConverter.convertPrice(context, order.trackModel.couponDiscountAmount)}',
            style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
        ]),
        SizedBox(height: 10),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('delivery_fee', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ]),

        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: CustomDivider(),
        ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
          )),
          Text(
            PriceConverter.convertPrice(context, total),
            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
          ),
        ]),

      ],
    );
  }
}