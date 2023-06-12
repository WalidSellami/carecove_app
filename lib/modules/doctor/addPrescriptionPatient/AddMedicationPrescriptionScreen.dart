import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';


class AddMedicationPrescriptionScreen extends StatefulWidget {

  final int idMedication;
  final int idPrescription;
  final int idCard;
  final int? idUserPatient;
  const AddMedicationPrescriptionScreen({super.key, required this.idMedication , required this.idPrescription , required this.idCard , required this.idUserPatient});

  @override
  State<AddMedicationPrescriptionScreen> createState() => _AddMedicationPrescriptionScreenState();
}

class _AddMedicationPrescriptionScreenState extends State<AddMedicationPrescriptionScreen> {

  var dosageController = TextEditingController();
  var quantityController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  void dispose() {
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {
        if(state is SuccessAddPrescriptionMedicationAppState) {
          if(state.simpleModel.status == true) {

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.success, context: context);
            AppCubit.get(context).getAllPatientPrescriptions(idCard: widget.idCard);
            Navigator.pop(context);
            Navigator.pop(context);
            if(prescriptionId != null){
              Navigator.pop(context);
              prescriptionId = null;
            }

          }else {

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);


          }

        }
      },
      builder: (context , state) {

        var cubit = AppCubit.get(context);
        var doctor = cubit.doctorProfile;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Add Medication in prescription',
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
                  const Text(
                    'Enter the Quantity : ',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
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
                      if(value == null || value.isEmpty) {
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
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'Enter the dosage : ',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
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
                      if(value == null || value.isEmpty) {
                        return 'Dosage must not be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ConditionalBuilder(
                    condition: state is! LoadingAddPrescriptionMedicationAppState,
                    builder: (context) => Center(
                      child: defaultButton2(
                        width: 180.0,
                          function: () {
                          if(CheckCubit.get(context).hasInternet) {
                            if(formKey.currentState!.validate()) {
                              cubit.addPrescriptionMedication(
                                idPrescription: widget.idPrescription,
                                dosage: dosageController.text,
                                quantity: quantityController.text,
                                idMedication: widget.idMedication,
                                body: doctor?.doctor?.user?.name ?? '',
                                idUserPatient: widget.idUserPatient,
                              );
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                            }
                            focusNode1.unfocus();
                            focusNode2.unfocus();

                          } else {

                            focusNode1.unfocus();
                            focusNode2.unfocus();
                            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                          }

                          },
                          text: 'Add',
                          context: context),
                    ),
                    fallback: (context) => Center(child: IndicatorScreen(os: getOs())),
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
