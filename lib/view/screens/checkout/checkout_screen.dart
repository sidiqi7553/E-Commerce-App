import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:emarket_user/data/model/response/address_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/view/base/custom_divider.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:emarket_user/view/screens/checkout/widget/delivery_fee_dialog.dart';
import 'package:universal_html/html.dart' as html;
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emarket_user/data/model/body/place_order_body.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/config_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/coupon_provider.dart';
import 'package:emarket_user/provider/location_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/screens/checkout/widget/custom_check_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../base/custom_app_bar_2.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final double amount;
  final String orderType;
  final bool fromCart;
  CheckoutScreen({ @required this.amount, @required this.orderType, @required this.fromCart, @required this.cartList});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  List<Branches> _branches = [];
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
      Provider.of<OrderProvider>(context, listen: false).clearPrevData();
      _isCashOnDeliveryActive = Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery == 'true';
      _isDigitalPaymentActive = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment == 'true';
      _cartList = [];
      widget.fromCart ? _cartList.addAll(Provider.of<CartProvider>(context, listen: false).cartList) : _cartList.addAll(widget.cartList);
      if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.status == 1;
    bool _selfPickup = widget.orderType == 'self_pickup';

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) :  CustomAppBar2(title: getTranslated('checkout', context,), ),
      body: _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          double _deliveryCharge = order.distance
              * Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.shippingPerKm;
          if(_deliveryCharge < Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge) {
            _deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge;
          }
          if(!_kmWiseCharge || order.distance == -1) {
            _deliveryCharge = 0;
          }

          return Consumer<LocationProvider>(
            builder: (context, address, child) {
              final _height = MediaQuery.of(context).size.height;
              return Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                                width: 1170,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  if(!ResponsiveHelper.isDesktop(context)) mapView(context, order, _selfPickup, address, _kmWiseCharge),

                                 if(!ResponsiveHelper.isDesktop(context)) detailsView(context, _kmWiseCharge, _selfPickup, order, _deliveryCharge, address),
                                 if(ResponsiveHelper.isDesktop(context)) Padding(
                                   padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                                    blurRadius: 10,
                                                  )
                                                ]
                                            ),
                                            child: mapView(
                                                context, order, _selfPickup, address, _kmWiseCharge),
                                          ),
                                        ),

                                        SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                                    blurRadius: 10,
                                                  )
                                                ]
                                            ),
                                            child: detailsView(
                                                context, _kmWiseCharge, _selfPickup, order, _deliveryCharge, address),
                                          ),
                                        ),

                                      ],
                                    ),
                                 ),



                                ]),
                              ),
                            ),
                            if(ResponsiveHelper.isDesktop(context)) FooterView(),
                          ],
                        ),
                      ),
                    ),
                  ),

                 if(!ResponsiveHelper.isDesktop(context)) buttonView(order, _selfPickup, address, _kmWiseCharge, _deliveryCharge, context),

                ],
              );
            },
          );
        },
      ) : NotLoggedInScreen(),
    );
  }

  Container buttonView(OrderProvider order, bool _selfPickup, LocationProvider address, bool _kmWiseCharge, double _deliveryCharge, BuildContext context) {
    return Container(
                  width: 1170,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: !order.isLoading ? Builder(
                    builder: (context) => CustomButton(btnTxt: getTranslated('confirm_order', context), onTap: () {
                      print('address id : ${_branches[order.branchIndex].id}');
                      if(widget.amount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                        showCustomSnackBar('Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}', context);
                      }else if(!_selfPickup && (address.addressList == null || address.addressList.length == 0 || order.addressIndex < 0)) {
                        showCustomSnackBar(getTranslated('select_an_address', context), context);
                      }else if (!_selfPickup && _kmWiseCharge && order.distance == -1) {
                        showCustomSnackBar(getTranslated('delivery_fee_not_set_yet', context), context);
                      }else if (!_isCashOnDeliveryActive && !_isDigitalPaymentActive) {
                        showCustomSnackBar(getTranslated('payment_method_is_not_activated_please_order_later', context), context,isError: true);
                      }
                      else {
                        List<Cart> carts = [];
                        for (int index = 0; index < _cartList.length; index++) {
                          CartModel cart = _cartList[index];
                          carts.add(Cart(
                            cart.product.id.toString(), cart.discountedPrice.toString(), '', cart.variation,
                            cart.discountAmount, cart.quantity, cart.taxAmount,
                          ));
                        }
                        order.placeOrder(
                          PlaceOrderBody(
                            cart: carts, couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount, couponDiscountTitle: '',
                            deliveryAddressId: !_selfPickup ? Provider.of<LocationProvider>(context, listen: false)
                                .addressList[order.addressIndex].id : 0,
                            orderAmount: widget.amount+_deliveryCharge, orderNote: _noteController.text ?? '', orderType: widget.orderType,
                            paymentMethod: _isCashOnDeliveryActive ? order.paymentMethodIndex == 0 ? 'cash_on_delivery' : null : null,
                            couponCode: Provider.of<CouponProvider>(context, listen: false).coupon != null
                                ? Provider.of<CouponProvider>(context, listen: false).coupon.code : null,
                            branchId: _branches[order.branchIndex].id, distance: _selfPickup ? 0 : order.distance,
                          ), _callback,
                        );
                      }
                    }),
                  ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                );
  }

  Column mapView(BuildContext context, OrderProvider order, bool _selfPickup, LocationProvider address, bool _kmWiseCharge)  {
    return Column(
      children: [
        _branches.length > 1 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(getTranslated('select_branch', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: BouncingScrollPhysics(),
              itemCount: _branches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                  child: InkWell(
                    onTap: () {
                      order.setBranchIndex(index);
                      _setMarkers(index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == order.branchIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(_branches[index].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikMedium.copyWith(
                        color: index == order.branchIndex ? Colors.white : Theme.of(context).textTheme.bodyText1.color,
                      )),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            height: 200,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Stack(children: [
              GoogleMap(
                minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(
                  double.parse(_branches[0].latitude),
                  double.parse(_branches[0].longitude),
                ), zoom: 16),
                zoomControlsEnabled: true,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) async {
                  await Geolocator.requestPermission();
                  _mapController = controller;
                  _loading = false;
                  _setMarkers(0);
                },
              ),
              _loading ? Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )) : SizedBox(),
            ]),
          ),
        ]) : SizedBox(),


        !_selfPickup ? Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Text(getTranslated('delivery_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              Expanded(child: SizedBox()),
              TextButton.icon(
                onPressed: () =>  Navigator.pushNamed(context, Routes.getAddAddressRoute('checkout', 'add', AddressModel())),
                icon: Icon(Icons.add),
                label: Text(getTranslated('add', context), style: rubikRegular),
              ),
            ]),
          ),

          SizedBox(
            height: 60,
            child: address.addressList != null ? address.addressList.length > 0 ? ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: address.addressList.length,
              itemBuilder: (context, index) {
                bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
                if(!_isAvailable) {
                  double _distance = Geolocator.distanceBetween(
                    double.parse(_branches[order.branchIndex].latitude), double.parse(_branches[order.branchIndex].longitude),
                    double.parse(address.addressList[index].latitude), double.parse(address.addressList[index].longitude),
                  ) / 1000;
                  _isAvailable = _distance < _branches[order.branchIndex].coverage;
                }
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                  child: InkWell(
                    onTap: () async {
                      if(_isAvailable) {
                        order.setAddressIndex(index);
                        if(_kmWiseCharge) {
                          showDialog(context: context, builder: (context) => Center(child: Container(
                            height: 100, width: 100, decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                          ),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                          )), barrierDismissible: false);
                          bool _isSuccess = await order.getDistanceInMeter(
                            LatLng(
                              double.parse(_branches[order.branchIndex].latitude),
                              double.parse(_branches[order.branchIndex].longitude),
                            ),
                            LatLng(
                              double.parse(address.addressList[index].latitude),
                              double.parse(address.addressList[index].longitude),
                            ),
                          );
                          Navigator.pop(context);
                          if(_isSuccess) {
                            showDialog(context: context, builder: (context) => DeliveryFeeDialog(
                              amount: widget.amount, distance: order.distance,
                            ));
                          }else {
                            showCustomSnackBar(getTranslated('failed_to_fetch_distance', context), context);
                          }
                        }
                      }
                    },
                    child: Stack(children: [
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          color: index == order.addressIndex ? Theme.of(context).cardColor : ColorResources.getBackgroundColor(context),
                          borderRadius: BorderRadius.circular(10),
                          border: index == order.addressIndex ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                        ),
                        child: Row(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(
                              address.addressList[index].addressType == 'Home' ? Icons.home_outlined
                                  : address.addressList[index].addressType == 'Workplace' ? Icons.work_outline : Icons.list_alt_outlined,
                              color: index == order.addressIndex ? Theme.of(context).primaryColor
                                  : Theme.of(context).textTheme.bodyText1.color,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(address.addressList[index].addressType, style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context),
                              )),
                              Text(address.addressList[index].address, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ]),
                          ),
                          index == order.addressIndex ? Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                          ) : SizedBox(),
                        ]),
                      ),
                      !_isAvailable ? Positioned(
                        top: 0, left: 0, bottom: 0, right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                          child: Text(
                            getTranslated('out_of_coverage_for_this_branch', context),
                            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ) : SizedBox(),
                    ]),
                  ),
                );
              },
            ) : Center(child: Text(getTranslated('no_address_available', context)))
                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
          ),
          SizedBox(height: 20),
        ]) : SizedBox(),
      ],
    );
  }

  Column detailsView(BuildContext context, bool _kmWiseCharge, bool _selfPickup, OrderProvider order, double _deliveryCharge, LocationProvider address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: Text(getTranslated('payment_method', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),
        _isCashOnDeliveryActive ? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0) : SizedBox(),
        _isDigitalPaymentActive ? CustomCheckBox(title: getTranslated('digital_payment', context), index: _isCashOnDeliveryActive ? 1 : 0)
            :SizedBox.shrink(),
        _isCashOnDeliveryActive || _isDigitalPaymentActive ? SizedBox.shrink() :  Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text('No Payment Method is Active',style: rubikRegular),
        ),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomTextField(
            controller: _noteController,
            hintText: getTranslated('additional_note', context),
            maxLines: 5,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          ),
        ),

        _kmWiseCharge ? Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              Text(PriceConverter.convertPrice(context, widget.amount), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            ]),
            SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                getTranslated('delivery_fee', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
              Text(
                (_selfPickup || order.distance != -1) ? '(+) ${PriceConverter.convertPrice(context, _selfPickup ? 0 : _deliveryCharge)}'
                    : getTranslated('not_found', context),
                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
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
                PriceConverter.convertPrice(context, widget.amount+_deliveryCharge),
                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
              ),
            ]),
          ]),
        ) : SizedBox(),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        if(ResponsiveHelper.isDesktop(context)) buttonView(order, _selfPickup, address, _kmWiseCharge, _deliveryCharge, context),

      ],
    );
  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
        context, '1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
      if(_isCashOnDeliveryActive && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
      }else {
        if (ResponsiveHelper.isWeb()) {
          String hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).getUserId()
          }'
              '&&callback=$protocol//$hostname${Routes.ORDER_SUCCESS_SCREEN}/$orderID';
          html.window.open(selectedUrl, "_self");

        } else {
          Navigator.pushReplacementNamed(context, Routes.getPaymentRoute('checkout', orderID, Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id));
        }
      }
    }else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  void _setMarkers(int selectedIndex) async {
    BitmapDescriptor _bitmapDescriptor;
    BitmapDescriptor _bitmapDescriptorUnSelect;
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 50)), Images.restaurant_marker).then((_marker) {
      _bitmapDescriptor = _marker;
    });
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20, 20)), Images.unselected_restaurant_marker).then((_marker) {
      _bitmapDescriptorUnSelect = _marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index<_branches.length; index++) {
      _markers.add(Marker(
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branches[index].latitude), double.parse(_branches[index].longitude)),
        infoWindow: InfoWindow(title: _branches[index].name, snippet: _branches[index].address),
        icon: selectedIndex == index ? _bitmapDescriptor : _bitmapDescriptorUnSelect,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
      double.parse(_branches[selectedIndex].latitude),
      double.parse(_branches[selectedIndex].longitude),
    ), zoom: ResponsiveHelper.isMobile(context) ? 12 : 16)));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

  // void _checkPermission(BuildContext context, String navigateTo) async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if(permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   if(permission == LocationPermission.denied) {
  //     showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
  //   }else if(permission == LocationPermission.deniedForever) {
  //     showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
  //   }else {
  //     Navigator.pushNamed(context, navigateTo);
  //   }
  // }

}
