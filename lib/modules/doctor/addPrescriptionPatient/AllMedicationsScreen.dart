import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/modules/doctor/addPrescriptionPatient/AddMedicationPrescriptionScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class AllMedicationsScreen extends StatefulWidget {
  final int prescriptionId;
  final int cardId;
  final int? idUserPatient;
  const AllMedicationsScreen(
      {super.key,
      required this.prescriptionId,
      required this.cardId,
      required this.idUserPatient});

  @override
  State<AllMedicationsScreen> createState() => _AllMedicationsScreenState();
}

class _AllMedicationsScreenState extends State<AllMedicationsScreen> {
  bool? isExist;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllMedications();
      return BlocConsumer<CheckCubit , CheckStates>(
        listener: (context , state) {
          if(state is CheckConnectionState) {
            if(CheckCubit.get(context).hasInternet) {
              AppCubit.get(context).getAllMedications();
            }
          }
        },
        builder: (context , state) {

          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {
              if (state is SuccessCheckExistMedicationPrescriptionAppState) {
                if (state.simpleModel.status == true) {
                  setState(() {
                    isExist = true;
                  });

                  if (isExist == true) {
                    Navigator.pop(context);
                    showFlutterToast(
                        message: '${state.simpleModel.message}',
                        state: ToastStates.error,
                        context: context);
                  }
                } else {
                  setState(() {
                    isExist = false;
                  });
                }
              }


            },
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              var medications = cubit.medicationsModel;

              return Scaffold(
                appBar: defaultAppBar(
                  context: context,
                  title: 'Medications',
                ),
                body: (checkCubit.hasInternet) ? ConditionalBuilder(
                  condition: (medications?.medications.length ?? 0) > 0,
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                        ),
                        child: Text(
                          '* Press on the medication you want to add it : ',
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
                                medications!.medications[index], index, context),
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
                            itemCount: medications?.medications.length ?? 0),
                      ),
                    ],
                  ),
                  fallback: (context) =>
                  (state is LoadingGetAllMedicationsAppState ||
                      medications == null)
                      ? Center(child: IndicatorScreen(os: getOs()))
                      : const Center(
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
    });
  }

  Widget buildItemMedication(MedicationData model, index, context) => InkWell(
        onTap: () {
          showLoading(context);
          AppCubit.get(context).checkExistMedicationInPrescription(
              idPrescription: widget.prescriptionId,
              idMedication: model.medicationId);
          Future.delayed(const Duration(milliseconds: 1200)).then((value) {
            if (isExist == false) {
              Navigator.pop(context);
              Navigator.of(context).push(
                  _createAddMedicationPrescriptionRoute(model.medicationId));
            }
          });
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
                '${model.name}',
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

  Route _createAddMedicationPrescriptionRoute(idMedication) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddMedicationPrescriptionScreen(
                idMedication: idMedication,
                idPrescription: widget.prescriptionId,
                idCard: widget.cardId,
                idUserPatient: widget.idUserPatient),
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
