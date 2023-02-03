import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/screens/checkout/checkout_screen.dart';
import 'package:emarket_user/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/order_provider.dart';

class OrderItem extends StatelessWidget {
  final List<OrderModel> orderList;
  final OrderProvider order;
  final int index;
  final bool isRunning;
  const OrderItem({Key key, @required this.orderList, @required this.order, @required this.index, @required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(
            color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
            spreadRadius: 1, blurRadius: 5,
          )],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [

          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                Images.placeholder(context),
                height: 70, width: 80, fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(orderList[index].id.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Expanded(child: orderList[index].orderType == 'self_pickup' ? Text(
                    '(${getTranslated('self_pickup', context)})',
                    style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                  ) : SizedBox()),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  '${orderList[index].detailsCount} ${getTranslated( orderList[index].detailsCount > 1 ? 'items' : 'item', context)}',
                  style: rubikRegular.copyWith(color: ColorResources.COLOR_GREY),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Row(children: [
                  Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 15),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    getTranslated(orderList[index].orderStatus, context),
                    style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ]),
              ]),
            ),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          SizedBox(
            height: 50,
            child: Row(children: [
              Expanded(child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder( side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR)),
                  minimumSize: Size(1, 50),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.getOrderDetailsRoute(orderList[index].id),
                    arguments: OrderDetailsScreen(orderModel: orderList[index], orderId: orderList[index].id),
                  );
                },
                child: Text(getTranslated('details', context), style: Theme.of(context).textTheme.headline3.copyWith(
                  color: ColorResources.DISABLE_COLOR,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              )),
              SizedBox(width: 20),
              Expanded(child:
                  orderList[index].orderType == 'pos'? SizedBox():
              CustomButton(
                btnTxt: getTranslated(isRunning ? 'track_order' : 'reorder', context),
                onTap: () async {
                  if(isRunning) {
                    Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderList[index].id));
                  }else {
                    List<OrderDetailsModel> orderDetails = await order.getOrderDetails(
                      orderList[index].id.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                    );
                    List<Variation> variation = [];
                    List<CartModel> _cartList = [];
                    List<bool> _availableList = [];
                    orderDetails.forEach((orderDetail) {
                      String xyz = orderDetail.variation;
                      String type;
                      double price;
                      int stock;
                     if(xyz !=null && xyz.isNotEmpty){

                       final split = xyz.split('-');
                       final Map<int, String> values = {
                         for (int i = 0; i < split.length; i++)
                           i: split[i]
                       };
                       final value1 = values[0];

                       final value2 = values[split.length-2];
                       final value3 = values[split.length-1];
                       type = value1;
                       price = double.parse(value2);
                       stock = int.parse(value3);

                       Variation v = Variation(type: type, price: price, stock: stock);
                       variation.add(v);
                     }
                      _cartList.add(CartModel(
                          orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price, orderDetail.discountOnProduct, 'amount'),
                          variation, orderDetail.discountOnProduct, orderDetail.quantity,
                          orderDetail.taxAmount, orderDetail.productDetails.totalStock, orderDetail.productDetails
                      )
                      );
                    });
                    if(_availableList.contains(false)) {
                      showCustomSnackBar(getTranslated('one_or_more_product_unavailable', context), context);
                    }else {
                      Navigator.pushNamed(
                        context,
                        Routes.getCheckoutRoute(orderList[index].orderAmount, 'reorder', orderList[index].orderType),
                        arguments: CheckoutScreen(
                          cartList: _cartList,
                          fromCart: false,
                          amount: orderList[index].orderAmount,
                          orderType: orderList[index].orderType,
                        ),
                      );
                    }
                  }
                },
              )),
            ]),
          ),

        ]),
      ),
    );
  }
}