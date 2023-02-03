import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_provider.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  CustomAppBar2({@required this.title,  this.isBackButtonExist = true, this.onBackPressed, });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Center(
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(
              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
              spreadRadius: 1, blurRadius: 5,
            )],
          ),

          width: 1170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                  child: Provider.of<SplashProvider>(context).baseUrls != null?  Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(placeholder: Images.placeholder(context), image:  '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}',width: 120, height: 80)): SizedBox(),
                ),
              ),
              MenuBar(),
            ],
          )
      ),
    ) : AppBar(
      title: Text(title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,

    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
