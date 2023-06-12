import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/modules/admin/searchUserScreen/SearchUserScreen.dart';
import 'package:project_final/modules/admin/userClaimsScreen/UserClaimsScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';

class AdminLayoutScreen extends StatelessWidget {
  const AdminLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return  BlocConsumer<ThemeCubit , ThemeStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var themeCubit = ThemeCubit.get(context);

            return BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {},
              builder: (context , state) {

                var cubit = AppCubit.get(context);

                return WillPopScope(
                  onWillPop: () async {
                    final difference = DateTime.now().difference(timeBackPressed);
                    final isExitWarning = difference >= const Duration(seconds: 1);
                    timeBackPressed = DateTime.now();

                    if(isExitWarning){

                      const message = 'Press back again to exit';
                      showToast(
                        message,
                        context: context,
                        backgroundColor: Colors.grey.shade700,
                        animation: StyledToastAnimation.scale,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.bottom,
                        animDuration: const Duration(milliseconds: 1500),
                        duration: const Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );

                      return false;

                    }else{

                      SystemNavigator.pop();
                      return true;
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: Text(
                        cubit.adminTitles[cubit.currentIndex],
                        style: const TextStyle(
                          fontFamily: 'Varela',
                        ),
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor:
                        themeCubit.isDark ? HexColor('141414') : Colors.white,
                        statusBarIconBrightness: themeCubit.isDark
                            ? Brightness.light
                            : Brightness.dark,
                        systemNavigationBarColor: themeCubit.isDark
                            ? HexColor('191919')
                            : HexColor('e6f5ff'),
                        systemNavigationBarIconBrightness: themeCubit.isDark
                            ? Brightness.light
                            : Brightness.dark,
                      ),
                      actions: [
                        if(cubit.currentIndex == 0)
                          IconButton(
                            onPressed: () {
                              if (checkCubit.hasInternet) {
                                Navigator.of(context)
                                    .push(_createNotificationsRoute());
                              } else {
                                showFlutterToast(
                                    message: 'No Internet Connection',
                                    state: ToastStates.error,
                                    context: context);
                              }
                            },
                            icon: SizedBox(
                              width: 35.0,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      EvaIcons.bellOutline,
                                    ),
                                  ),
                                  (checkCubit.hasInternet)
                                      ? (((cubit.userClaimsModel?.numberClaim ?? 0) > 0)
                                      ? Badge(
                                    backgroundColor: HexColor('f9325f'),
                                    textColor: Colors.white,
                                    label: Center(
                                      child: ((cubit.userClaimsModel?.numberClaim ?? 0) <= 99) ? Text(
                                        '${cubit.userClaimsModel?.numberClaim}',
                                        style: const TextStyle(
                                          fontSize: 9.0,
                                        ),
                                      ) : const Text(
                                        '+99',
                                        style: TextStyle(
                                          fontSize: 9.0,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container())
                                      : Container(),
                                ],
                              ),
                            ),
                            tooltip: 'Claims',
                          ),
                        if(cubit.currentIndex == 0)
                          IconButton(
                              onPressed: () {
                                if(checkCubit.hasInternet) {
                                  Navigator.of(context).push(_createSearchUserRoute());
                                } else {
                                  showFlutterToast(
                                      message: 'No Internet Connection',
                                      state: ToastStates.error,
                                      context: context);
                                }
                              },
                              icon: const Icon(
                                EvaIcons.searchOutline,
                              ),
                          ),
                        if(cubit.currentIndex == 0)
                          const SizedBox(
                          width: 6.0,
                        ),
                      ],
                    ),
                    body: cubit.adminScreens[cubit.currentIndex],
                    bottomNavigationBar:  Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                        color: themeCubit.isDark
                            ? HexColor('191919')
                            : HexColor('e6f5ff'),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: GNav(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          backgroundColor: themeCubit.isDark
                              ? HexColor('191919')
                              : HexColor('e6f5ff'),
                          color: themeCubit.isDark
                              ? Colors.grey.shade200
                              : HexColor('091e28'),
                          activeColor: themeCubit.isDark
                              ? HexColor('21b8c9')
                              : HexColor('091e28'),
                          tabBackgroundColor: themeCubit.isDark
                              ? Colors.grey.shade800.withOpacity(.7)
                              : HexColor('b3d8ff'),
                          gap: 6,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          selectedIndex: cubit.currentIndex,
                          onTabChange: (index) {
                            cubit.changeNav(index);
                          },
                          padding: const EdgeInsets.all(14.0),
                          tabs: cubit.adminItems,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Route _createNotificationsRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const UserClaimsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  Route _createSearchUserRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const SearchUserScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }


}
