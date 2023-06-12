import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/modules/doctor/addPrescriptionPatient/AddPrescriptionScreen.dart';
import 'package:project_final/modules/doctor/addPrescriptionPatient/AllMedicationsScreen.dart';
import 'package:project_final/modules/doctor/editPrescriptionPatient/EditPrescriptionScreen.dart';
import 'package:project_final/modules/doctor/editPrescriptionPatient/MedicationsPrescriptionScreen.dart';
import 'package:project_final/modules/doctor/pharmaciesScreen/PharmaciesScreen.dart';
import 'package:project_final/modules/doctor/removeMedicationPrescription/RemoveMedicationPrescriptionScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class PrescriptionsPatientScreen extends StatefulWidget {
  final CardData? card;
  final PatientDataModel patient;
  const PrescriptionsPatientScreen(
      {super.key, required this.card, required this.patient});

  @override
  State<PrescriptionsPatientScreen> createState() =>
      _PrescriptionsPatientScreenState();
}

class _PrescriptionsPatientScreenState
    extends State<PrescriptionsPatientScreen> {
  bool isScrolled = true;

  // bool? isRemoved;

  var prescriptionDateController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context)
          .getAllPatientPrescriptions(idCard: widget.card?.cardId);
      return BlocConsumer<CheckCubit , CheckStates>(
        listener: (context , state) {},
        builder: (context , state) {

          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {
              if (state is SuccessRemovePrescriptionAppState) {
                if (state.simpleModel.status == true) {
                  showFlutterToast(
                      message: '${state.simpleModel.message}',
                      state: ToastStates.success,
                      context: context);
                  AppCubit.get(context)
                      .getAllPatientPrescriptions(idCard: widget.card?.cardId);
                  Navigator.pop(context);
                } else {
                  showFlutterToast(
                      message: '${state.simpleModel.message}',
                      state: ToastStates.error,
                      context: context);
                }
              }

              // if (state is SuccessRemoveOrderRefusedAppState) {
              //   if (state.simpleModel.status == true) {
              //     setState(() {
              //       isRemoved = true;
              //     });
              //
              //     // if(isRemoved == true){
              //     //   Navigator.pop(context);
              //     // }
              //
              //   } else {
              //
              //     showFlutterToast(
              //         message: '${state.simpleModel.message}',
              //         state: ToastStates.error,
              //         context: context);
              //
              //     setState(() {
              //       isRemoved = false;
              //     });
              //
              //     Navigator.pop(context);
              //
              //   }
              // }

              // if (state is SuccessCheckSendOrderAppState) {
              //   if (state.simpleModel.status == true) {
              //     setState(() {
              //       isAlreadySend = true;
              //     });
              //
              //     if (isAlreadySend == true) {
              //       showFlutterToast(
              //           message: '${state.simpleModel.message}',
              //           state: ToastStates.error,
              //           context: context);
              //       Navigator.pop(context);
              //     }
              //   } else {
              //     setState(() {
              //       isAlreadySend = false;
              //     });
              //   }
              // }
            },
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              var prescriptions = cubit.prescriptionsModel;

              return Scaffold(
                appBar: defaultAppBar(
                  context: context,
                  title: 'Prescriptions',
                ),
                body: (checkCubit.hasInternet) ? ConditionalBuilder(
                  condition: ((prescriptions?.prescription.length ?? 0) > 0),
                  builder: (context) =>
                      NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction == ScrollDirection.forward) {
                            setState(() {
                              isScrolled = true;
                            });
                          } else if (notification.direction ==
                              ScrollDirection.reverse) {
                            setState(() {
                              isScrolled = false;
                            });
                          }

                          return true;
                        },
                        child: RefreshIndicator(
                          key: refreshIndicatorKey,
                          color: ThemeCubit.get(context).isDark
                              ? HexColor('21b8c9')
                              : HexColor('0571d5'),
                          backgroundColor: ThemeCubit.get(context).isDark
                              ? HexColor('181818')
                              : Colors.white,
                          strokeWidth: 2.5,
                          onRefresh: () async {
                            if(checkCubit.hasInternet) {
                              cubit.getAllPatientPrescriptions(
                                idCard: widget.card?.cardId);
                            }
                            return Future<void>.delayed(const Duration(seconds: 2));
                          },
                          child: ListView.builder(
                            // physics: ((prescriptions?.prescription.length ?? 0) > 1) ? const BouncingScrollPhysics() : null,
                            itemBuilder: (context, index) =>
                                buildItemPrescriptionPatient(
                                    prescriptions!.prescription[index]),
                            itemCount: prescriptions?.prescription.length ?? 0,
                          ),
                        ),
                      ),
                  fallback: (context) =>
                  (state is LoadingGetPrescriptionsAppState ||
                      prescriptions == null)
                      ? Center(child: IndicatorScreen(os: getOs()))
                      : const Center(
                    child: Text(
                      'There is no prescriptions',
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
                floatingActionButton: (prescriptions?.prescription != null && checkCubit.hasInternet)
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55.0,
                    width: 65.0,
                    child: Visibility(
                      visible: isScrolled,
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
                        tooltip: 'Add Prescription',
                        backgroundColor: ThemeCubit.get(context).isDark
                            ? HexColor('15909d')
                            : HexColor('b3d8ff'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(_createAddPrescriptionRoute());
                        },
                        label: const Text(
                          '',
                        ),
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
    });
  }

  buildItemPrescriptionPatient(PrescriptionData model) => Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 4.0,
                ),
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Date :',
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          '${model.prescriptionDate}',
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    defaultNewButton(
                        toolTip: 'Remove',
                        color: HexColor('f9325f'),
                        padding: 9.0,
                        icon: EvaIcons.close,
                        colorIcon: Colors.white,
                        onPress: () {
                          if(CheckCubit.get(context).hasInternet) {
                            showAlert(context, model.prescriptionId);
                          } else {
                            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                          }
                        }),
                  ],
                ),
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
                    const Row(
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
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${widget.card?.patient?.user?.name}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.5,
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
                                'Age',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '${widget.card?.age}',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 10.0,
                      ),
                      child: Divider(
                        thickness: 0.6,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Medication',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'Dosage',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildItemPrescriptionMedication(
                                model.prescriptionMedications[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10.0,
                            ),
                        itemCount: model.prescriptionMedications.length),
                  ],
                ),
              ),
              SizedBox(
                height: (model.orders.isEmpty) ? 26.0 : 15.0,
              ),
              // if(CheckCubit.get(context).hasInternet)
              (model.orders.isEmpty)
                  ? Row(
                      mainAxisAlignment: model.prescriptionMedications.isNotEmpty ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.end,
                      children: [
                        if(model.prescriptionMedications.isNotEmpty)
                        defaultNewButton(
                            toolTip: 'Remove Medication',
                            color: ThemeCubit.get(context).isDark
                                ? HexColor('15909d')
                                : HexColor('b3d8ff'),
                            padding: 11.0,
                            icon: Icons.remove,
                            colorIcon: ThemeCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            onPress: () {
                              Navigator.of(context).push(
                                  _createRemoveMedicationFromPrescriptionRoute(
                                      model.prescriptionMedications));
                            }),
                        defaultNewButton(
                            toolTip: 'Add Medication',
                            color: ThemeCubit.get(context).isDark
                                ? HexColor('15909d')
                                : HexColor('b3d8ff'),
                            padding: 11.0,
                            icon: Icons.add,
                            colorIcon: ThemeCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            onPress: () {
                              Navigator.of(context).push(
                                  _createAddMedicationInPrescriptionRoute(
                                      model.prescriptionId, model.cardId));
                            }),
                        if(model.prescriptionMedications.isNotEmpty)
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
                              Navigator.of(context)
                                  .push(_createEditPrescriptionRoute(model));
                            }),
                        if(model.prescriptionMedications.isNotEmpty)
                          Material(
                          color: ThemeCubit.get(context).isDark
                              ? HexColor('15909d')
                              : HexColor('b3d8ff'),
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(8.0),
                          child: Tooltip(
                            message: 'Send',
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              onTap: () {
                                String medications = model
                                    .prescriptionMedications
                                    .map((e) => e.medicationId.toString())
                                    .toList()
                                    .join(',');
                                String quantities = model
                                    .prescriptionMedications
                                    .map((e) => e.quantity.toString())
                                    .toList()
                                    .join(',');
                                AppCubit.get(context).clearPharmacies();
                                AppCubit.get(context)
                                    .getPharmaciesWithMedicationsPrescription(
                                        medications: medications,
                                        quantities: quantities,
                                );
                                Navigator.of(context)
                                    .push(_createGetPharmaciesRoute(model));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(11.0),
                                child: const Icon(
                                  Icons.send_rounded,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(model.prescriptionMedications.isEmpty)
                          const SizedBox(
                          width: 6.0,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        right: 6.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    Navigator.of(context).push(
                                        _createEditPrescriptionDosageRoute(
                                            model.prescriptionId,
                                            model.prescriptionMedications,
                                            model.orders[0].status,
                                        ));
                                  }),
                              if (model.orders[0].status == 'Refused')
                                const SizedBox(
                                  width: 20.0,
                                ),
                              if (model.orders[0].status == 'Refused')
                                Material(
                                  color: ThemeCubit.get(context).isDark
                                      ? HexColor('15909d')
                                      : HexColor('b3d8ff'),
                                  elevation: 3.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Tooltip(
                                    message: 'Send',
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8.0),
                                      onTap: () {
                                        showLoading(context);
                                        AppCubit.get(context)
                                            .removeOrderRefused(
                                                idPrescription:
                                                    model.prescriptionId);
                                        String medications = model
                                            .prescriptionMedications
                                            .map((e) =>
                                                e.medicationId.toString())
                                            .toList()
                                            .join(',');
                                        String quantities = model
                                            .prescriptionMedications
                                            .map((e) =>
                                            e.quantity.toString())
                                            .toList()
                                            .join(',');
                                        Future.delayed(const Duration(
                                                milliseconds: 350))
                                            .then((value) {
                                              // if(isRemoved == true) {
                                                Navigator.pop(context);
                                                AppCubit.get(context)
                                                    .clearPharmacies();
                                                AppCubit.get(context)
                                                    .getPharmaciesWithMedicationsPrescription(
                                                    medications: medications,
                                                    quantities: quantities,
                                                 );
                                                Navigator.of(context).push(
                                                    _createGetPharmaciesRoute(model));
                                              // }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(11.0),
                                        child: const Icon(
                                          Icons.send_rounded,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (model.orders[0].status == 'Refused' || model.orders[0].status == 'Accepted')
                            const SizedBox(
                              height: 16.0,
                            ),
                          if (model.orders[0].status == 'En hold')
                            Text.rich(
                                TextSpan(
                                    text: '* This prescription is ',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'en hold.',
                                        style: TextStyle(
                                          color: Colors.amber.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ])),
                          if (model.orders[0].status == 'Accepted')
                            Text.rich(
                                TextSpan(
                                    text: '* This prescription is ',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'accepted.',
                                        style: TextStyle(
                                          color: HexColor('2eb7c9'),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ])),
                          if (model.orders[0].status == 'Refused')
                            Text.rich(
                                TextSpan(
                                text: '* This prescription is ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'refused.',
                                    style: TextStyle(
                                      color: HexColor('f9325f'),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ])),
                          if (model.orders[0].status == 'Refused')
                            Text(
                            '* You can resend it.',
                            style: TextStyle(
                              height: 1.4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );

  Widget buildItemPrescriptionMedication(PrescriptionMedicationsData model) =>
      Row(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.medication?.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.dosage}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Route _createAddPrescriptionRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddPrescriptionScreen(
                card: widget.card, idUserPatient: widget.patient.user?.userId),
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

  Route _createAddMedicationInPrescriptionRoute(idPrescription, idCard) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AllMedicationsScreen(
              prescriptionId: idPrescription,
              cardId: idCard,
              idUserPatient: widget.patient.user?.userId,
            ),
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

  Route _createRemoveMedicationFromPrescriptionRoute(
      prescriptionMedicationsData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RemoveMedicationPrescriptionScreen(
                card: widget.card,
                prescriptionMedicationsData: prescriptionMedicationsData,
                patient: widget.patient),
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

  Route _createEditPrescriptionRoute(prescriptionData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditPrescriptionScreen(
                prescription: prescriptionData, patient: widget.patient),
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

  Route _createEditPrescriptionDosageRoute(
      idPrescription, prescriptionMedications , statusOrder) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MedicationsPrescriptionScreen(
                patient: widget.patient,
                idCard: widget.card?.cardId,
                idPrescription: idPrescription,
                prescriptionMedicationsData: prescriptionMedications,
                statusOrder: statusOrder,
            ),
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

  Route _createGetPharmaciesRoute(prescription) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PharmaciesScreen(prescription: prescription, card: widget.card),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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

  dynamic showAlert(BuildContext context, idPrescription) {
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
                        text: 'Do you want to remove this prescription ? \n\n',
                        style: const TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  'Note : it will be removed also in patient and in order pharmacist.',
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
                  AppCubit.get(context).removePrescription(
                    idPrescription: idPrescription,
                    body: widget.card?.doctor?.user?.name ?? '',
                    idUserPatient: widget.patient.user?.userId,
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
