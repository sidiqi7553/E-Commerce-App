import 'package:emarket_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/onboarding_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../utill/images.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);

    return Scaffold(
      backgroundColor: Color(0xffD0556C),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Consumer<OnBoardingProvider>(
          builder: (context, onBoardingList, child) => onBoardingList.onBoardingList.length > 0 ? SafeArea(
            child: Stack(
              children: [

                // onBoardingList.selectedIndex != onBoardingList.onBoardingList.length-1 ? Align(
                //   alignment: Alignment.topRight,
                //   child: TextButton(
                //       onPressed: () {
                //         onBoardingList.toggleShowOnBoardingStatus();
                //         Navigator.pushReplacementNamed(context, Routes.getWelcomeRoute());
                //       },
                //       child: Text(
                //         getTranslated('skip', context),
                //         style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                //       )),
                // ) : SizedBox(),

                SizedBox(
                  height: 500,
                  child: PageView.builder(
                    itemCount: onBoardingList.onBoardingList.length,
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(onBoardingList.onBoardingList[index].imageUrl));
                    },
                    onPageChanged: (index) {
                      onBoardingList.changeSelectIndex(index);
                    },
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 60, right: 60, top: 50, bottom: 22),
                          child: Text(
                            onBoardingList.selectedIndex == 0
                                ? onBoardingList.onBoardingList[0].title
                                : onBoardingList.selectedIndex == 1
                                    ? onBoardingList.onBoardingList[1].title
                                    : onBoardingList.onBoardingList[2].title,
                            style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 30.0, color: Theme.of(context).textTheme.bodyText1.color),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Text(
                            onBoardingList.selectedIndex == 0
                                ? onBoardingList.onBoardingList[0].description
                                : onBoardingList.selectedIndex == 1
                                    ? onBoardingList.onBoardingList[1].description
                                    : onBoardingList.onBoardingList[2].description,
                            style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: ColorResources.getGrayColor(context),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.all(onBoardingList.selectedIndex == 2 ? 0 : 22),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       // onBoardingList.selectedIndex == 0 || onBoardingList.selectedIndex == 2
                        //       //     ? SizedBox.shrink()
                        //       //     : TextButton(
                        //       //         onPressed: () {
                        //       //           _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.ease);
                        //       //         },
                        //       //         child: Text(
                        //       //           getTranslated('previous', context),
                        //       //           style: Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGrayColor(context)),
                        //       //         )),
                        //       onBoardingList.selectedIndex == 2
                        //           ? SizedBox.shrink()
                        //           : TextButton(
                        //               onPressed: () {
                        //                 _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                        //               },
                        //               child: Text(
                        //                 getTranslated('next', context),
                        //                 style: Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGrayColor(context)),
                        //               )),
                        //     ],
                        //   ),
                        // ),
                        // onBoardingList.selectedIndex == 2
                        //     ?
                    Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                child: CustomButton(
                                  btnTxt: getTranslated('lets_start', context),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, Routes.getWelcomeRoute());
                                  },
                                )),
                            // : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _pageIndicators(onBoardingList.onBoardingList, context),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(image: DecorationImage(
                      image: AssetImage(Images.circle,),
                      fit: BoxFit.cover
                    )),
                  ),
                ),
              ],
            ),
          ) : SizedBox(),
        ),
      ),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 20 : 7,
          height: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? Colors.transparent: Theme.of(context).primaryColor ,
            borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
            border:Border.all(color: Theme.of(context).primaryColor)
          ),
        ),
      );
    }
    return _indicators;
  }
}
