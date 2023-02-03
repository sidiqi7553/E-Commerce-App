import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/location_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/screens/track/widget/custom_stepper.dart';
import 'package:emarket_user/view/screens/track/widget/delivery_man_widget.dart';
import 'package:emarket_user/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderID;
  OrderTrackingScreen({@required this.orderID,});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(orderID, context);
    Provider.of<OrderProvider>(context, listen: false).trackOrder(orderID, null, context, true);

    final List<String> _statusList = ['pending', 'confirmed', 'processing' ,'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : CustomAppBar(title: getTranslated('order_tracking', context), Svg: ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _size.height < 600 ? _size.height : _size.height - 400),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                    String _status;
                    if(order.trackModel != null) {
                      _status = order.trackModel.orderStatus;
                    }

                    if(_status != null && _status == _statusList[5] || _status == _statusList[6] || _status == _statusList[7]) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_status),
                          SizedBox(height: 50),
                          CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                          }),
                        ],
                      );
                    } else if(order.responseModel != null && !order.responseModel.isSuccess) {
                      return Center(child: Text(order.responseModel.message));
                    }

                    return _status != null ? RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(orderID, context);
                        await Provider.of<OrderProvider>(context, listen: false).trackOrder(orderID, null, context, true);
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  padding: _size.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                                  decoration: _size.width > 700 ? BoxDecoration(
                                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                                  ) : null,
                                  child: SizedBox(
                                    width: 1170,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            color: Theme.of(context).cardColor,
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text('${getTranslated('order_id', context)} #${order.trackModel.id}',
                                                    style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                              ),
                                              Text(
                                                '${getTranslated('amount', context)} : ${PriceConverter.convertPrice(context, order.trackModel.orderAmount)}',
                                                style: rubikRegular,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                                    order.trackModel.deliveryAddress != null ? Container(
                                          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
                                            ],
                                          ),
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                                            SizedBox(width: 20),

                                            Expanded(
                                              child: Text(
                                                order.trackModel.deliveryAddress != null? order.trackModel.deliveryAddress.address : getTranslated('address_was_deleted', context),
                                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context)),
                                              ),
                                            ),
                                          ]),
                                        ) : SizedBox(),

                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                        order.trackModel.deliveryMan != null ? DeliveryManWidget(deliveryMan: order.trackModel.deliveryMan) : SizedBox(),
                                        order.trackModel.deliveryMan != null ? SizedBox(height: 30) : SizedBox(),

                                        CustomStepper(
                                          title: getTranslated('order_placed', context),
                                          isActive: true,
                                          haveTopBar: false,
                                        ),
                                        CustomStepper(
                                          title: getTranslated('order_accepted', context),
                                          isActive: _status != _statusList[0],
                                        ),
                                        CustomStepper(
                                          title: getTranslated('preparing_food', context),
                                          isActive: _status != _statusList[0] && _status != _statusList[1],
                                        ),
                                        order.trackModel.deliveryAddress != null ? CustomStepper(
                                          title: getTranslated('food_in_the_way', context),
                                          isActive: _status != _statusList[0] && _status != _statusList[1] && _status != _statusList[2],
                                        ) : SizedBox(),
                                        (order.trackModel != null && order.trackModel.deliveryAddress != null) ?
                                        CustomStepper(
                                          title: getTranslated('delivered_the_food', context),
                                          isActive: _status == _statusList[4], height: _status == _statusList[3] ? 240 : 30,
                                          child: _status == _statusList[3] ? Flexible(
                                            child: TrackingMapWidget(
                                              deliveryManModel: order.deliveryManModel,
                                              orderID: orderID,
                                                addressModel: order.trackModel.deliveryAddress??''
                                             ),
                                          ) : null,
                                        ) : CustomStepper(
                                          title: getTranslated('delivered_the_food', context),
                                          isActive: _status == _statusList[4], height: _status == _statusList[3] ? 30 : 30,
                                        ),
                                        SizedBox(height: 50),


                                         Center(
                                           child: SizedBox(
                                            width: ResponsiveHelper.isDesktop(context) ?  400 : _size.width,
                                            child: CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                                              Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                            }),
                                           )
                                         ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                  },
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ),
    );
  }
}
