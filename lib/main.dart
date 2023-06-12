import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:project_final/layout/appLayouts/AdminLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/DoctorLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/PatientLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/PharmacistLayoutScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/modules/startup/onBoarding/PageViewScreen.dart';
import 'package:project_final/modules/startup/splashScreen/SplashScreen.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/registerCubit/Cubit.dart';
import 'package:project_final/shared/cubit/resetPassCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';
import 'package:project_final/shared/network/remot/DioHelper.dart';
import 'package:project_final/shared/notification/Notifications.dart';
import 'package:project_final/shared/styles/Styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  await Notifications().initialization();

  // var response = await DioHelper.getData(url: '/api/test');
  // print(response?.data);

  bool? isDark = CacheHelper.getData(key: 'isDark');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  token = CacheHelper.getData(key: 'token');
  userId = CacheHelper.getData(key: 'userId');

  bool? isAdmin = CacheHelper.getData(key: 'isAdmin');
  bool? isDoctor = CacheHelper.getData(key: 'isDoctor');
  bool? isPharmacist = CacheHelper.getData(key: 'isPharmacist');
  bool? isPatient = CacheHelper.getData(key: 'isPatient');

  doctorId = CacheHelper.getData(key: 'doctorId');
  pharmacistId = CacheHelper.getData(key: 'pharmacistId');
  pharmacyId = CacheHelper.getData(key: 'pharmacyId');
  patientId = CacheHelper.getData(key: 'patientId');


  // print(patientId);

  // CacheHelper.removeData(key: 'doctorId');
  // CacheHelper.removeData(key: 'userId');
  // CacheHelper.removeData(key: 'token');
  // CacheHelper.removeData(key: 'PharmacyId');
  // CacheHelper.removeData(key: 'patientId');
  // CacheHelper.removeData(key: 'isDoctor');
  // CacheHelper.removeData(key: 'isPharmacist');
  // CacheHelper.removeData(key: 'isPatient');

  // print(token);
  // print(userId);
  // print(pharmacyId);
  // print(isPharmacist);
  // print(isDoctor);
  // print(doctorId);
  // print(pharmacistId);

  Widget? widget;

  if(onBoarding != null){
    if(token != null){
      if(isAdmin != null){
        widget = const AdminLayoutScreen();
      } else if(isDoctor != null){
         widget = const DoctorLayoutScreen();
       } else if(isPharmacist != null){
         widget = const PharmacistLayoutScreen();
       } else if(isPatient != null){
         widget = const PatientLayoutScreen();
       }
    } else {
      widget = const LoginScreen();
    }

  } else {
    widget = const PageViewScreen();
  }


  runApp(MyApp(startWidget: widget, isDark: isDark,));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;
  final bool? isDark;
  const MyApp({super.key, this.startWidget , this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => CheckCubit()..checkConnection()),
        BlocProvider(create: (BuildContext context) => RegisterCubit()),
        BlocProvider(create: (BuildContext context) => ResetPassCubit()),
        BlocProvider(create: (BuildContext context) => AppCubit()..sendNotification(context),),
        BlocProvider(create: (BuildContext context) => ThemeCubit()..changeThemeMode(isDark ?? false)),
      ],
      child: BlocConsumer<ThemeCubit , ThemeStates>(
        listener: (context , state) {},
        builder: (context , state) {

          return OverlaySupport.global(
            child: MaterialApp(
              title: 'Flutter App',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
              home: SplashScreen(widgetStart: startWidget!),
            ),
          );
        },
      ),
    );
  }
}
