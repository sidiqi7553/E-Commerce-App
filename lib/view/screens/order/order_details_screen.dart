import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/location_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';

import 'widget/button_view.dart';
import 'widget/item_price_view.dart';
import 'widget/order_info_view.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({@required this.orderModel, @required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderId.toString(), widget.orderModel, context, false);
    if(widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(_scaffold);
    }
    await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(
      widget.orderId.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
  }
  @override
  void initState() {
    super.initState();

    _loadData(context);
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffold,
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : CustomAppBar(title: getTranslated('order_details', context), Svg: ''),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double deliveryCharge = 0;
          double _itemsPrice = 0;
          double _discount = 0;
          double _extraDiscount = 0;
          double _tax = 0;
          if(order!=null && order.orderDetails != null) {
            if(order !=null && order.trackModel.orderType == 'delivery') {
              deliveryCharge = order.trackModel.deliveryCharge;
            }
            for(OrderDetailsModel orderDetails in order.orderDetails) {
              _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
              _discount = _discount + (orderDetails.discountOnProduct * orderDetails.quantity);
              _tax = _tax + (orderDetails.taxAmount * orderDetails.quantity);
            }
          }
          if( order.trackModel != null &&  order.trackModel.extraDiscount!=null) {
            _extraDiscount  = order.trackModel.extraDiscount ?? 0.0;
          }
          double _subTotal = _itemsPrice + _tax;
          double _total = _subTotal - _discount -_extraDiscount + deliveryCharge - (order.trackModel != null ? order.trackModel.couponDiscountAmount : 0);

          return order.orderDetails != null ? Column(
            children: [

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                            child: SizedBox(
                              width: 1170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(ResponsiveHelper.isDesktop(context)) Flexible(
                                        child: Container(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                          decoration:  BoxDecoration(
                                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                            boxShadow: [BoxShadow(
                                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
                                              spreadRadius: 1, blurRadius: 5,
                                            )],
                                          ),
                                          child: OrderInfoView(order: order),
                                        ),
                                      ),
                                      if(ResponsiveHelper.isDesktop(context)) SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                      if(ResponsiveHelper.isDesktop(context)) Flexible(
                                        child: Container(
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                            boxShadow: [BoxShadow(
                                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
                                              spreadRadius: 1, blurRadius: 5,
                                            )],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                              ItemPriceView(
                                                  itemsPrice: _itemsPrice, tax:  _tax,subTotal: _subTotal, discount: _discount, order: order, deliveryCharge: deliveryCharge, total: _total,extraDiscount: _extraDiscount
                                                ,),
                                              if(ResponsiveHelper.isDesktop(context)) ButtonView(order: order),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(!ResponsiveHelper.isDesktop(context)) OrderInfoView(order: order), // Total
                                  if(!ResponsiveHelper.isDesktop(context)) ItemPriceView(itemsPrice: _itemsPrice, tax:  _tax,subTotal: _subTotal, discount: _discount, order: order, deliveryCharge: deliveryCharge, total: _total,extraDiscount: _extraDiscount,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if(ResponsiveHelper.isDesktop(context)) SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        if(ResponsiveHelper.isDesktop(context)) FooterView(),
                      ],
                    ),
                  ),
                ),
              ),
             if(!ResponsiveHelper.isDesktop(context)) ButtonView(order: order),
            ],
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}







