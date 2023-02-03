import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/screens/order/widget/order_item.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/screens/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel> orderList;
          if(order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList.reversed.toList() : order.historyOrderList.reversed.toList();
          }

          return orderList != null ? orderList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 450),
                        child: SizedBox(
                          width: 1170,
                          child: ResponsiveHelper.isDesktop(context) ?  GridView.builder(
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT, childAspectRatio: 3/1),
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: orderList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => OrderItem(orderList: orderList, order: order, index: index, isRunning : isRunning),
                          ) :
                          ListView.builder(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: orderList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return  OrderItem(orderList: orderList, order: order, index: index, isRunning : isRunning);
                            },
                          ),
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),

                  ],
                ),
              ),
            ),
          ) : SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                    child: NoDataScreen(isOrder: true),
                  ),
                  if(ResponsiveHelper.isDesktop(context)) FooterView(),
                ],
              )) : OrderShimmer();
        },
      ),
    );
  }
}


