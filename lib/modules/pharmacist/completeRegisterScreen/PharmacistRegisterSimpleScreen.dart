import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/layout/appLayouts/PharmacistLayoutScreen.dart';
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

class PharmacistRegisterSimpleScreen extends StatelessWidget {
  const PharmacistRegisterSimpleScreen({super.key});

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

        return BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is SuccessPharmacistCompleteSimpleRegisterState) {
              if (state.pharmacistCompleteSimpleModel.status == true) {
                showFlutterToast(
                    message: '${state.pharmacistCompleteSimpleModel.message}',
                    state: ToastStates.success,
                    context: context);
                CacheHelper.saveData(
                    key: 'pharmacyId',
                    value: state.pharmacistCompleteSimpleModel.pharmacist?.pharmacyId)
                    .then((value) {
                  pharmacyId = state.pharmacistCompleteSimpleModel.pharmacist
                      ?.pharmacyId;

                  CacheHelper.saveData(
                      key: 'pharmacistId',
                      value: state.pharmacistCompleteSimpleModel.pharmacist
                          ?.pharmacistId)
                      .then((value) {
                    pharmacistId =
                        state.pharmacistCompleteSimpleModel.pharmacist
                            ?.pharmacistId;
                  });

                  AppCubit.get(context).getPharmacyOrders();
                  AppCubit.get(context).getAllMedicationsFromStock();

                  CacheHelper.saveData(key: 'isPharmacist', value: true)
                      .then((value) {
                    navigatorToNotBack(
                        context: context, screen: const PharmacistLayoutScreen());
                    AppCubit.get(context).getProfile();
                  });
                });

              } else {
                showFlutterToast(
                    message: '${state.pharmacistCompleteSimpleModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }


            if(state is SuccessDeleteAccountState) {
              if(state.simpleModel.status == true) {
                CacheHelper.removeData(key: 'token').then((value) {
                  if(value == true) {
                    CacheHelper.removeData(key: 'userId');
                    CacheHelper.removeData(key: 'pharmacyId');
                    CacheHelper.removeData(key: 'isPharmacist');
                    Navigator.pop(context);
                    navigatorToNotBack(context: context, screen: const LoginScreen());
                  }
                });
              }
            }
          },
          builder: (context, state) {
            var cubit = RegisterCubit.get(context);

            if(state is SuccessPharmacistCompleteSimpleRegisterState) {
              if(state.pharmacistCompleteSimpleModel.status == true) {
                Future.delayed(const Duration(milliseconds: 2000)).then((value) {
                  cubit.removeImage();
                });
              }
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Complete Register',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Note : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: HexColor('f9325f') ,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Any suspicious information your account will be deleted immediately.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: HexColor('f9325f'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 25.0,
                      // ),
                      // const Text(
                      //   '* Add your certificate image to know your identity :',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 16.5,
                      //     height: 1.4,
                      //     fontWeight: FontWeight.bold
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      (cubit.imageCertificate == null)
                          ? Align(
                        alignment: Alignment.center,
                        child: OutlinedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.all(12.0),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(
                                  color:
                                  Theme.of(context).colorScheme.primary,
                                ),
                              )),
                          onPressed: () {
                            if(checkCubit.hasInternet) {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Material(
                                      color: ThemeCubit.get(context).isDark
                                          ? HexColor('121212')
                                          : Colors.white,
                                      child: Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading:
                                            const Icon(Icons.camera_alt),
                                            title: const Text(
                                                'Take a photo of your certificat'),
                                            onTap: () async {
                                              cubit.getCertificateImage(
                                                  context,
                                                  ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_library),
                                            title: const Text(
                                                'Choose from gallery'),
                                            onTap: () async {
                                              cubit.getCertificateImage(
                                                  context,
                                                  ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            } else {
                              showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              Future.delayed(const Duration(milliseconds: 1200)).then((value) {
                                showAlertConnection(context);
                              });
                            }
                          },
                          child: const Text(
                            'Add your certificat image',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                          : SizedBox(
                        height: 220.0,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showImage(context, 'image', cubit.imageCertificate);
                                  },
                                  child: Hero(
                                    tag: 'image',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          width: 0.0,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.file(
                                        File(cubit.imageCertificate!.path),
                                        width: double.infinity,
                                        height: 180.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                cubit.removeImage();
                              },
                              child: CircleAvatar(
                                radius: 18.0,
                                backgroundColor:
                                ThemeCubit.get(context).isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                child: Icon(
                                  Icons.close_rounded,
                                  color: ThemeCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      (cubit.imageCertificate != null) ? ConditionalBuilder(
                        condition: state is! LoadingPharmacistCompleteSimpleRegisterState,
                        builder: (context) => Align(
                            alignment: Alignment.center,
                            child: defaultButton2(
                                width: 200.0,
                                function: () {
                                  if(checkCubit.hasInternet) {
                                    cubit.pharmacistCompleteRegisterSimple(
                                        idUser: userId, idPharmacy: pharmacyId);
                                  } else {
                                    showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                    Future.delayed(const Duration(milliseconds: 1200)).then((value) {
                                      showAlertConnection(context);
                                    });
                                  }
                                },
                                text: 'Done',
                                context: context)),
                        fallback: (context) =>
                            Center(child: IndicatorScreen(os: getOs())),
                      )
                          : Container(),
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



  dynamic showImage(BuildContext context , tag , XFile? image) {

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: defaultAppBar(
            context: context),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Hero(
              tag: tag,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.0,
                    color: Colors.grey.shade900,
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.file(File(image!.path),
                  width: double.infinity,
                  height: 455.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    )
    );

  }



}

