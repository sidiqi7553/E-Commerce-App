import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/on_hover.dart';
import 'package:flutter/material.dart';
class AddButtonView extends StatelessWidget {
  final Function onTap;
  const AddButtonView({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: OnHover(
        child: InkWell(
          onTap: onTap,
          hoverColor: Colors.transparent,
          child: Container(
            width: 110.0,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(
              children: [
                Icon(Icons.add_circle, color: ColorResources.COLOR_WHITE),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(getTranslated('add_new', context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE))
              ],
            ),
          ),
        ),
      ),
    );
  }
}