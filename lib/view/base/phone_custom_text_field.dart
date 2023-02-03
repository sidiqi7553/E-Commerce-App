import 'package:flutter/material.dart';
import 'package:emarket_user/provider/language_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneCustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final String initialValue;
  final String initialCountryCode;
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
  final Function onCountryChanged;
  final Function onSuffixTap;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final bool isSearch;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Function onSubmit;
  final bool isEnabled;
  final bool showDropdownIcon;
  final EdgeInsets flagsButtonMargin;

  final TextCapitalization capitalization;
  final LanguageProvider languageProvider;

  PhoneCustomTextField(
      {this.hintText = 'Write something...',
        this.controller,
        this.initialCountryCode,
        this.flagsButtonMargin,
        this.focusNode,
        this.initialValue,
        this.nextFocus,
        this.labelText,
        this.onCountryChanged,
        this.showDropdownIcon,
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
  _PhoneCustomTextFieldState createState() => _PhoneCustomTextFieldState();
}

class _PhoneCustomTextFieldState extends State<PhoneCustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialValue: widget.initialValue,
      showDropdownIcon:widget.showDropdownIcon,
      flagsButtonMargin:widget.flagsButtonMargin,
      initialCountryCode:widget.initialCountryCode,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      enabled: widget.isEnabled,
      autofocus: false,
      onCountryChanged:widget.onCountryChanged,

      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
      decoration: InputDecoration(
        counter: Text(""),
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
        errorStyle: Theme.of(context).textTheme.headline1.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_RED),

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
