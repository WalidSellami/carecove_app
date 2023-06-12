import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/pageViewModel/PageViewModel.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

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
        'images/undraw_dark_mode.svg',
        text: 'Switch between Light and Dark modes for a personalized experience'),
    PageViewModel(
        image:
        'images/undraw_start.svg',
        text: 'What are you waiting , Get Started!'),
  ];

  PageController controller = PageController();

  bool isLast = false;

  int numberClick = 0;

  void getStarted(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value == true) {
        navigatorToNotBack(context: context, screen: const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return  Scaffold(
          appBar: AppBar(
            actions: [
              defaultTextButton(
                  onPress: () {
                    if(checkCubit.hasInternet) {
                      getStarted();
                    } else {
                      numberClick++;
                      showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                      if(numberClick == 5) {
                        numberClick = 0;
                        Future.delayed(const Duration(milliseconds: 500)).then((value) {
                          showAlertConnection(context);
                        });
                      }
                    }
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
                      endRadius: 75.0,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      child: FloatingActionButton(
                        backgroundColor: HexColor('0571d5'),
                        onPressed: () {
                          if(isLast) {
                            if(checkCubit.hasInternet) {
                              getStarted();
                            } else {
                              numberClick++;
                              showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              if(numberClick == 5) {
                                numberClick = 0;
                                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                                  showAlertConnection(context);
                                });
                              }
                            }
                          } else {
                            numberClick++;
                            controller.nextPage(
                                duration: const Duration(
                                  milliseconds: 850,
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
    );
  }
  dynamic showAlertConnection(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
               'You are currently offline!',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  numberClick = 0;
                },
                child: Text(
                  'Wait',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                 SystemNavigator.pop();
                 numberClick = 0;
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: HexColor('f9325f'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

}
