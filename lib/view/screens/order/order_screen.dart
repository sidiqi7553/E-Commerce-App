import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController _tabController;
  bool isRunning = true;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) :  CustomAppBar(title: getTranslated('my_order', context),isBackButtonExist: false, Svg: 'assets/icon/bag.svg'),
      body: _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          return Column(children: [

            Divider(),

            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isRunning = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,

                        child: Text(
                          "Running",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(
                              color: isRunning
                                  ? Colors.white: Theme.of(context)
                                  .primaryColor
                              ,
                              fontSize: Dimensions
                                  .FONT_SIZE_LARGE),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),

                            color: isRunning
                                ?Theme.of(context).primaryColor:Colors.white
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isRunning = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "History",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(
                              color: isRunning
                                  ? Theme.of(context)
                                  .primaryColor
                                  : Colors.white,
                              fontSize: Dimensions
                                  .FONT_SIZE_LARGE),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),

                            color: isRunning
                                ? Colors.white
                                : Theme.of(context)
                                .primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                OrderView(isRunning: true),
                OrderView(isRunning: false),
              ],
            )),

          ]);
        },
      ) : NotLoggedInScreen(),
    );
  }
}
