import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../localization/language_constrants.dart';
import '../../../../../provider/localization_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../data/model/response/language_model.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/language_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../utill/app_constants.dart';
import '../custom_snackbar.dart';
import '../text_hover.dart';

class LanguageHoverWidget extends StatelessWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({Key key, @required this.languageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Container(
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Column(
                children: languageList.map((language) => InkWell(
                  onTap: () async {
                    if(languageProvider.languages.length > 0 && languageProvider.selectIndex != -1) {
                      Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                          language.languageCode, language.countryCode));
                      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
                        context, '1', true, AppConstants.languages[languageProvider.selectIndex].languageCode,);
                      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                          context ,true , AppConstants.languages[languageProvider.selectIndex].languageCode);

                    }else {
                      showCustomSnackBar(getTranslated('select_a_language', context), context);
                    }

                    print("-------------------------->${AppConstants.languages[languageProvider.selectIndex].languageCode}-----------------");
                  },
                  child: TextHover(
                      builder: (isHover) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: Image.asset(language.imageUrl, width: 25, height: 25),
                                  ),
                                  Text(language.languageName, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: Dimensions.FONT_SIZE_SMALL),),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                )).toList(),
            ),
          );
        }
    );
  }
}
