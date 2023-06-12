import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class EditDosagePrescriptionScreen extends StatefulWidget {
  final int idCard;
  final PrescriptionMedicationsData prescriptionData;
  final PatientDataModel patient;
  final String? statusOrder;
  const EditDosagePrescriptionScreen(
      {super.key,
      required this.idCard,
      required this.prescriptionData,
      required this.patient,
      this.statusOrder});

  @override
  State<EditDosagePrescriptionScreen> createState() =>
      _EditDosagePrescriptionScreenState();
}

class _EditDosagePrescriptionScreenState
    extends State<EditDosagePrescriptionScreen> {
  var dosageController = TextEditingController();
  var quantityController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  void initState() {
    quantityController.text = widget.prescriptionData.quantity.toString();
    dosageController.text = widget.prescriptionData.dosage.toString();
    super.initState();
  }

  @override
  void dispose() {
    quantityController.dispose();
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessEditDosageMedicationPrescriptionAppState) {
          if (state.simpleModel.status == true) {
            showFlutterToast(
                message: '${state.simpleModel.message}',
                state: ToastStates.success,
                context: context);
            AppCubit.get(context)
                .getAllPatientPrescriptions(idCard: widget.idCard);
            Navigator.pop(context);
            Navigator.pop(context);
            if (prescriptionDateController.text != '') {
              Navigator.pop(context);
              prescriptionDateController.text = '';
            }
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
            title: 'Edit Quantity and Dosage',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  if (widget.statusOrder == null ||
                      widget.statusOrder == 'Refused')
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      focusNode: focusNode1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Quantity',
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Quantity must not be empty';
                        }
                        if (value == '0') {
                          return 'Quantity must be greater than 0';
                        }
                        if(value.contains('-') || value.contains('.')) {
                          return 'Enter a positive integer number';
                        }
                        return null;
                      },
                    ),
                  if (widget.statusOrder == null ||
                      widget.statusOrder == 'Refused')
                    const SizedBox(
                      height: 25.0,
                    ),
                  TextFormField(
                    controller: dosageController,
                    keyboardType: TextInputType.multiline,
                    focusNode: focusNode2,
                    maxLines: null,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      label: const Text(
                        'Dosage',
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Dosage must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ConditionalBuilder(
                    condition: state
                        is! LoadingEditDosageMedicationPrescriptionAppState,
                    builder: (context) => Center(
                      child: defaultButton2(
                          width: 200.0,
                          function: () {
                            if (CheckCubit.get(context).hasInternet) {
                              if (formKey.currentState!.validate()) {
                                cubit.editDosageMedicationPrescription(
                                  idPrescriptionMedication: widget
                                      .prescriptionData
                                      .prescriptionMedicationId,
                                  dosage: dosageController.text,
                                  quantity: quantityController.text,
                                  body: doctor?.doctor?.user?.name ?? '',
                                  idUserPatient: widget.patient.user?.userId,
                                );
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                              }
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                            } else {
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                              showFlutterToast(
                                  message: 'No Internet Connection',
                                  state: ToastStates.error,
                                  context: context);
                            }
                          },
                          text: 'Update',
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
}
