import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  var newPasswordController = TextEditingController();

  var confirmNewPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

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
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {

        if(state is SuccessChangePasswordAppState) {
          if(state.changePasswordModel.status == true) {
            showFlutterToast(message: '${state.changePasswordModel.message}', state: ToastStates.success, context: context);
            Navigator.pop(context);

          }else {

            showFlutterToast(message: '${state.changePasswordModel.message}', state: ToastStates.error, context: context);

          }


        }

      },
      builder: (context , state) {

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Change Password',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        prefix: Icons.lock_outline_rounded,
                        isPassword: isPassword,
                        focusNode: focusNode1,
                        suffix: isPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        onPress: (){
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must not be empty';
                          }else if (value.length < 8) {
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
                        prefix: Icons.lock_outline_rounded,
                        isPassword: isConfirmPassword,
                        focusNode: focusNode2,
                        suffix: isConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        onPress: (){
                          setState(() {
                            isConfirmPassword = !isConfirmPassword;
                          });
                        },
                        validate:(value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must not be empty';
                          }else if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if(value != newPasswordController.text){
                            return 'Enter the same password';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 40.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingChangePasswordAppState,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: defaultButton2(
                            function: () {
                              if(CheckCubit.get(context).hasInternet) {
                                if(formKey.currentState!.validate()){
                                  cubit.changePassword(password: newPasswordController.text);
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                }
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                              } else {

                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }

                            },
                            text: 'Change'.toUpperCase(),
                            context: context),
                      ),
                      fallback: (context) => Center(child: IndicatorScreen(os: getOs())),

                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      },
    );
  }
}
