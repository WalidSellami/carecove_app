import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/modules/patient/searchDoctorScreen/SearchDoctorScreen.dart';
import 'package:project_final/modules/patient/searchOrderPatientScreen/SearchOrderPatientScreen.dart';
import 'package:project_final/modules/patient/searhCardScreen/SearchCardScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class PatientLayoutScreen extends StatelessWidget {
  const PatientLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ThemeCubit , ThemeStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var themeCubit = ThemeCubit.get(context);

            return BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {
                if(state is SuccessCheckAccountUserAppState) {
                  if((state.simpleModel.status == false) && (state.simpleModel.message == 'User is not registered')) {
                    showAlert(context);
                    deleteAccount(context);
                  }
                }
              },
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

                      return true;
                    }
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: Text(
                        cubit.patientTitles[cubit.currentIndex],
                        style: const TextStyle(
                          fontFamily: 'Varela',
                        ),
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor:  themeCubit.isDark ? HexColor('141414') : Colors.white,
                        statusBarIconBrightness:  themeCubit.isDark ? Brightness.light : Brightness.dark,
                        systemNavigationBarColor: themeCubit.isDark ? HexColor('191919') : HexColor('e6f5ff'),
                        systemNavigationBarIconBrightness: themeCubit.isDark ? Brightness.light : Brightness.dark,
                      ),
                      actions: [
                        if(cubit.currentIndex == 0)
                          ((cubit.cardPatientModel?.cards.length ?? 0) > 0) ? IconButton(
                            onPressed: () {
                              if(checkCubit.hasInternet) {
                                Navigator.of(context).push(_createSearchCardRoute());
                              } else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            icon: const Icon(
                                EvaIcons.searchOutline
                            ),
                            tooltip: 'Search',
                          ) : Container(),
                        if(cubit.currentIndex == 1)
                          ((cubit.doctorsModel?.doctors.length ?? 0) > 2) ? IconButton(
                            onPressed: () {
                              if(checkCubit.hasInternet){
                                Navigator.of(context).push(_createSearchDoctorRoute());
                              }else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            icon: const Icon(
                                EvaIcons.searchOutline
                            ),
                            tooltip: 'Search',
                          ) : Container(),
                        if(cubit.currentIndex == 2)
                          ((cubit.orderModel?.orders.length ?? 0) > 0) ? IconButton(
                            onPressed: () {
                              if(checkCubit.hasInternet) {
                                Navigator.of(context).push(_createSearchOrderRoute());
                              } else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            icon: const Icon(
                                EvaIcons.searchOutline
                            ),
                            tooltip: 'Search',
                          ) : Container(),
                        if((cubit.currentIndex == 0) || (cubit.currentIndex == 1) || (cubit.currentIndex == 2))
                          const SizedBox(
                            width: 6.0,
                          ),
                      ],
                    ),
                    body: cubit.patientScreens[cubit.currentIndex],
                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                        color: themeCubit.isDark ? HexColor('191919') : HexColor('e6f5ff'),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: GNav(
                          backgroundColor:  themeCubit.isDark ? HexColor('191919') : HexColor('e6f5ff'),
                          color:  themeCubit.isDark ?  Colors.grey.shade200 : HexColor('091e28'),
                          activeColor:  themeCubit.isDark ?  HexColor('21b8c9') : HexColor('091e28'),
                          tabBackgroundColor:  themeCubit.isDark ? Colors.grey.shade800.withOpacity(.7) : HexColor('b3d8ff'),
                          gap: 6,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          selectedIndex: cubit.currentIndex,
                          onTabChange: (index){
                            cubit.changeNav(index);
                          },
                          padding: const EdgeInsets.all(14.0),
                          tabs: cubit.patientItems,
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
}

Route _createSearchDoctorRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
           const SearchDoctorScreen(),
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

Route _createSearchCardRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
           const SearchCardScreen(),
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

Route _createSearchOrderRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
           const SearchOrderPatientScreen(),
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

dynamic showAlert(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Your Account is Deleted',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: HexColor('f9325f'),
            ),
          ),
          content: const Text(
            'For more informations check your email a report will be send to you.',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
        );
      });
}

void deleteAccount(context) {
  // if(CheckCubit.get(context).hasInternet) {
    AppCubit.get(context).logOut(idUser: userId);
    CacheHelper.removeData(key: 'token').then((value) {
      if (value == true) {
        CacheHelper.removeData(key: 'userId');
        CacheHelper.removeData(key: 'isDoctor');
        CacheHelper.removeData(key: 'isPharmacist');
        CacheHelper.removeData(key: 'isPatient');
        switch (AppCubit.get(context).profile?.user?.role) {
          case 'Doctor':
            CacheHelper.removeData(key: 'doctorId');
            break;
          case 'Pharmacist':
            CacheHelper.removeData(key: 'pharmacistId');
            CacheHelper.removeData(key: 'pharmacyId');
            AppCubit.get(context).clearOrders();
            AppCubit.get(context).clearStockPharmacy();
            break;
          case 'Patient':
            CacheHelper.removeData(key: 'patientId');
            AppCubit.get(context).clearCardPatientData();
            break;
        }

        Future.delayed(const Duration(milliseconds: 2000)).then((value) {
          Navigator.pop(context);
          navigatorToNotBack(context: context, screen: const LoginScreen());
          AppCubit.get(context).currentIndex = 0;
        });
      }
    });
  // }
}

