import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/layout/appLayouts/AdminLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/DoctorLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/PatientLayoutScreen.dart';
import 'package:project_final/layout/appLayouts/PharmacistLayoutScreen.dart';
import 'package:project_final/modules/startup/registerScreen/RegisterScreen.dart';
import 'package:project_final/modules/startup/resetPassword/checkEmailScreen/CheckEmailScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/loginCubit/Cubit.dart';
import 'package:project_final/shared/cubit/loginCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPassword = true;

  late AnimationController animationController;
  late Animation<double> animation;

  int numberClick = 0;

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocProvider(
          create: (BuildContext context) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {
              if (state is SuccessLoginState) {
                if (state.loginModel.status == true) {
                  CacheHelper.saveData(
                          key: 'token', value: state.loginModel.token)
                      .then((value) {
                    token = state.loginModel.token;

                    CacheHelper.saveData(
                            key: 'userId',
                            value: (state.loginModel.user?.userId)!.toInt())
                        .then((value) {
                      userId = state.loginModel.user?.userId;
                    });

                    switch (state.loginModel.user?.role) {
                      case 'Doctor':
                        showFlutterToast(
                            message: '${state.loginModel.message}',
                            state: ToastStates.success,
                            context: context);
                        CacheHelper.saveData(key: 'isDoctor', value: true)
                            .then((value) {
                          if (value == true) {
                            navigatorToNotBack(
                                context: context,
                                screen: const DoctorLayoutScreen());
                            AppCubit.get(context).getProfile();
                          }
                        });
                        break;

                      case 'Pharmacist':
                        showFlutterToast(
                            message: '${state.loginModel.message}',
                            state: ToastStates.success,
                            context: context);
                        CacheHelper.saveData(key: 'isPharmacist', value: true)
                            .then((value) {
                          if (value == true) {
                            navigatorToNotBack(
                                context: context,
                                screen: const PharmacistLayoutScreen());
                            AppCubit.get(context).getProfile();
                          }
                        });
                        break;

                      case 'Patient':
                        showFlutterToast(
                            message: '${state.loginModel.message}',
                            state: ToastStates.success,
                            context: context);
                        CacheHelper.saveData(key: 'isPatient', value: true)
                            .then((value) {
                          if (value == true) {
                            navigatorToNotBack(
                                context: context,
                                screen: const PatientLayoutScreen());
                            AppCubit.get(context).getProfile();
                            AppCubit.get(context).getProfilePatient();
                          }
                        });
                        break;

                      case 'Admin':
                        showFlutterToast(
                            message: '${state.loginModel.message}',
                            state: ToastStates.success,
                            context: context);
                        CacheHelper.saveData(key: 'isAdmin', value: true)
                            .then((value) {
                          if (value == true) {
                            navigatorToNotBack(
                                context: context,
                                screen: const AdminLayoutScreen());
                            AppCubit.get(context).getProfile();
                          }
                        });
                        break;
                        default:
                        showFlutterToast(
                            message: 'Error , You are not user in this app',
                            state: ToastStates.error,
                            context: context);
                    }
                  });
                } else {
                  showFlutterToast(
                      message: '${state.loginModel.message}',
                      state: ToastStates.error,
                      context: context);
                }
              }
            },
            builder: (context, state) {
              var cubit = LoginCubit.get(context);

              return WillPopScope(
                onWillPop: () async {
                  return showAlert(context);
                },
                child: Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Form(
                          key: formKey,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CareCove',
                                  style: TextStyle(
                                    fontSize: 44.0,
                                    fontFamily: 'Handle',
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Login now to continue',
                                      style: TextStyle(
                                        fontSize: 19.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    defaultFormField(
                                        text: 'Email',
                                        controller: emailController,
                                        type: TextInputType.emailAddress,
                                        prefix: Icons.email_outlined,
                                        focusNode: focusNode1,
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email must not be empty';
                                          }
                                          bool emailValid = RegExp(
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                              .hasMatch(value);
                                          if (!emailValid) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 25.0,
                                    ),
                                    defaultFormField(
                                        text: 'Password',
                                        controller: passwordController,
                                        type: TextInputType.visiblePassword,
                                        prefix: Icons.lock_outline_rounded,
                                        focusNode: focusNode2,
                                        isPassword: isPassword,
                                        suffix: isPassword
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        onPress: () {
                                          setState(() {
                                            isPassword = !isPassword;
                                          });
                                        },
                                        submit: (value) {
                                          if (checkCubit.hasInternet) {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.userLogin(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text);
                                            }
                                            return null;
                                          } else {
                                            numberClick++;
                                            showFlutterToast(
                                                message: 'No Internet Connection',
                                                state: ToastStates.error,
                                                context: context);

                                            if (numberClick == 5) {
                                              numberClick = 0;
                                              Future.delayed(const Duration(
                                                      milliseconds: 500))
                                                  .then((value) {
                                                showAlertConnection(context);
                                              });
                                            }
                                          }
                                          return null;
                                        },
                                        validate: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password must not be empty';
                                          } else if (value.length < 8) {
                                            return 'Password must be at least 8 characters';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          if (checkCubit.hasInternet) {
                                            Navigator.of(context)
                                                .push(_createResetPassRoute());
                                          } else {
                                            numberClick++;
                                            showFlutterToast(
                                                message: 'No Internet Connection',
                                                state: ToastStates.error,
                                                context: context);
                                            if (numberClick == 5) {
                                              numberClick = 0;
                                              Future.delayed(const Duration(
                                                      milliseconds: 500))
                                                  .then((value) {
                                                showAlertConnection(context);
                                              });
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Forgot your password?',
                                          style: TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25.0,
                                    ),
                                    ConditionalBuilder(
                                      condition: state is! LoadingLoginState,
                                      builder: (context) => defaultButton(
                                          function: () {
                                            if (checkCubit.hasInternet) {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                cubit.userLogin(
                                                    email: emailController.text,
                                                    password:
                                                        passwordController.text);
                                                focusNode1.unfocus();
                                                focusNode2.unfocus();
                                              }
                                              focusNode1.unfocus();
                                              focusNode2.unfocus();
                                            } else {
                                              focusNode1.unfocus();
                                              focusNode2.unfocus();
                                              numberClick++;
                                              showFlutterToast(
                                                  message:
                                                      'No Internet Connection',
                                                  state: ToastStates.error,
                                                  context: context);
                                              if (numberClick == 5) {
                                                numberClick = 0;
                                                Future.delayed(const Duration(
                                                        milliseconds: 500))
                                                    .then((value) {
                                                  showAlertConnection(context);
                                                });
                                              }
                                            }
                                          },
                                          text: 'login'.toUpperCase(),
                                          context: context),
                                      fallback: (context) => Center(
                                          child: IndicatorScreen(os: getOs())),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        const Text(
                                          'Don\'t have an account?',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        defaultTextButton(
                                            onPress: () {
                                              if (checkCubit.hasInternet) {
                                                Navigator.of(context)
                                                    .push(_createRegisterRoute());
                                              } else {
                                                numberClick++;
                                                showFlutterToast(
                                                    message:
                                                        'No Internet Connection',
                                                    state: ToastStates.error,
                                                    context: context);

                                                if (numberClick == 5) {
                                                  numberClick = 0;
                                                  Future.delayed(const Duration(
                                                          milliseconds: 500))
                                                      .then((value) {
                                                    showAlertConnection(context);
                                                  });
                                                }
                                              }
                                            },
                                            text: 'register'.toUpperCase()),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
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

  dynamic showAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              'Are you sure to exit ?',
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
                  'No',
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
                  'Yes',
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

Route _createRegisterRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterScreen(),
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

Route _createResetPassRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CheckEmailScreen(),
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
