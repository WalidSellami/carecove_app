import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class AddCardPatientScreen extends StatefulWidget {
  final PatientDataModel patient;
  const AddCardPatientScreen({super.key, required this.patient});

  @override
  State<AddCardPatientScreen> createState() => _AddCardPatientScreenState();
}

class _AddCardPatientScreenState extends State<AddCardPatientScreen> {
  var ageController = TextEditingController();

  var weightController = TextEditingController();

  var sicknessController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    sicknessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, index) {},
      builder: (context, index) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessAddCardPatientAppState) {
              if (state.addPatientModel.status == true) {
                showFlutterToast(
                    message: '${state.addPatientModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context)
                    .getCardPatient(idPatient: widget.patient.patientId);
                Navigator.pop(context);
              } else {
                showFlutterToast(
                    message: '${state.addPatientModel.message}',
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
                title: 'Add Card',
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      defaultFormField(
                          text: 'Age',
                          controller: ageController,
                          focusNode: focusNode1,
                          type: TextInputType.number,
                          prefix: Icons.numbers_outlined,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Age must not be empty';
                            }

                            if (value == '0' || value.substring(0, 1) == '0') {
                              return 'Age must be greater than 0';
                            }
                            if(value.contains('-') || value.contains('.')) {
                              return 'Enter a positive integer number greater than 0';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormField(
                          text: 'Weight',
                          controller: weightController,
                          focusNode: focusNode2,
                          type: TextInputType.number,
                          prefix: Icons.numbers_outlined,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Weight must not be empty';
                            }
                            if (value == '0' || value.substring(0, 1) == '0') {
                              return 'Weight must be greater than 0';
                            }
                            if(value.contains('-')) {
                              return 'Enter a positive integer or double number greater than 0';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 25.0,
                      ),
                      defaultFormField(
                          text: 'Sickness',
                          controller: sicknessController,
                          focusNode: focusNode3,
                          type: TextInputType.text,
                          prefix: Icons.sick_outlined,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Sickness must not be empty';
                            }
                            bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s,._]+$').hasMatch(value);
                            if(!nameValid) {
                              return 'Enter a valid name without numbers';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 45.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoadingAddCardPatientAppState,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: defaultButton2(
                              function: () {
                                if (checkCubit.hasInternet) {
                                  if (formKey.currentState!.validate()) {
                                    cubit.addCardPatient(
                                      age: ageController.text,
                                      weight: weightController.text,
                                      sickness: sicknessController.text,
                                      idPatient: widget.patient.patientId,
                                      idDoctor: doctorId,
                                      body: doctor?.doctor?.user?.name ?? '',
                                      idUserPatient:
                                          widget.patient.user?.userId,
                                    );
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                  }
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                } else {
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                  showFlutterToast(
                                      message: 'No Internet Connection',
                                      state: ToastStates.error,
                                      context: context);
                                }
                              },
                              text: 'Add',
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
      },
    );
  }
}
