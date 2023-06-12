import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/modules/doctor/editPrescriptionPatient/MedicationsPrescriptionScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class EditPrescriptionScreen extends StatefulWidget {
  final PrescriptionData prescription;
  final PatientDataModel patient;
  const EditPrescriptionScreen({super.key, required this.prescription, required this.patient});

  @override
  State<EditPrescriptionScreen> createState() => _EditPrescriptionScreenState();
}

class _EditPrescriptionScreenState extends State<EditPrescriptionScreen> {

  var formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    prescriptionDateController.text =
        widget.prescription.prescriptionDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessEditPrescriptionAppState) {
          if (state.simpleModel.status == true) {
            Navigator.of(context).push(_createMedicationsPrescriptionRoute());
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
        var doctor = cubit.doctorProfile;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Prescription',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    controller: prescriptionDateController,
                    keyboardType: TextInputType.datetime,
                    focusNode: focusNode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      label: const Text(
                        'Date',
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2040-01-01'))
                          .then((value) {
                        prescriptionDateController.text =
                            DateFormat("yyyy-MM-dd").format(value!);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date must not be empty';
                      }
                      bool dateValid = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
                      if(!dateValid) {
                        return 'Enter a date like (year-month-day)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ConditionalBuilder(
                    condition: state is! LoadingEditPrescriptionAppState,
                    builder: (context) => Align(
                      // alignment: Alignment.centerRight,
                      child: defaultButton2(
                          width: 180.0,
                          function: () {
                            if(CheckCubit.get(context).hasInternet) {
                              if (formKey.currentState!.validate()) {
                                if(prescriptionDateController.text != widget.prescription.prescriptionDate.toString()) {
                                  cubit.editPrescription(
                                    idPrescription:
                                    widget.prescription.prescriptionId,
                                    date: prescriptionDateController.text,
                                    body: doctor?.doctor?.user?.name ?? '',
                                    idUserPatient: widget.patient.user?.userId,
                                  );
                                  focusNode.unfocus();
                                }else {
                                  focusNode.unfocus();
                                  Navigator.of(context).push(_createMedicationsPrescriptionRoute());

                                }
                                focusNode.unfocus();
                              }
                            } else {
                              focusNode.unfocus();
                              showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                            }

                          },
                          text: 'Next',
                          context: context),
                    ),
                    fallback: (context) =>
                        Center(child: IndicatorScreen(os: getOs())),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Route _createMedicationsPrescriptionRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MedicationsPrescriptionScreen(
                idPrescription: widget.prescription.prescriptionId,
                idCard: widget.prescription.cardId,
                prescriptionMedicationsData:
                    widget.prescription.prescriptionMedications,
                patient: widget.patient),
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
