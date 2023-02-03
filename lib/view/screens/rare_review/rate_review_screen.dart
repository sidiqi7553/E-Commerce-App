
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/screens/rare_review/widget/deliver_man_review_widget.dart';
import 'package:emarket_user/view/screens/rare_review/widget/product_review_widget.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel> orderDetailsList;
  final DeliveryMan deliveryMan;
  final int orderId;
  RateReviewScreen({@required this.orderDetailsList, @required this.deliveryMan, this.orderId});

  @override
  _RateReviewScreenState createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.deliveryMan == null ? 1 : 2, initialIndex: 0, vsync: this);
    Provider.of<ProductProvider>(context, listen: false).initRatingData(widget.orderDetailsList);
  }
  @override
  Widget build(BuildContext context) {
    print('-----> man---> ${widget.deliveryMan}');
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : CustomAppBar(title: getTranslated('rate_review', context)),

      body: Column(children: [
      Center(
      child: Container(
      width: 1170,
          color: Theme.of(context).cardColor,
          child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).textTheme.bodyText1.color,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              unselectedLabelStyle: rubikRegular.copyWith(color: ColorResources.COLOR_HINT, fontSize: Dimensions.FONT_SIZE_SMALL),
              labelStyle: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              tabs: widget.deliveryMan == null ?
                  [
                    Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
                  ]:  [
              Tab(text: getTranslated(widget.orderDetailsList.length > 1 ? 'items' : 'item', context)),
              Tab(text: getTranslated('delivery_man', context)),
              ] ,
          ),
      ),
      ),

    Expanded(child: TabBarView(
    controller: _tabController,
    children: widget.deliveryMan == null ?
        [
          ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
        ]
        : [
        ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
        DeliveryManReviewWidget(deliveryMan: widget.deliveryMan, orderID: widget.orderId.toString()),
        ] ,
    )),

    ]),
    );
  }
}
