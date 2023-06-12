import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class EditCardPatientScreen extends StatefulWidget {
  final CardData cardData;
  const EditCardPatientScreen({super.key, required this.cardData});

  @override
  State<EditCardPatientScreen> createState() => _EditCardPatientScreenState();
}

class _EditCardPatientScreenState extends State<EditCardPatientScreen> {
  var ageCnt = TextEditingController();

  var weightCnt = TextEditingController();

  var sicknessCnt = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  void initState() {
    ageCnt.text = widget.cardData.age.toString();
    weightCnt.text = widget.cardData.weight.toString();
    sicknessCnt.text = widget.cardData.sickness.toString();
    super.initState();
  }

  @override
  void dispose() {
    ageCnt.dispose();
    weightCnt.dispose();
    sicknessCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessEditCardPatientAppState) {
          if (state.editModel.status == true) {
            showFlutterToast(
                message: '${state.editModel.message}',
                state: ToastStates.success,
                context: context);
            AppCubit.get(context)
                .getCardPatient(idPatient: widget.cardData.patientId);
            Navigator.pop(context);
          } else {
            showFlutterToast(
                message: '${state.editModel.message}',
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
            title: 'Edit Card',
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
                    defaultFormField(
                        text: 'Age',
                        controller: ageCnt,
                        focusNode: focusNode1,
                        type: TextInputType.number,
                        prefix: Icons.numbers_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age must not be empty';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 25.0,
                    ),
                    defaultFormField(
                        text: 'Weight',
                        controller: weightCnt,
                        focusNode: focusNode2,
                        type: TextInputType.number,
                        prefix: Icons.numbers_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Weight must not be empty';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 25.0,
                    ),
                    defaultFormField(
                        text: 'Sickness',
                        controller: sicknessCnt,
                        focusNode: focusNode3,
                        type: TextInputType.text,
                        prefix: Icons.sick_outlined,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Sickness must not be empty';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 45.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingEditCardPatientAppState,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: defaultButton2(
                            function: () {
                              if (CheckCubit.get(context).hasInternet) {
                                if (formKey.currentState!.validate()) {
                                  cubit.editCardPatient(
                                    age: ageCnt.text,
                                    weight: weightCnt.text,
                                    sickness: sicknessCnt.text,
                                    cardId: widget.cardData.cardId,
                                    body: doctor?.doctor?.user?.name ?? '',
                                    idUserPatient:
                                        widget.cardData.patient?.user?.userId,
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
