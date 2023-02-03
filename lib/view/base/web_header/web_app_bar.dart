
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/category_model.dart';
import '../../../data/model/response/language_model.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/language_provider.dart';
import '../../../provider/localization_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/search_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/app_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/routes.dart';
import '../../../utill/styles.dart';
import '../../screens/menu/widget/sign_out_confirmation_dialog.dart';
import '../../screens/search/search_result_screen.dart';
import '../custom_text_field.dart';
import '../text_hover.dart';
import 'category_hover_widget.dart';
import 'language_hover_widget.dart';

class WebAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  State<WebAppBar> createState() => _WebAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarState extends State<WebAppBar> {
  String chooseLanguage;


  List<PopupMenuEntry<Object>> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];
    List<CategoryModel> _categoryList =  Provider.of<CategoryProvider>(context, listen: false).categoryList;
    list.add(
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 5),
          value: _categoryList,
          child: MouseRegion(
            onExit: (_)=> Navigator.of(context).pop(),
            child: CategoryHoverWidget(categoryList: _categoryList),
          ),
        ));
    return list;
  }

  List<PopupMenuEntry<Object>> popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry<Object>> _languagePopupMenuEntryList = <PopupMenuEntry<Object>>[];
    List<LanguageModel> _languageList =  AppConstants.languages;
    _languagePopupMenuEntryList.add(
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: _languageList,
          child: MouseRegion(
            onExit: (_)=> Navigator.of(context).pop(),
            child: LanguageHoverWidget(languageList: _languageList),
          ),
        ));
    return _languagePopupMenuEntryList;
  }

  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderBox overlay = Overlay
        .of(context)
        .context
        .findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          left, top, overlay.size.width, overlay.size.height),
      items: isCategory ? popUpMenuList(context) : popUpLanguageList(context),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),

    );
  }

  @override
  void initState() {

    // _loadData(context, true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);
    LanguageModel _currentLanguage = AppConstants.languages.firstWhere((language) => language.languageCode == Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorResources.COLOR_BLACK.withOpacity(0.10),
              blurRadius: 20,
              offset: Offset(0,10),
            )
          ]
      ),
      child: Column(
        children: [
          Container(
            color: ColorResources.WEB_HEADER_COLOR,
            height: 45,
            child: Center(
              child: SizedBox( width: Dimensions.WEB_SCREEN_WIDTH,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text(getTranslated('dark_mode',context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.PADDING_SIZE_DEFAULT)),
                      ),
                      // StatusWidget(),
                      Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                          value: Provider.of<ThemeProvider>(context).darkTheme,
                          activeColor: Colors.black26,
                          activeTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: ColorResources.BORDER_COLOR,

                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      SizedBox(
                        height: Dimensions.PADDING_SIZE_LARGE,

                        child: MouseRegion(
                          onHover: (details){
                            _showPopupMenu(details.position, context, false);
                          },
                          child: InkWell(
                            // onTap: () => showAnimatedDialog(context, CurrencyDialog()),
                            // onTap: () => Navigator.pushNamed(context, RouteHelper.getLanguageRoute('menu')),
                            child: Row(
                              children: [
                                Image.asset(_currentLanguage.imageUrl, height: Dimensions.PADDING_SIZE_LARGE, width: Dimensions.PADDING_SIZE_LARGE),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text('${_currentLanguage.languageName}',style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Icon(Icons.expand_more, color: ColorResources.COLOR_WHITE)
                              ],
                            ),
                          ),
                        ),
                      ),


                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),


                      _isLoggedIn ? InkWell(
                        onTap: () => showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog()),
                        child: Row(children: [

                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            // child: Image.asset(Images.lock,height: 16,fit: BoxFit.contain, color: Theme.of(context).primaryColor),
                            child: Icon(Icons.lock,size: 16, color: Theme.of(context).cardColor),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(getTranslated('log_out', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.COLOR_WHITE)),
                          )
                        ],),
                      )
                          : InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.getLoginRoute());

                        },
                        child:  Row(children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            // child: Image.asset(Images.lock,height: 16,fit: BoxFit.contain, color: Theme.of(context).primaryColor),
                            child: Icon(Icons.lock,size: 16, color: Theme.of(context).cardColor),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(getTranslated('login', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.COLOR_WHITE)),
                          ),
                        ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: ColorResources.getHeaderColor(context),
              child: Center(
                child: SizedBox(
                    width: Dimensions.WEB_SCREEN_WIDTH,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          InkWell(
                            onTap: () {
                              Provider.of<ProductProvider>(context, listen: false).offset = 1;
                              Navigator.pushNamed(context, Routes.getMainRoute());
                            },
                            child: Row(
                              children: [
                                SizedBox(height: 50,
                                    child: Consumer<SplashProvider>(
                                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                                        placeholder: Images.logo,
                                        image: splash.baseUrls != null ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}' : '',fit: BoxFit.contain,
                                        imageErrorBuilder: (c,b,v)=> Image.asset(Images.logo),
                                      ),
                                    ) ),
                                 SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                //Text(AppConstants.APP_NAME,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700,fontSize: 28),)
                              ],
                            ),
                          ),
                          const SizedBox(width: 50),

                          TextHover(
                              builder: (isHovered) {
                                return InkWell(
                                    onTap: (){
                                    Provider.of<ProductProvider>(context, listen: false).offset = 1;
                                    Navigator.pushNamed(context, Routes.getDashboardRoute('home'));
                                      },
                                    child: Text(getTranslated('home', context), style: isHovered ? rubikRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE)
                                        : rubikRegular.copyWith(color: ColorResources.getBlackAndWhiteColor(context),fontSize: Dimensions.FONT_SIZE_LARGE)));
                              }
                          ),
                          const SizedBox(width: 25),
                          TextHover(
                              builder: (isHovered) {
                                return MouseRegion(
                                    onHover: (details){
                                      if(Provider.of<CategoryProvider>(context, listen: false).categoryList != null)
                                        _showPopupMenu(details.position, context,true);
                                    },
                                    child: Text(getTranslated('categories', context), style: isHovered ? rubikRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE)
                                        : rubikRegular.copyWith(color: ColorResources.getBlackAndWhiteColor(context),fontSize: Dimensions.FONT_SIZE_LARGE)

                                    ));

                              }
                          ),
                          const SizedBox(width: 25),
                          TextHover(
                              builder: (isHovered) {
                                return InkWell(
                                    onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
                                    child: Text(getTranslated('favourite', context), style: isHovered ? rubikRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE)
                                        : rubikRegular.copyWith(color: ColorResources.getBlackAndWhiteColor(context),fontSize: Dimensions.FONT_SIZE_LARGE)));
                              }
                          ),
                        ],),

                        Row(children: [
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                              color: ColorResources.SEARCH_BG_COLOR,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_DEFAULT),
                            ),
                            child: Consumer<SearchProvider>(
                                builder: (context,search,_) {

                                  return CustomTextField(
                                    hintText: getTranslated('search_items_here', context),
                                    isShowBorder: false,
                                    fillColor: Colors.transparent,
                                    isShowSuffixIcon: true,
                                    suffixIconUrl: search.searchController.text.length > 0 ? Images.close : Images.search,
                                    onChanged: (str){
                                      str.length = 0;
                                      search.getSearchText(str);
                                      print('===>${search.searchController.text.toString()}');

                                    },

                                    onSuffixTap: () {
                                      if(search.searchController.text.length > 0 && search.isSearch == true){
                                        Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                                        Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                                        Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text),
                                            arguments: SearchResultScreen(searchString: search.searchController.text));

                                        search.searchDone();

                                      }
                                      else if (search.searchController.text.length > 0 && search.isSearch == false) {
                                        search.searchController.clear();
                                        search.getSearchText('');

                                        search.searchDone();
                                      }
                                    },
                                    controller: search.searchController,
                                    inputAction: TextInputAction.search,
                                    isIcon: true,
                                    onSubmit: (text) {
                                      if (search.searchController.text.length > 0) {
                                        Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                                        Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                                        Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text),
                                            arguments: SearchResultScreen(searchString: search.searchController.text));

                                        search.searchDone();
                                      }

                                    },);

                                }
                            ),

                          ),

                          const SizedBox(width: 50),

                          InkWell(
                            onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                            child: SizedBox(
                              child: Stack(
                                clipBehavior: Clip.none, children: [
                                SizedBox(
                                    height: 30,width: 30,
                                    child: Image.asset(Images.shopping_cart_bold,color: ColorResources.getBlackAndWhiteColor(context))
                                ),
                                Positioned(
                                    top: -10,
                                    right: -10,
                                    child: int.parse(Provider.of<CartProvider>(context).cartList.length.toString()) <=0 ? SizedBox() : Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorResources.RED_COLOR,
                                      ),
                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Text('${Provider.of<CartProvider>(context).cartList.length}',style: rubikRegular.copyWith(color: Colors.white,fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    )),
                              ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),

                          IconButton(
                              onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
                              icon: Icon(Icons.menu,size: Dimensions.FONT_SIZE_OVER_LARGE, color: ColorResources.getBlackAndWhiteColor(context))),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL)
                        ],)

                      ],
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size get preferredSize => Size(double.maxFinite, 160);
}

