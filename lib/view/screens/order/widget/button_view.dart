import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:emarket_user/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class ButtonView extends StatelessWidget {
  final OrderProvider order;
  const ButtonView({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !order.showCancelled ? Center(
          child: SizedBox(
            width: 1170,
            child: Row(children: [
              order.trackModel.orderStatus == 'pending' ? Expanded(child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(1, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR)),
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context) => OrderCancelDialog(
                      orderID: order.trackModel.id.toString(),
                      callback: (String message, bool isSuccess, String orderID) {
                        if (isSuccess) {
                          Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
                            context, '1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                          );
                          showCustomSnackBar('$message. Order ID: $orderID', context, isError: false);
                        } else {
                          showCustomSnackBar(message, context);
                        }
                      },
                    ));
                  },
                  child: Text(getTranslated('cancel_order', context), style: Theme.of(context).textTheme.headline3.copyWith(
                    color: ColorResources.DISABLE_COLOR,
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                  )),
                ),
              )) : SizedBox(),
              (order.trackModel.paymentStatus == 'unpaid' && order.trackModel.paymentMethod != 'cash_on_delivery' && order.trackModel.orderStatus
                  != 'delivered') ? Expanded(child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(
                  btnTxt: getTranslated('pay_now', context),
                  onTap: () async {
                    if(ResponsiveHelper.isWeb()) {
                      String hostname = html.window.location.hostname;
                      String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=${order.trackModel.id}&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}'
                          '&&callback=http://$hostname${Routes.ORDER_SUCCESS_SCREEN}/${order.trackModel.id}';
                      html.window.open(selectedUrl, "_self");
                    }else {
                      Navigator.pushReplacementNamed(context, Routes.getPaymentRoute('order', order.trackModel.id.toString(), order.trackModel.userId));
                    }
                  },
                ),
              )) : SizedBox(),
            ]),
          ),
        ) :
        Container(
          width: 1170,
          height: 50,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(getTranslated('order_cancelled', context), style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
        ),

        (order.trackModel.orderStatus == 'confirmed' || order.trackModel.orderStatus == 'processing'
            || order.trackModel.orderStatus == 'out_for_delivery') ? Center(
          child: Container(
            width: 1170,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: CustomButton(
              btnTxt: getTranslated('track_order', context),
              onTap: () {
                Navigator.pushNamed(context, Routes.getOrderTrackingRoute(order.trackModel.id));
              },
            ),
          ),
        ) : SizedBox(),
        if(order.trackModel.deliveryMan != null && (order.trackModel.orderStatus != 'delivered'))
          Center(
            child: Container(
              width:  double.infinity ,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomButton(btnTxt: getTranslated('chat_with_delivery_man', context), onTap: (){
                Navigator.pushNamed(context, Routes.getChatRoute(orderModel: order.trackModel));
              }),
            ),
          ),

        (order.trackModel.orderStatus == 'delivered' && order.trackModel.orderType != 'pos' ) ? Center(
          child: Container(
            width: 1170,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: CustomButton(
              btnTxt: getTranslated('review', context),
              onTap: () {
                //Condition for 0nly one time review ***.where((element) => element.reviewCount == 0).toList()****
                // print('====Delivery Man=====>${order.trackModel.deliveryMan.email}');
                Navigator.pushNamed(context, Routes.getRateReviewRoute(), arguments: RateReviewScreen(
                  orderDetailsList: order.orderDetails,
                  deliveryMan: order.trackModel.deliveryMan,
                  orderId: order.trackModel.id,
                ));
              },
            ),
          ),
        ) : SizedBox(),
      ],
    );
  }
}