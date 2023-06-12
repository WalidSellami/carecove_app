import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/modules/doctor/completeRegisterScreen/DoctorRegisterScreen.dart';
import 'package:project_final/modules/pharmacist/completeRegisterScreen/CheckPharmacyScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/registerCubit/Cubit.dart';
import 'package:project_final/shared/cubit/registerCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  var formKey = GlobalKey<FormState>();

  var num1 = TextEditingController();
  var num2 = TextEditingController();
  var num3 = TextEditingController();
  var num4 = TextEditingController();
  var num5 = TextEditingController();
  var num6 = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();

  int seconds = 59;

  int testNumber = 0;

  Timer? timer;

  bool isLoading = false;

  void startTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {

        if(state is CheckConnectionState) {
          if(CheckCubit.get(context).hasInternet == false) {
            showAlertConnection(context);
          }
        }
      },
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<RegisterCubit , RegisterStates>(
          listener: (context , state) {

            if(state is SuccessDeleteAccountState) {
              if(state.simpleModel.status == true) {
                CacheHelper.removeData(key: 'token').then((value) {
                  if(value == true) {
                    CacheHelper.removeData(key: 'userId');
                    CacheHelper.removeData(key: 'isDoctor');
                    CacheHelper.removeData(key: 'isPharmacist');
                    Navigator.pop(context);
                    navigatorToNotBack(context: context, screen: const LoginScreen());
                  }
                });
              }
            }
          },
          builder: (context , state) {

            return BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {
                if (state is SuccessGetProfileAppState) {
                  if (state.profileModel.status == false) {
                    showFlutterToast(
                        message: 'Error , try again',
                        state: ToastStates.error,
                        context: context);
                  }
                }
              },
              builder: (context, state) {
                var cubit = AppCubit.get(context);
                var userData = cubit.profile;

                void checkCode({required String code}) {
                  String codeAuth = userData?.user?.codeAuth.toString() ?? '';

                  if ((code != codeAuth) && (testNumber < 4)) {

                    showFlutterToast(
                        message: 'Enter the correct code!',
                        state: ToastStates.error,
                        context: context);
                    setState(() {
                      isLoading = false;
                    });
                    testNumber++;

                  }

                  if((code != codeAuth) && (testNumber == 4)) {

                    showFlutterToast(message: 'Last chance for entering correct code', state: ToastStates.error, context: context);
                    setState(() {
                      isLoading = false;
                    });
                    testNumber++;

                  } else if((code != codeAuth) && (testNumber == 5)) {
                    testNumber = 3;
                    setState(() {
                      isLoading = false;
                    });
                    showAlert(context);
                  }



                  if (code == codeAuth && userData?.user?.role == 'Doctor') {
                    setState(() {
                      isLoading = false;
                    });
                    showFlutterToast(
                        message: 'Done with success',
                        state: ToastStates.success,
                        context: context);

                      navigatorToNotBack(
                          context: context, screen: DoctorRegisterScreen());

                  } else if ((code == codeAuth &&
                      userData?.user?.role == 'Pharmacist')) {
                    setState(() {
                      isLoading = false;
                    });
                    showFlutterToast(
                        message: 'Done with success',
                        state: ToastStates.success,
                        context: context);

                      navigatorToNotBack(
                          context: context, screen: const CheckPharmacyScreen());
                  }
                }

                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'Email Verification',
                      style: TextStyle(
                        fontFamily: 'Varela',
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Check Your Email',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            'We sent your code to your email',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              defaultFormVerification(
                                  controller: num1,
                                  focusNode: focusNode1,
                                  onChange: (value) {
                                    if (value?.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                              defaultFormVerification(
                                  controller: num2,
                                  focusNode: focusNode2,
                                  onChange: (value) {
                                    if (value?.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value == null || value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                              defaultFormVerification(
                                  controller: num3,
                                  focusNode: focusNode3,
                                  onChange: (value) {
                                    if (value?.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value == null || value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                              defaultFormVerification(
                                  controller: num4,
                                  focusNode: focusNode4,
                                  onChange: (value) {
                                    if (value?.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value == null || value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                              defaultFormVerification(
                                  controller: num5,
                                  focusNode: focusNode5,
                                  onChange: (value) {
                                    if (value?.length == 1) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value == null || value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                              defaultFormVerification(
                                  controller: num6,
                                  focusNode: focusNode6,
                                  onChange: (value) {
                                    if (value == null || value.isEmpty) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                    return null;
                                  },
                                  submit: (value) {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      String code = num1.text +
                                          num2.text +
                                          num3.text +
                                          num4.text +
                                          num5.text +
                                          num6.text;
                                      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                                        checkCode(code: code);
                                      });
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                      focusNode4.unfocus();
                                      focusNode5.unfocus();
                                      focusNode6.unfocus();
                                    }
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 14.0,
                          ),
                          (checkCubit.hasInternet) ?
                          (seconds == 0)
                              ? ConditionalBuilder(
                            condition: state is! LoadingResendCodeAuthAppState,
                            builder: (context) => TextButton(
                              onPressed: () {
                                cubit.resendCodeAuth(context);
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                focusNode3.unfocus();
                                focusNode4.unfocus();
                                focusNode5.unfocus();
                                focusNode6.unfocus();
                              },
                              child: const Text(
                                'Resend code',
                                style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            fallback: (context) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: IndicatorScreen(os: getOs()),
                            ),
                          )
                              : ((seconds >= 10)
                              ? Text(
                            '00:$seconds',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                              : Text(
                            '00:0$seconds',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          )) : Container(),
                          const SizedBox(
                            height: 45.0,
                          ),
                          (!isLoading) ? defaultButton2(
                              width: 200.0,
                              function: () {
                                if(checkCubit.hasInternet) {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String code = num1.text +
                                        num2.text +
                                        num3.text +
                                        num4.text +
                                        num5.text +
                                        num6.text;
                                    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                                      checkCode(code: code);
                                    });
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    focusNode4.unfocus();
                                    focusNode5.unfocus();
                                    focusNode6.unfocus();
                                  }
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                  focusNode4.unfocus();
                                  focusNode5.unfocus();
                                  focusNode6.unfocus();
                                } else {
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                  focusNode4.unfocus();
                                  focusNode5.unfocus();
                                  focusNode6.unfocus();
                                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                  Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                                    showAlertConnection(context);
                                  });
                                }
                              },
                              text: 'Verify',
                              context: context) : IndicatorScreen(os: getOs()),
                        ],
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



  dynamic showAlert(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Column(
                    children: [
                      Text(
                        'Your chances is finished!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          color: HexColor('f9325f'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'You seem trying to register with a fake email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showLoading(context);
                  RegisterCubit.get(context).deleteAccount(idUser: userId);
                  testNumber = 0;
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

  dynamic showAlertConnection(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text.rich(
                    TextSpan(
                        text: 'You are currently offline! \n\n',
                        style: const TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text:
                              'Note : your registration is not complete, you should try later from beginning.',
                              style: TextStyle(
                                fontSize: 17.0,
                                height: 1.4,
                                color: HexColor('f9325f'),
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                 Navigator.pop(context);
                },
                child: Text(
                  'Wait',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: HexColor('f9325f'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showLoading(context);
                  RegisterCubit.get(context).deleteAccount(idUser: userId);
                },
                child: Text(
                  'Ok',
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

  dynamic showLoading(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                padding: const EdgeInsets.all(26.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: ThemeCubit.get(context).isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
                child: IndicatorScreen(os: getOs())),
          );
        });
  }


}
