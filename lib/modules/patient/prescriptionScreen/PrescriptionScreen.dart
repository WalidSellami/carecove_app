import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardPatientModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/model/profileModel/profilePatientModel/ProfilePatientModel.dart';
import 'package:project_final/modules/patient/prescriptionDetailsScreen/PrescriptionDetailsScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class PrescriptionScreen extends StatefulWidget {
  final CardsPatientData? card;
  final ProfilePatientModel? patient;
  const PrescriptionScreen(
      {super.key, required this.card, required this.patient});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  bool isScrolled = true;

  var prescriptionDateController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getPrescriptions(idCard: widget.card?.cardId);
      return BlocConsumer<CheckCubit, CheckStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {
              if (state is SuccessSendNotificationAppState) {
                if ((AppCubit.get(context).title == 'New Prescription' ||
                        AppCubit.get(context).title == 'Update Prescription' ||
                        AppCubit.get(context).title == 'Delete Prescription' ||
                        AppCubit.get(context).title == 'Edit Dosage Medication' ||
                        AppCubit.get(context).title == 'New Medication Prescription' ||
                        AppCubit.get(context).title == 'Remove Medication Prescription') &&
                    (AppCubit.get(context).id == userId) && CheckCubit.get(context).hasInternet) {
                    AppCubit.get(context).getPrescriptions(idCard: widget.card?.cardId);
                }
              }

              if (state is SuccessRemovePrescriptionAppState) {
                if (state.simpleModel.status == true) {
                  showFlutterToast(
                      message: '${state.simpleModel.message}',
                      state: ToastStates.success,
                      context: context);
                  AppCubit.get(context)
                      .getPrescriptions(idCard: widget.card?.cardId);
                  Navigator.pop(context);
                } else {
                  showFlutterToast(
                      message: '${state.simpleModel.message}',
                      state: ToastStates.error,
                      context: context);
                }
              }
            },
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              var prescriptions = cubit.prescriptionsModel;

              return Scaffold(
                appBar: defaultAppBar(
                  context: context,
                  title: 'Prescriptions',
                ),
                body: (checkCubit.hasInternet)
                    ? ConditionalBuilder(
                        condition:
                            ((prescriptions?.prescription.length ?? 0) > 0),
                        builder: (context) =>
                            NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            if (notification.direction ==
                                ScrollDirection.forward) {
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
                              cubit.getPrescriptions(
                                  idCard: widget.card?.cardId);
                              return Future<void>.delayed(
                                  const Duration(seconds: 2));
                            },
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  buildItemPrescription(
                                      prescriptions!.prescription[index] , index),
                              itemCount:
                                  prescriptions?.prescription.length ?? 0,
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
                      )
                    : const Center(
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
              );
            },
          );
        },
      );
    });
  }

  buildItemPrescription(PrescriptionData model , index) => GestureDetector(
    onTap: () {
      navigatorTo(context: context, screen: PrescriptionDetailsScreen(card: widget.card, patient: widget.patient, prescription: model));
    },
    child: Card(
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
                                    '${widget.patient?.patient?.user?.name}',
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
                                  model.prescriptionMedications[index] , context),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 14.0,
                              ),
                          itemCount: model.prescriptionMedications.length),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6.0,
                ),
              ],
            ),
          ),
        ),
  );

  buildItemPrescriptionMedication(PrescriptionMedicationsData model , context) =>
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
}

