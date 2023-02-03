import 'package:flutter/material.dart';

import '../../../../helper/responsive_helper.dart';
import '../../../base/web_header/web_app_bar.dart';
import 'filter_widget.dart';

class FliterScreen extends StatefulWidget {
  const FliterScreen({Key key}) : super(key: key);

  @override
  State<FliterScreen> createState() => _FliterScreenState();
}

class _FliterScreenState extends State<FliterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : null,
      body: Column(
        children: [
          FilterWidget()
        ],
      ),

    );
  }
}
