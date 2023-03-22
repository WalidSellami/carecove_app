import 'package:flutter/material.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/modules/startup/onBoarding/PageViewScreen.dart';
import 'package:project_final/modules/startup/splashScreen/SplashScreen.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';
import 'package:project_final/shared/styles/Styles.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  Widget? widget;

  if(onBoarding != null){
   widget = LoginScreen();
  } else {
    widget = PageViewScreen();
  }

  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;
  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: SplashScreen(widgetStart: startWidget!),
    );
  }
}
