import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/modules/pharmacist/completeRegisterScreen/PharmacistRegisterScreen.dart';
import 'package:project_final/modules/pharmacist/completeRegisterScreen/PharmacistRegisterSimpleScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/registerCubit/Cubit.dart';
import 'package:project_final/shared/cubit/registerCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class CheckPharmacyScreen extends StatefulWidget {
  const CheckPharmacyScreen({super.key});

  @override
  State<CheckPharmacyScreen> createState() => _CheckPharmacyScreenState();
}

class _CheckPharmacyScreenState extends State<CheckPharmacyScreen> {
  var pharmacyController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  bool isVisible = false;

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

            if(state is SuccessCheckExistPharmacy) {
              if(state.pharmacyModel.status == true) {

                showFlutterToast(message: '${state.pharmacyModel.message}', state: ToastStates.success ,  context: context);
                CacheHelper.saveData(key: 'PharmacyId', value: state.pharmacyModel.pharmacy?.pharmacyId).then((value) {

                  pharmacyId = state.pharmacyModel.pharmacy?.pharmacyId;
                  navigatorToNotBack(context: context, screen: const PharmacistRegisterSimpleScreen());
                  AppCubit.get(context).getPharmacy();

                });

              }else {

                showFlutterToast(message: '${state.pharmacyModel.message}', state: ToastStates.error ,  context: context);

              }

            }


            if(state is SuccessDeleteAccountState) {
              if(state.simpleModel.status == true) {
                CacheHelper.removeData(key: 'token').then((value) {
                  if(value == true) {
                    CacheHelper.removeData(key: 'userId');
                    CacheHelper.removeData(key: 'isPharmacist');
                    Navigator.pop(context);
                    navigatorToNotBack(context: context, screen: const LoginScreen());
                  }
                });
              }
            }
          },
          builder: (context , state) {

            var cubit = RegisterCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Check For Existing Pharmacy',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      const Text(
                        '* Check If the pharmacy is registered by another pharmacist work with you by entering the name : ',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: pharmacyController,
                        keyboardType: TextInputType.text,
                        focusNode: focusNode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            'Pharmacy Name',
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.local_pharmacy_outlined,
                          ),
                          helperText: 'You should enter name like this : \n nameOfPharmacy pharmacy',
                          helperStyle:TextStyle(
                            color: Colors.grey.shade500,),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Name Pharmacy must not be empty';
                          }
                          bool validName = RegExp(r'^\w+ pharmacy$').hasMatch(value);
                          if(!validName) {
                            return 'Enter a valid name --> nameOfPharmacy pharmacy \nAvoid space after pharmacy';
                          }
                          if(value.contains('(') || value.contains(')')) {
                            return 'Don\'t use brackets ()';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if(value.isEmpty) {
                            setState(() {
                              isVisible = false;
                            });
                          }else {
                            setState(() {
                              isVisible = true;
                            });
                          }
                          if(checkCubit.hasInternet == false) {
                            showAlertConnection(context);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Visibility(
                        visible: isVisible,
                        child: ConditionalBuilder(
                          condition: state is! LoadingCheckExistPharmacy,
                          builder: (context) => Align(
                              alignment: Alignment.center,
                              child: defaultButton2(
                                  width: 200.0,
                                  function: () {
                                    if(checkCubit.hasInternet) {
                                      if(formKey.currentState!.validate()) {
                                        cubit.checkExistPharmacy(pharmacyName: pharmacyController.text);
                                        focusNode.unfocus();
                                      }
                                      focusNode.unfocus();
                                    } else {
                                      focusNode.unfocus();
                                      showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                    }

                                  },
                                  text: 'Check',
                                  context: context)
                          ),
                          fallback: (context) => Center(child: IndicatorScreen(os: getOs())),
                        ),
                      ),
                      if(pharmacyController.text == '')
                        const Text(
                          '* If the pharmacy is not founded you have to register one by click on next .',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.5,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      if(pharmacyController.text == '')
                        Align(
                            alignment: Alignment.center,
                            child: defaultButton2(
                                width: 200.0,
                                function: () {
                                  if(checkCubit.hasInternet) {
                                    navigatorToNotBack(context: context, screen: PharmacistRegisterScreen());
                                  } else {
                                    showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                    Future.delayed(const Duration(milliseconds: 1200)).then((value) {
                                      showAlertConnection(context);
                                    });
                                  }
                                },
                                text: 'Next',
                                context: context)
                        ),
                    ],
                  ),
                ),
              ),
            );

          },
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
