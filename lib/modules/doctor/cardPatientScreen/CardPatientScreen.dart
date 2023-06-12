import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/modules/doctor/addCardPatientScreen/AddCardPatientScreen.dart';
import 'package:project_final/modules/doctor/editCardPatientScreen/EditCardPatientScreen.dart';
import 'package:project_final/modules/doctor/prescriptionsPatientScreen/PrescriptionPatientScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class CardPatientScreen extends StatefulWidget {
  final PatientDataModel patient;
  const CardPatientScreen({super.key, required this.patient});

  @override
  State<CardPatientScreen> createState() => _CardPatientScreenState();
}

class _CardPatientScreenState extends State<CardPatientScreen> {
  bool isScrolled = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {
        if (state is CheckConnectionState) {
          if (CheckCubit.get(context).hasInternet) {
            AppCubit.get(context).getAllPatients();
          }
        }
      },
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessDeleteCardPatientAppState) {
              if (state.deleteModel.status == true) {
                showFlutterToast(
                    message: '${state.deleteModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context)
                    .getCardPatient(idPatient: widget.patient.patientId);
                Navigator.pop(context);
              } else {
                showFlutterToast(
                    message: '${state.deleteModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var card = cubit.cardModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    cubit.clearCardData();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: Text(
                  widget.patient.user?.name ?? '',
                  style: const TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
              ),
              body: (checkCubit.hasInternet) ? ConditionalBuilder(
                condition: card?.card != null,
                builder: (context) => SingleChildScrollView(
                  child: buildItemCardPatient(card?.card, widget.patient),
                ),
                fallback: (context) => (state is LoadingGetCardPatientAppState)
                    ? Center(child: IndicatorScreen(os: getOs()))
                    : const Center(
                        child: Text(
                          'There is no card',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ) : const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Internet',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(EvaIcons.wifiOffOutline),
                  ],
                ),
              ),
              floatingActionButton: ((state
                          is! LoadingGetCardPatientAppState) &&
                      (card?.card == null) &&
                      checkCubit.hasInternet)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 55.0,
                        width: 65.0,
                        child: FloatingActionButton.extended(
                          isExtended: false,
                          icon: Center(
                            child: Icon(
                              EvaIcons.fileAddOutline,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          tooltip: 'Add Card',
                          backgroundColor: ThemeCubit.get(context).isDark
                              ? HexColor('15909d')
                              : HexColor('c1dfff'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                _createFormAddCardPatientRoute(widget.patient));
                          },
                          label: const Text(
                            '',
                          ),
                        ),
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  buildItemCardPatient(CardData? card, patient) => Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(12.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 6.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          EvaIcons.fileTextOutline,
                          size: 26.0,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          'Informations :',
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  defaultNewButton(
                      toolTip: 'Remove',
                      color: HexColor('f9325f'),
                      padding: 9.0,
                      icon: EvaIcons.close,
                      colorIcon: Colors.white,
                      onPress: () {
                        if (CheckCubit.get(context).hasInternet) {
                          showAlert(
                              context,
                              card?.cardId,
                              card?.doctor?.user?.name,
                              widget.patient.user?.userId);
                        } else {
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                        }
                      }),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Age',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${card?.age}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Weight',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${card?.weight}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Sickness',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${card?.sickness}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Phone',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${card?.patient?.user?.phone}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${card?.patient?.address}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  defaultNewButton(
                      toolTip: 'Edit',
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      padding: 11.0,
                      icon: EvaIcons.editOutline,
                      colorIcon: ThemeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                      onPress: () {
                        if (CheckCubit.get(context).hasInternet) {
                          Navigator.of(context)
                              .push(_createFormEditCardPatientRoute(card));
                        } else {
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                        }
                      }),
                  const SizedBox(
                    width: 20.0,
                  ),
                  defaultNewButton(
                      toolTip: 'More',
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      padding: 11.0,
                      icon: EvaIcons.arrowForwardOutline,
                      colorIcon: ThemeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                      onPress: () {
                        if (CheckCubit.get(context).hasInternet) {
                          AppCubit.get(context).clearDataPrescription();
                          navigatorTo(
                              context: context,
                              screen: PrescriptionsPatientScreen(
                                card: card,
                                patient: patient,
                              ));
                        } else {
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      );

  Route _createFormAddCardPatientRoute(patient) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCardPatientScreen(patient: patient),
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

  Route _createFormEditCardPatientRoute(cardData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditCardPatientScreen(cardData: cardData),
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

  dynamic showAlert(BuildContext context, cardId, body, idUserPatient) {
    return showDialog(
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
                        text: 'Do you want to remove this card ? \n\n',
                        style: const TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  'Note : it will be removed also in patient.',
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
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showLoading(context);
                  AppCubit.get(context).deleteCardPatient(
                    cardId: cardId,
                    body: body,
                    idUserPatient: idUserPatient,
                  );
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
