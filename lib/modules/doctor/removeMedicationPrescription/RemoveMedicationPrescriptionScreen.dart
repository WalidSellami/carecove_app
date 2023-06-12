import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class RemoveMedicationPrescriptionScreen extends StatelessWidget {
  final CardData? card;
  final List<PrescriptionMedicationsData> prescriptionMedicationsData;
  final PatientDataModel patient;

  const RemoveMedicationPrescriptionScreen(
      {super.key,
      required this.card,
      required this.prescriptionMedicationsData,
      required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessRemoveMedicationFromPrescriptionAppState) {
              if (state.simpleModel.status == true) {
                showFlutterToast(
                    message: '${state.simpleModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context)
                    .getAllPatientPrescriptions(idCard: card?.cardId);
                Navigator.pop(context);
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
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Medications',
              ),
              body: (CheckCubit.get(context).hasInternet) ? ConditionalBuilder(
                condition: prescriptionMedicationsData.isNotEmpty,
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                      ),
                      child: Text(
                        '* Press on the medication you want to remove it :',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => buildItemMedication(
                              prescriptionMedicationsData[index], index, context),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: prescriptionMedicationsData.length),
                    ),
                  ],
                ),
                fallback: (context) => const Center(
                  child: Text(
                    'There is no medications',
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
            );
          },
        );
      },
    );
  }

  Widget buildItemMedication(
          PrescriptionMedicationsData model, index, context) =>
      InkWell(
        onTap: () {
          showAlert(context, model.prescriptionMedicationId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Row(
            children: [
              Text(
                '${index + 1} -',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                '${model.medication?.name}',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  dynamic showAlert(BuildContext context, idPrescriptionMedication) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Do you want to remove this medication ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
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
                  AppCubit.get(context).removeMedicationFromPrescription(
                      idPrescriptionMedication: idPrescriptionMedication,
                      body: card?.doctor?.user?.name ?? '',
                      idUserPatient: patient.user?.userId);
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
