import 'package:emarket_user/view/base/on_hover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../helper/price_converter.dart';
import '../../../../../provider/splash_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../../utill/images.dart';
import '../../../../../utill/styles.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/product_provider.dart';
import '../../../../provider/wishlist_provider.dart';
import '../../../../utill/routes.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/rating_bar.dart';
import '../../product/product_details_screen.dart';

class OfferProductPageView extends StatelessWidget {
  final ProductProvider offerProduct;
  final PageController pageController;
  const OfferProductPageView({Key key, @required this.offerProduct, @required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _totalPage = (offerProduct.offerProductList.length / 5).ceil();
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();


    return Container(
      child: PageView.builder(
        controller: pageController,
        itemCount: _totalPage,
        onPageChanged: (index) {
          offerProduct.updateSetMenuCurrentIndex(index, _totalPage);
        },
        itemBuilder: (context, index) {
          int _initialLength = 5;
          int currentIndex = 5 * index;

          // ignore: unnecessary_statements
          (index + 1 == _totalPage) ? _initialLength = offerProduct.offerProductList.length - (index * 5)  : 5;
          return ListView.builder(
              itemCount: _initialLength, scrollDirection: Axis.horizontal, physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
              itemBuilder: (context, item) {
                int _currentIndex = item  + currentIndex;
                String _name = '';
                offerProduct.offerProductList[_currentIndex].name.length > 20 ? _name =  offerProduct.offerProductList[_currentIndex].name.substring(0, 20)+' ...' : _name =  offerProduct.offerProductList[_currentIndex].name;
                double _startingPrice;
                double _endingPrice;
                if( offerProduct.offerProductList[_currentIndex].choiceOptions.length != 0) {
                  List<double> _priceList = [];
                  offerProduct.offerProductList[_currentIndex].variations.forEach((variation) => _priceList.add(variation.price));
                  _priceList.sort((a, b) => a.compareTo(b));
                  _startingPrice = _priceList[0];
                  if(_priceList[0] < _priceList[_priceList.length-1]) {
                    _endingPrice = _priceList[_priceList.length-1];
                  }
                }else {
                  _startingPrice =  offerProduct.offerProductList[_currentIndex].price;
                }

                double _discount =  offerProduct.offerProductList[_currentIndex].price - PriceConverter.convertWithDiscount(context,
                    offerProduct.offerProductList[_currentIndex].price,  offerProduct.offerProductList[_currentIndex].discount,  offerProduct.offerProductList[_currentIndex].discountType);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.RADIUS_SIZE_DEFAULT,vertical: Dimensions.RADIUS_SIZE_DEFAULT),
                  child: OnHover(
                    isItem: true,
                    child: Stack(
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(offerProduct.offerProductList[_currentIndex].id),
                                arguments: ProductDetailsScreen(product: offerProduct.offerProductList[_currentIndex]));
                          },
                          child: Container(
                            width: 218,
                            decoration: BoxDecoration(
                                color: ColorResources.getWebCardColor(context),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  color: ColorResources.COLOR_BLACK.withOpacity(0.08),
                                  blurRadius: 8, spreadRadius: 0,offset: Offset(0,3)
                                )]
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder(context), width: double.infinity, fit: BoxFit.cover,
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${offerProduct.offerProductList[_currentIndex].image[0]}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 225.0, width: 368, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 4 ,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                      child: Center(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Text(_name, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getBlackAndWhiteColor(context)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                          RatingBar(rating: offerProduct.offerProductList[_currentIndex].rating.length > 0 ? double.parse(offerProduct.offerProductList[_currentIndex].rating[0].average) : 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                          _discount > 0 ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            child: Text(
                                                '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                    '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                                style: TextStyle(decoration: TextDecoration.lineThrough)
                                            ),
                                          ) : SizedBox(),

                                          Text(
                                            '${PriceConverter.convertPrice(context, _startingPrice, discount: offerProduct.offerProductList[_currentIndex].discount,
                                                discountType: offerProduct.offerProductList[_currentIndex].discountType, asFixed: 1)}''${_endingPrice!= null
                                                ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: offerProduct.offerProductList[_currentIndex].discount,
                                                discountType: offerProduct.offerProductList[_currentIndex].discountType, asFixed: 1)}' : ''}',
                                            style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.WEB_HEADER_COLOR),
                                          ),




                                        ]),
                                      ),
                                    ),
                                  ),

                                ]),
                          ),
                        ),
                        Positioned(
                          top: 10,right: 10,
                          child: Consumer<WishListProvider>(
                              builder: (context, wishList, child) {
                                return InkWell(
                                  onTap: () {
                                    if(_isLoggedIn){
                                      if(wishList.wishIdList.contains(offerProduct.offerProductList[_currentIndex].id)) {
                                        wishList.removeFromWishList(offerProduct.offerProductList[_currentIndex], (message) {
                                          showCustomSnackBar(message, context, isError: false);
                                        });
                                      }else {
                                        wishList.addToWishList(offerProduct.offerProductList[_currentIndex], (message) {
                                          showCustomSnackBar(message, context, isError: false);
                                        });
                                      }
                                    }else showCustomSnackBar(getTranslated('not_logged_in', context), context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.getWhiteAndBlackColor(context),
                                      shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(
                                            color: ColorResources.COLOR_BLACK.withOpacity(0.08),
                                            blurRadius: 8, spreadRadius: 0,offset: Offset(0,3)
                                        )]
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      wishList.wishIdList.contains(offerProduct.offerProductList[_currentIndex].id) ? Icons.favorite : Icons.favorite_border, size: 25,
                                      color: wishList.wishIdList.contains(offerProduct.offerProductList[_currentIndex].id) ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                    ),
                                  ),
                                );
                              }
                          ),)
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
