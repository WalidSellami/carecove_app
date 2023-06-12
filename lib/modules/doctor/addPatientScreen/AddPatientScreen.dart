import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  var nameController = TextEditingController();
  var roleController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool isPassword = true;

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    roleController.text = 'Patient';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool showFab =  MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessAddPatientAccountAppState) {
              if (state.addPatientModel.status == true) {
                showFlutterToast(
                    message: '${state.addPatientModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context).getAllPatients();
                Navigator.pop(context);
              } else {
                showFlutterToast(
                    message: '${state.addPatientModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Add Patient',
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultFormField(
                            text: 'Full Name',
                            controller: nameController,
                            type: TextInputType.text,
                            focusNode: focusNode1,
                            prefix: Icons.person,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full Name must not be empty';
                              }
                              if (value.length < 4) {
                                return 'Full Name must be at least 4 characters';
                              }
                              bool validName = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$').hasMatch(value);
                              if(!validName) {
                                return 'Enter a valid name , Don\'t enter only numbers and without (,-)';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                            text: 'Phone',
                            controller: phoneController,
                            type: TextInputType.phone,
                            focusNode: focusNode2,
                            prefix: Icons.person,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              if (value.length < 9 || value.length > 10) {
                                return 'Phone must be 9 or 10 numbers with 0 in the beginning';
                              }

                              String firstLetter = value.substring(0, 1).toUpperCase();
                              if (firstLetter != '0') {
                                return 'Phone must be starting with 0';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                            text: 'Address',
                            controller: addressController,
                            type: TextInputType.streetAddress,
                            focusNode: focusNode3,
                            prefix: Icons.place_outlined,
                            helperText: 'Enter city or district name',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Address must not be empty';
                              }
                              if(value.contains('(') || value.contains(')')) {
                                return 'Don\'t use brackets ()';
                              }
                              bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s]+$').hasMatch(value);
                              if(!nameValid) {
                                return 'Enter a valid address without numbers and without (,.-_)';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                            text: 'Email',
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            focusNode: focusNode4,
                            prefix: Icons.email_outlined,
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
                            focusNode: focusNode5,
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
                            submit: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.addPatientAccount(
                                  name: nameController.text,
                                  role: roleController.text,
                                  phone: phoneController.text,
                                  address: addressController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                );
                              }
                              return null;
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
                          height: 45.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingAddPatientAccountAppState,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: defaultButton2(
                                function: () {
                                  if (checkCubit.hasInternet) {
                                    if (formKey.currentState!.validate()) {
                                      cubit.addPatientAccount(
                                        name: nameController.text,
                                        role: roleController.text,
                                        phone: phoneController.text,
                                        address: addressController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        context: context,
                                      );
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                      focusNode4.unfocus();
                                      focusNode5.unfocus();
                                    }
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    focusNode4.unfocus();
                                    focusNode5.unfocus();
                                  } else {
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    focusNode4.unfocus();
                                    focusNode5.unfocus();
                                    showFlutterToast(
                                        message: 'No Internet Connection',
                                        state: ToastStates.error,
                                        context: context);
                                  }
                                },
                                text: 'Add',
                                context: context),
                          ),
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
