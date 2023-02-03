import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/review_model.dart';
import 'package:emarket_user/helper/api_checker.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/body/review_body_model.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/data/model/response/response_model.dart';
import 'package:emarket_user/data/repository/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({@required this.productRepo});

  // Latest products
  Product _product;
  List<Product> _popularProductList;
  List<Product> _offerProductList;
  bool _isLoading = false;
  int _popularPageSize;
  List<String> _offsetList = [];
  List<int> _variationIndex;
  int _quantity = 1;
  int _imageSliderIndex = 0;
  List<ReviewModel> _productReviewList;
  int _tabIndex = 0;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  int offset = 1;

  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;


  Product get product => _product;
  List<Product> get popularProductList => _popularProductList;
  List<Product> get offerProductList => _offerProductList;
  bool get isLoading => _isLoading;
  int get popularPageSize => _popularPageSize;
  List<int> get variationIndex => _variationIndex;
  int get quantity => _quantity;
  int get imageSliderIndex => _imageSliderIndex;
  List<ReviewModel> get productReviewList => _productReviewList;
  int get tabIndex => _tabIndex;
  double _avgRatting=0.0;
  double _totalRatting=0.0;
  List<int> _starList = [];
 int fiveStarLength ,fourStar,threeStar,twoStar,oneStar;
  double get avgRatting => _avgRatting;
  double get totalRatting => _totalRatting;
  List<int> get starList => _starList;

  void getPopularProductList(BuildContext context, String offset, bool reload, String languageCode) async {
    if(reload || offset == '1') {
      _offsetList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(offset, languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        if (offset == '1') {
          _popularProductList = [];
        }
        _popularProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _popularPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getProductDetails(BuildContext context, Product product, CartModel cart, String languageCode) async {
    if(product.name != null) {
      _product = product;
    }else {
      _product = null;
      ApiResponse apiResponse = await productRepo.getProductDetails(product.id.toString(), languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _product = Product.fromJson(apiResponse.response.data);
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    initData(_product, cart);
  }
  Future<void> getOfferProductList(BuildContext context, bool reload, String languageCode) async {
    if(offerProductList == null || reload) {
      ApiResponse apiResponse = await productRepo.getOfferProductList(languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _offerProductList = [];
        apiResponse.response.data.forEach((offerProduct) => _offerProductList.add(Product.fromJson(offerProduct)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void setImageSliderIndex(int index) {
    _imageSliderIndex = index;
    notifyListeners();
  }

  void initData(Product product, CartModel cart) {
    _productReviewList = [];
    _tabIndex = 0;
    _variationIndex = [];
    if(cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if(cart.variation[0].type != null) {
        _variationTypes.addAll(cart.variation[0].type.split('-'));
      }
      int _varIndex = 0;
      product.choiceOptions.forEach((choiceOption) {
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') ==
              _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
    }else {
      _quantity = 1;
      product.choiceOptions.forEach((element) => _variationIndex.add(0));
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement, int stock, BuildContext context) {
    if (isIncrement) {
      if(_quantity >= stock) {
        showCustomSnackBar(getTranslated('out_of_stock', context), context);
      }else {
        _quantity = _quantity + 1;
      }
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    _quantity = 1;
    notifyListeners();
  }


  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> getProductReviews(BuildContext context, int productID) async {
    ApiResponse response = await productRepo.getProductReviewList(productID);
    if (response.response != null && response.response.statusCode == 200) {
      _productReviewList = [];
      response.response.data.forEach((review) {
        ReviewModel reviewModel= ReviewModel.fromJson(review);

        _productReviewList.add(reviewModel);

      });
       fiveStarLength = _productReviewList.where((element) => element.rating >= 4.5).length;
       fourStar = _productReviewList.where((element) => (element.rating >= 3.5 && element.rating<4.5)).length;
       threeStar = _productReviewList.where((element) => (element.rating >= 2.5 && element.rating<3.5)).length;
       twoStar = _productReviewList.where((element) => (element.rating >= 1.5 && element.rating<2.5)).length;
       oneStar = _productReviewList.where((element) => (element.rating >= 0 && element.rating<1.5)).length;

       print('--> $fiveStarLength + $fourStar + $threeStar + $twoStar + $oneStar');

       } else {
      String errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      print(errorMessage);
      ApiChecker.checkApi(context, response);
    }
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  updateSetMenuCurrentIndex(int index, int totalLength) {
    if(index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    }else{
      _pageFirstIndex = true;
      notifyListeners();
    }
    if(index + 1  == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    }else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }

}
