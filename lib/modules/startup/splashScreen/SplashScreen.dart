import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/modules/startup/onBoarding/PageViewScreen.dart';
import 'package:project_final/shared/component/Component.dart';

class SplashScreen extends StatefulWidget {

  final Widget widgetStart;
  SplashScreen({required this.widgetStart});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this , duration: const Duration(milliseconds: 500));
    animationController.forward();
    Future.delayed(const Duration(seconds: 3)).then((value) {
       navigatorToNotBack(context: context, screen: widget.widgetStart);
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context , widget) => Transform.scale(
                  scale: animationController.value,
                  child: Opacity(
                    opacity: animationController.value,
                    child: Image.asset('images/stethoscope.png',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SpinKitRing(
            color: HexColor('0571d5'),
            size: 30.0,
            lineWidth: 3.0,
          ),
          const SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
