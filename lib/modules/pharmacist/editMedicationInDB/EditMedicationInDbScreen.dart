import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class EditMedicationInDbScreen extends StatefulWidget {
  final MedicationData medicationData;
  const EditMedicationInDbScreen({super.key, required this.medicationData});

  @override
  State<EditMedicationInDbScreen> createState() =>
      _EditMedicationInDbScreenState();
}

class _EditMedicationInDbScreenState extends State<EditMedicationInDbScreen> {
  var medicationNameController = TextEditingController();
  var medicationDescriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  void initState() {
    medicationNameController.text = (widget.medicationData.name).toString();
    medicationDescriptionController.text =
        (widget.medicationData.description).toString();
    super.initState();
  }

  @override
  void dispose() {
    medicationNameController.dispose();
    medicationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessEditMedicationInDbAppState) {
          if (state.simpleModel.status == true) {
            showFlutterToast(
                message: '${state.simpleModel.message}',
                state: ToastStates.success,
                context: context);
            AppCubit.get(context).getAllMedications();
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

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Medication',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultSimpleFormField(
                        text: 'Medication Name',
                        controller: medicationNameController,
                        focusNode: focusNode1,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Medication Name must not be empty';
                          }
                          bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s,._()-]+$').hasMatch(value);
                          if(!nameValid) {
                            return 'Enter a valid name';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: medicationDescriptionController,
                      keyboardType: TextInputType.text,
                      focusNode: focusNode2,
                      maxLines: null,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Medication Description',
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
                          return 'Medication Description must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingEditMedicationInDbAppState,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: defaultButton2(
                            function: () {
                              if(CheckCubit.get(context).hasInternet) {
                                if (formKey.currentState!.validate()) {
                                  cubit.editMedicationInDb(
                                    name: medicationNameController.text,
                                    description:
                                    medicationDescriptionController.text,
                                    medicationId:
                                    widget.medicationData.medicationId,
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
          ),
        );
      },
    );
  }
}
