import 'package:emarket_user/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Images {
  static const String home = 'assets/image/home_icon.png';
  static const String maintenance = 'assets/image/maintenance.png';
  static const String more = 'assets/image/more_icon.png';
  static const String fav = 'assets/image/fav_icon.png';
  static const String cart = 'assets/image/cart_icon.png';
  static const String filter = 'assets/image/filter_icon.png';
  static const String coupon = 'assets/image/coupon.png';
  static const String language = 'assets/image/language.png';
  static const String log_out = 'assets/image/log_out.png';
  static const String message = 'assets/image/message.png';
  static const String order = 'assets/image/order.png';
  static const String payment = 'assets/image/payment.png';
  static const String profile = 'assets/image/profile.png';
  static const String image = 'assets/image/image.png';
  static const String send = 'assets/image/send.png';
  static const String line = 'assets/image/line.png';
  static const String coupon_bg = 'assets/image/coupon_bg.png';
  static const String percentage = 'assets/image/percentage.png';
  static const String binoculars = 'assets/image/binoculars.png';
  static const String notefound = 'assets/image/not_found.png';

  static const String clock = 'assets/image/clock.png';
  static const String shopping_cart = 'assets/image/shopping_cart.png';
  static const String support = 'assets/image/support.png';
  static const String help = 'assets/image/img.jpg';


  static const String delivery_boy_marker = 'assets/image/delivery_boy_marker.png';
  static const String destination_marker = 'assets/image/destination_marker.png';
  static const String restaurant_marker = 'assets/image/restaurant_marker.png';
  static const String unselected_restaurant_marker = 'assets/image/unselected_restaurant_marker.png';
  static const String wallet = 'assets/image/wallet.png';
  static const String account_created = 'assets/image/account_created.png';
  static const String guest_login = 'assets/image/guest_login.png';
  static const String placeholder_light = 'assets/image/placeholder.jpg';
  static const String placeholder_dark = 'assets/image/dark_placeholder.png';
  static String placeholder(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? placeholder_dark : placeholder_light;
  }

  static const String logo = 'assets/image/logo.png';
  static const String splash_logo = 'assets/image/logo_garey.png';
  static const String login = 'assets/icon/login.png';
  static const String help_support = 'assets/icon/help_support.png';
  static const String privacy_policy = 'assets/icon/privacy_policy.png';
  static const String terms_and_condition = 'assets/icon/terms_and_condition.png';
  static const String about_us = 'assets/icon/about_us.png';
  static const String address = 'assets/image/location.png';
  static const String notification_web = 'assets/image/notification.png';
  static const String version = 'assets/icon/version.png';
  static const String update = 'assets/image/update.png';
  static const String login_image = 'assets/image/login_image.png';
  static const String returnPolicy = 'assets/image/return_policy.png';
  static const String cancellationPolicy = 'assets/image/cancellation_policy.png';
  static const String refundPolicy = 'assets/image/refound_policy.png';


  // for Icon
  static const String marker = 'assets/icon/marker.png';
  static const String my_location = 'assets/icon/my_location.png';
  static const String search = 'assets/icon/search.png';
  static const String edit = 'assets/icon/edit.png';
  static const String home_icon = 'assets/icon/home.png';
  static const String menu = 'assets/icon/menu.png';
  static const String workplace = 'assets/icon/workplace.png';
  static const String map = 'assets/icon/map.png';
  static const String notification = 'assets/icon/notification.png';
  static const String close_lock = 'assets/icon/close_lock.png';
  static const String email_with_background = 'assets/icon/email_with_background.png';
  static const String open_lock = 'assets/icon/open_lock.png';
  static const String done_with_full_background = 'assets/icon/done_with_full_background.png';
  static const String filter_icon = 'assets/icon/filter_icon.png';
  static const String location = 'assets/icon/location.png';

  // for Image
  static const String arabic = 'assets/image/arabic.png';
  static const String china = 'assets/image/china.png';
  static const String germany = 'assets/image/germany.png';
  static const String italy = 'assets/image/italy.png';
  static const String japan = 'assets/image/japan.png';
  static const String korea = 'assets/image/korean.png';
  static const String onboarding_one = 'assets/image/screen1.png';
  static const String onboarding_three = 'assets/image/screen3.png';
  static const String onboarding_two = 'assets/image/screen2.png';
  static const String circle = 'assets/image/circle1.png';
  static const String united_kindom = 'assets/image/united_kindom.png';
  static const String done = 'assets/icon/done.png';

  static const String lock = 'assets/image/lock.png';
  static const String close = 'assets/image/clear.png';
  static const String shopping_cart_bold = 'assets/image/cart_bold.png';
  static const String facebook = 'assets/image/facebook.png';
  static const String twitter = 'assets/image/twitter.png';
  static const String youtube = 'assets/image/youtube.png';
  static const String play_store = 'assets/image/play_store.png';
  static const String app_store = 'assets/image/app_store.png';
  static const String linkedin = 'assets/image/linkedin_icon.png';
  static const String  instagram = 'assets/image/instagram_icon.png';
  static const String pinterest = 'assets/image/pinterest.png';
}
