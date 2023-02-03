import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/view/base/footer_web_view.dart';
import 'package:flutter/material.dart';

import 'web_header/web_app_bar.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) :null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
              child: Center(
                  child: TweenAnimationBuilder(
                    curve: Curves.bounceOut,
                duration: Duration(seconds: 2),
                tween: Tween<double>(begin: 12.0,end: 30.0),
                builder: (BuildContext context, dynamic value, Widget child){
                      return Text('Page Not Found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: value));
                },

                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ),
    );
  }
}
