import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/modules/doctor/editPrescriptionPatient/EditDosagePrescriptionScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class MedicationsPrescriptionScreen extends StatelessWidget {
  final int? idPrescription;
  final int? idCard;
  final List<PrescriptionMedicationsData> prescriptionMedicationsData;
  final PatientDataModel patient;
  final String? statusOrder;
  const MedicationsPrescriptionScreen(
      {super.key,
      required this.idPrescription,
      required this.idCard,
      required this.prescriptionMedicationsData,
      required this.patient,
      this.statusOrder,
      });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Medications',
              ),
              body: (checkCubit.hasInternet) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      left: 10.0,
                    ),
                    child: Text(
                      '* Press on the medication you want to edit it:',
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
                    child: ConditionalBuilder(
                      condition: prescriptionMedicationsData.isNotEmpty,
                      builder: (context) => ListView.separated(
                          itemBuilder: (context, index) => buildItemMedication(
                              prescriptionMedicationsData[index], index, context),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 4.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: prescriptionMedicationsData.length),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no medications',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          Navigator.of(context)
              .push(_createEditDosagePrescriptionRoute(idCard, model));
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
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.0,
              ),
            ],
          ),
        ),
      );

  Route _createEditDosagePrescriptionRoute(idCard, prescriptionData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditDosagePrescriptionScreen(
                idCard: idCard,
                prescriptionData: prescriptionData,
                patient: patient,
                statusOrder: statusOrder,
            ),
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
}
