import 'package:flutter/material.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';


class SplashScreen extends StatefulWidget {
  final Widget widgetStart;
  const SplashScreen({super.key, required this.widgetStart});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isVisible = false;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 750)).then((value) {
      setState(() {
        isVisible = true;
      });
    });
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      navigatorToNotBack(context: context, screen: widget.widgetStart);
      CheckCubit.get(context).changeStatusScreen();
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
      body: Center(
        child: Visibility(
          visible: isVisible,
          child: FadeTransition(
            opacity: animation,
            child: Image.asset(
              'images/stethoscope.png',
              width: 170.0,
              height: 170.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
