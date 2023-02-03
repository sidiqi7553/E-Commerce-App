import 'package:flutter/material.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF6f7275) : Color(0xFFA0A4A8);
  }
  static Color getNewFormFieldBorderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFECEDEE) : Color(0xFFECEDEE);
  }
  static Color getGrayColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF919191) : Color(0xFF6E6E6E);
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF585a5c) : Color(0xFFF4F7FC);
  }
  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF343636) : Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF52575C);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }
  static Color getWhiteAndBlack(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? COLOR_WHITE : COLOR_BLACK;
  }
  static Color getBlackAndWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? COLOR_BLACK : COLOR_WHITE;
  }
  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFa1916c) :Color(0xFFFFDDD9);
  }
  static Color getFooterColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Theme.of(context).cardColor :Color(0xFFF5EFFF);
  }
  static Color footerTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFFFFFFF):Color(0xFF111111);
  }
  static Color menuHeaderBannerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFF111111):Theme.of(context).primaryColor;
  }


  static const Color COLOR_GREY = Color(0xFFA0A4A8);
  static const Color COLOR_NEW_FORM_BORDER = Color(0xFFECEDEE);
  static const Color COLOR_BLACK = Color(0xFF000000);
  static const Color COLOR_NERO = Color(0xFF1F1F1F);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const Color COLOR_HINT = Color(0xFF52575C);
  static const Color SEARCH_BG = Color(0xFFF4F7FC);
  static const Color COLOR_GRAY = Color(0xff6E6E6E);
  static const Color COLOR_OXFORD_BLUE = Color(0xff282F39);
  static const Color COLOR_GAINSBORO = Color(0xffE8E8E8);
  static const Color COLOR_NIGHER_RIDER = Color(0xff303030);
  static const Color BACKGROUND_COLOR = Color(0xffF4F7FC);
  static const Color COLOR_GREY_BUNKER = Color(0xff25282B);
  static const Color COLOR_GREY_CHATEAU = Color(0xffA0A4A8);
  static const Color COLOR_RED = Colors.red;
  static const Color BORDER_COLOR = Color(0xFFDCDCDC);
  static const Color DISABLE_COLOR = Color(0xFF979797);
  static const Color CATEGORY_SHADOW = Color(0xFFA7A7A7);
  static const Color CARD_SHADOW_COLOR = Color(0xFFA7A7A7);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

  static const Color WEB_HEADER_COLOR = Color(0xFF673AB7);
  static const Color RED_COLOR = Color(0xFFFF5C00);
  static const Color SEARCH_BG_COLOR = Color(0xFFE0E0E0);
  static const Color WEB_FOOTER_COLOR = Color(0xFFF5EFFF);
  // static const Color WEB_FOOTER_TEXT_COLOR = Color(0xFF515755);

  static Color getHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF363636).withOpacity(0.6) : Color(0xFFFFFFFF);
  }
  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF).withOpacity(0.6) : Color(0xFF1F1F1F);
  }
  static Color getBlackAndWhiteColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF000000);
  }
  static Color getWhiteAndBlackColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF000000) : Color(0xFFFFFFFF);
  }
  static Color getWebCardColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF363636) : Color(0xFFFFFFFF);
  }

}
