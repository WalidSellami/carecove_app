import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/resetPassCubit/Cubit.dart';
import 'package:project_final/shared/cubit/resetPassCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  var codeController = TextEditingController();

  var newPasswordController = TextEditingController();

  var confirmNewPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  bool isPassword = true;
  bool isConfirmPassword = true;

  @override
  void initState() {
    newPasswordController.addListener(() {
      setState(() {});
    });
    confirmNewPasswordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ResetPassCubit, ResetPassStates>(
          listener: (context, state) {
            if (state is SuccessResetPasswordState) {
              if (state.resetModel.status == true) {
                showFlutterToast(
                    message: '${state.resetModel.message}',
                    state: ToastStates.success,
                    context: context);
                navigatorToNotBack(
                    context: context, screen: const LoginScreen());
              } else {
                showFlutterToast(
                    message: '${state.resetModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }
          },
          builder: (context, state) {
            var cubit = ResetPassCubit.get(context);

            var codeAuth = cubit.checkModel?.codeAuth.toString();

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 14.0,
                        ),
                        const Text(
                          'Check your email and enter your code :',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        defaultFormField(
                            text: 'Code',
                            controller: codeController,
                            focusNode: focusNode1,
                            type: TextInputType.number,
                            prefix: Icons.numbers_outlined,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Code must not be empty';
                              }
                              if (value != codeAuth) {
                                return 'Enter the correct code';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text(
                          'Enter your new password :',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        defaultFormField(
                            text: 'Password',
                            controller: newPasswordController,
                            type: TextInputType.visiblePassword,
                            focusNode: focusNode2,
                            prefix: Icons.lock_outline_rounded,
                            isPassword: isPassword,
                            suffix: isPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            onPress: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password must not be empty';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              bool passwordValid = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~,.]).{8,}$')
                                  .hasMatch(value);
                              if (!passwordValid) {
                                return 'Enter a strong password with a mix of uppercase letters, lowercase letters, numbers, special characters(@#%&!?), and at least 8 characters';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text(
                          'Confirm your new password :',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        defaultFormField(
                            text: 'Confirm Password',
                            controller: confirmNewPasswordController,
                            type: TextInputType.visiblePassword,
                            focusNode: focusNode3,
                            prefix: Icons.lock_outline_rounded,
                            isPassword: isConfirmPassword,
                            suffix: isConfirmPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            onPress: () {
                              setState(() {
                                isConfirmPassword = !isConfirmPassword;
                              });
                            },
                            submit: (value) {
                              if (checkCubit.hasInternet) {
                                if (formKey.currentState!.validate()) {
                                  if (codeController.text != codeAuth) {
                                    showFlutterToast(
                                        message:
                                            'Your code is wrong!, enter the correct code.',
                                        state: ToastStates.error,
                                        context: context);
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                  } else {
                                    cubit.resetPassword(
                                        password: newPasswordController.text);
                                  }
                                }
                              } else {
                                showFlutterToast(
                                    message: 'No Internet Connection',
                                    state: ToastStates.error,
                                    context: context);
                              }
                              return null;
                            },
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password must not be empty';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (value != newPasswordController.text) {
                                return 'Enter the same password';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 40.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingResetPasswordState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (checkCubit.hasInternet) {
                                  if (formKey.currentState!.validate()) {
                                    if (codeController.text != codeAuth) {
                                      showFlutterToast(
                                          message:
                                              'Your code is wrong!, enter the correct code.',
                                          state: ToastStates.error,
                                          context: context);
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                    } else {
                                      cubit.resetPassword(
                                          password: newPasswordController.text);
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                    }
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                  }
                                } else {
                                  showFlutterToast(
                                      message: 'No Internet Connection',
                                      state: ToastStates.error,
                                      context: context);
                                }
                              },
                              text: 'Reset'.toUpperCase(),
                              context: context),
                          fallback: (context) =>
                              Center(child: IndicatorScreen(os: getOs())),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
