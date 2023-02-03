import 'package:emarket_user/data/model/response/language_model.dart';
import 'package:emarket_user/utill/images.dart';

class AppConstants {
  static const String APP_NAME = 'GareyQatar';
  static const double APP_VERSION = 6.1;
  static const String BASE_URL = 'https://gareyqatar.com';
  static const String CATEGORY_URI = '/api/v1/categories';
  static const String BANNER_URI = '/api/v1/banners';
  static const String POPULAR_PRODUCT_URI = '/api/v1/products/latest';
  static const String SEARCH_PRODUCT_URI = '/api/v1/products/details/';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String CATEGORY_PRODUCT_URI = '/api/v1/categories/products/';
  static const String CONFIG_URI = '/api/v1/config';
  static const String TRACK_URI = '/api/v1/customer/order/track?order_id=';
  static const String MESSAGE_URI = '/api/v1/customer/message/get';
  static const String SEND_MESSAGE_URI = '/api/v1/customer/message/send';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
  static const String CHECK_PHONE_URI = 'api/v1/auth/check-phone?phone=';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
  static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';
  static const String REGISTER_URI = '/api/v1/auth/registration';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String REMOVE_ADDRESS_URI =
      '/api/v1/customer/address/delete?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String OFFER_PRODUCT_URI = '/api/v1/products/discounted';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';
  static const String COUPON_URI = '/api/v1/coupon/list';
  static const String COUPON_APPLY_URI = '/api/v1/coupon/apply?code=';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';
  static const String ORDER_CANCEL_URI = '/api/v1/customer/order/cancel';
  static const String UPDATE_METHOD_URI =
      '/api/v1/customer/order/payment-method';
  static const String ORDER_DETAILS_URI =
      '/api/v1/customer/order/details?order_id=';
  static const String WISH_LIST_GET_URI = '/api/v1/customer/wish-list';
  static const String ADD_WISH_LIST_URI =
      '/api/v1/customer/wish-list/add?product_id=';
  static const String REMOVE_WISH_LIST_URI =
      '/api/v1/customer/wish-list/remove?product_id=';
  static const String NOTIFICATION_URI = '/api/v1/notifications';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';
  static const String SEARCH_URI = '/api/v1/products/search?name=';
  static const String REVIEW_URI = '/api/v1/products/reviews/submit';
  static const String PRODUCT_DETAILS_URI = '/api/v1/products/details/';
  static const String LAST_LOCATION_URI =
      '/api/v1/delivery-man/last-location?order_id=';
  static const String DELIVER_MAN_REVIEW_URI =
      '/api/v1/delivery-man/reviews/submit';
  static const String PRODUCT_REVIEW_URI = '/api/v1/products/reviews/';
  static const String DISTANCE_MATRIX_URI = '/api/v1/mapapi/distance-api';
  static const String SEARCH_LOCATION_URI =
      '/api/v1/mapapi/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/mapapi/place-api-details';
  static const String GEOCODE_URI = '/api/v1/mapapi/geocode-api';
  static const String EMAIL_SUBSCRIBE_URI = '/api/v1/subscribe-newsletter';
  static const String CUSTOMER_REMOVE = '/api/v1/customer/remove-account';
  static const String POLICY_PAGE = '/api/v1/pages';

  //MESSAGING
  static const String GET_DELIVERYMAN_MESSAGE_URI =
      '/api/v1/customer/message/get-order-message';
  static const String GET_ADMIN_MESSAGE_URL =
      '/api/v1/customer/message/get-admin-message';
  static const String SEND_MESSAGE_TO_ADMIN_URL =
      '/api/v1/customer/message/send-admin-message';
  static const String SEND_MESSAGE_TO_DELIVERY_MAN_URL =
      '/api/v1/customer/message/send/customer';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'market';
  static const String ON_BOARDING_SKIP = 'on_boarding_skip';
  static const String LANG_SKIP = 'lang_skip';
  static const String USER_ID = 'user_id';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.united_kindom,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.arabic,
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
