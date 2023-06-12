import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class AddMedicationInDbScreen extends StatefulWidget {
  const AddMedicationInDbScreen({super.key});

  @override
  State<AddMedicationInDbScreen> createState() => _AddMedicationInDbScreenState();
}

class _AddMedicationInDbScreenState extends State<AddMedicationInDbScreen> {

  var medicationNameController = TextEditingController();
  var medicationDescriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();


  @override
  void dispose() {
    medicationNameController.dispose();
    medicationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {

        if(state is SuccessAddMedicationInDbAppState) {
          if(state.simpleModel.status == true) {

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.success ,  context: context);
            AppCubit.get(context).getAllMedications();
            Navigator.pop(context);

          }else {

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error ,  context: context);

          }

        }

      },
      builder: (context , state) {

        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Add Medication',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      controller: medicationNameController,
                      keyboardType: TextInputType.text,
                      focusNode: focusNode1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Medication Name',
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (String value) {
                        cubit.checkExistMedicationInDb(name: value);
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'Medication Name must not be empty';
                        }
                        bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s,._()]+$').hasMatch(value);
                        if(!nameValid) {
                          return 'Enter a valid name';
                        }
                        if(state is SuccessCheckExistMedicationInDbAppState) {
                          if(state.simpleModel.status == true) {
                           return '${state.simpleModel.message}';
                          }else {
                            return null;
                          }
                          }
                        return null;
                      },
                    ),
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
                        if(value == null || value.isEmpty) {
                          return 'Medication Description must not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingAddMedicationInDbAppState,
                      builder: (context) =>  Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: defaultButton2(
                            function: () {

                              if(CheckCubit.get(context).hasInternet) {
                                if (formKey.currentState!.validate()) {
                                  cubit.addMedicationInDb(
                                    name: medicationNameController.text,
                                    description: medicationDescriptionController.text,
                                    context: context,
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
          ),
        );

      },
    );
  }
}
