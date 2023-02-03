import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/mars_menu_bar.dart';
import 'package:provider/provider.dart';

class MenuBar extends StatelessWidget {

  List<MenuItems> getMenus(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      MenuItems(
        title: getTranslated('home', context),
        icon: Icons.home_filled,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
      ),
      MenuItems(
        title: getTranslated('offer', context),
        icon: Icons.local_offer_outlined,
        onTap: () => Navigator.pushNamed(context, Routes.getOfferRoute()),
      ),
      MenuItems(
        title: getTranslated('necessary_links', context),
        icon: Icons.settings,
        children: [
          MenuItems(
            title: getTranslated('privacy_policy', context),
            onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
          ),
          MenuItems(
            title: getTranslated('terms_and_condition', context),
            onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
          ),
          MenuItems(
            title: getTranslated('about_us', context),
            onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
          ),

        ],
      ),
      MenuItems(
        title: getTranslated('favourite', context),
        icon: Icons.favorite_border,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
      ),

      MenuItems(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
      ),

      _isLoggedIn ?  MenuItems(
        title: getTranslated('profile', context),
        icon: Icons.person,
        onTap: () =>  Navigator.pushNamed(context, Routes.getProfileRoute()),
      ):  MenuItems(
        title: getTranslated('login', context),
        icon: Icons.lock,
        onTap: () => Navigator.pushNamed(context, Routes.getLoginRoute()),
      ),
      MenuItems(
        title: '',
        icon: Icons.shopping_cart,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      //color: Colors.white,
    width: 700,
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).cardColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        moreIconColor: Theme.of(context).textTheme.bodyText1.color,
        menuIconColor: Theme.of(context).textTheme.bodyText1.color,
        menus: getMenus(context),

      ),
    );
  }
}