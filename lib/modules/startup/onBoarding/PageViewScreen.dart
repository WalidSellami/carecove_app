import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:project_final/model/pageViewModel/PageViewModel.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewScreen extends StatefulWidget {

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  List<PageViewModel> pages = [
    PageViewModel(
        image:
            'images/undraw_welcome.svg',
        text: 'Welcome to CareCove! \n'
              'CareCove has great features for you'),
    PageViewModel(
        image:
            'images/undraw_mobile_user.svg',
        text: 'Simple and Easy to use'),
    PageViewModel(
        image:
            'images/undraw_connected.svg',
        text: 'Offers a platform between doctors , pharmacists and patients'),
    PageViewModel(
        image:
        'images/undraw_start.svg',
        text: 'What are you waiting , Get Started!'),
  ];

  PageController controller = PageController();

  bool isLast = false;

  void getStarted(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value == true) {
        navigatorToNotBack(context: context, screen: LoginScreen());
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
              onPress: () {
                getStarted();
              },
              text: 'skip'.toUpperCase()),
          const SizedBox(
            width: 4.0,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (int index) {
                  if(index == pages.length - 1) {
                     setState(() {
                       isLast = true;
                     });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) => buildPageItem(pages[index]),
                itemCount: pages.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 6.0,
                  ),
                  child: SmoothPageIndicator(
                      controller: controller,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey.shade400,
                        activeDotColor: HexColor('0571d5'),
                        dotWidth: 10,
                        spacing: 5.0,
                        expansionFactor: 4.0,
                        dotHeight: 10,
                      ),
                      count: pages.length),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AvatarGlow(
                  glowColor: HexColor('0571d5'),
                  endRadius: 70.0,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: FloatingActionButton(
                    onPressed: () {
                      if(isLast) {
                        getStarted();
                      } else {
                        controller.nextPage(
                            duration: const Duration(
                              milliseconds: 800,
                            ),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
