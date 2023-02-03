import 'package:emarket_user/data/model/response/address_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/location_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/address/widget/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/custom_app_bar_2.dart';
import 'widget/add_button_view.dart';


class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : CustomAppBar2(title: getTranslated('address', context), ),
      floatingActionButton: _isLoggedIn ? Padding(
        padding:  EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ?  Dimensions.PADDING_SIZE_LARGE : 0),
        child: !ResponsiveHelper.isDesktop(context) ? FloatingActionButton(
          child: Icon(
              Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('address', 'add', AddressModel())),
        ) : null,
      ) : null,
      body: _isLoggedIn ? Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return locationProvider.addressList != null ? locationProvider.addressList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,

            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                        child: SizedBox(
                            width: 1170,
                          child: ResponsiveHelper.isDesktop(context) ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AddButtonView(onTap: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('address', 'add', AddressModel()))),
                              GridView.builder(
                                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT, childAspectRatio: 4),
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: locationProvider.addressList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => AddressWidget(
                                  addressModel: locationProvider.addressList[index], index: index,
                                ),
                              ),
                            ],
                          ) : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: locationProvider.addressList.length,
                            itemBuilder: (context, index) => AddressWidget(
                              addressModel: locationProvider.addressList[index],
                              index: index,
                            ),
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
                Center(
                  child: Container(
                    constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                    width: 1177,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       if(ResponsiveHelper.isDesktop(context)) AddButtonView(onTap: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('address', 'add', AddressModel()))),
                        NoDataScreen(),

                      ],
                    ),
                  ),
                ),
                FooterView(),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }

}



