import 'package:flutter/material.dart';
import 'package:emarket_user/provider/language_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:flutter/services.dart';

class NewCustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function onTap;
  final Function onChanged;
  final Function onSuffixTap;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final bool isSearch;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Function onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final LanguageProvider languageProvider;

  NewCustomTextField(
      {this.hintText = 'Write something...',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.labelText,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onSuffixTap,
        this.fillColor,
        this.onSubmit,
        this.onChanged,
        this.floatingLabelBehavior,
        this.capitalization = TextCapitalization.none,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixIcon,
        this.prefixIcon,
        this.isSearch = false,
        this.languageProvider});

  @override
  _NewCustomTextFieldState createState() => _NewCustomTextFieldState();
}

class _NewCustomTextFieldState extends State<NewCustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
      decoration: InputDecoration(
        floatingLabelBehavior: widget.floatingLabelBehavior,

        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(style: BorderStyle.solid,color: ColorResources.COLOR_NEW_FORM_BORDER, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(style: BorderStyle.solid,color: ColorResources.COLOR_NEW_FORM_BORDER, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(style: BorderStyle.solid,color: ColorResources.COLOR_NEW_FORM_BORDER, width: 1),
        ),
        isDense: true,
        hintText: widget.hintText,
        labelText: widget.labelText,

        fillColor: widget.fillColor != null ? widget.fillColor : Theme.of(context).cardColor,
        hintStyle: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_GREY_CHATEAU),
        labelStyle: Theme.of(context).textTheme.headline1.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_GREY_CHATEAU),
        filled: true,

        prefixIcon: widget.isShowPrefixIcon ? Padding(
          padding: const EdgeInsets.all(0),
          child:widget.prefixIcon,
        ) : null,
        prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
            onPressed: _toggle)
            : widget.isIcon
            ? widget.prefixIcon
            : null
            : null,
      ),
      onTap: widget.onTap,
      onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null ? widget.onSubmit(text) : null,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
