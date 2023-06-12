import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/modules/doctor/addPrescriptionPatient/AllMedicationsScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';

class AddPrescriptionScreen extends StatefulWidget {

  final CardData? card;
  final dynamic idUserPatient;
  const AddPrescriptionScreen({super.key, required this.card , required this.idUserPatient});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {

  var prescriptionDateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    prescriptionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state) {
        if(state is SuccessAddPrescriptionAppState) {
          if(state.addPrescriptionModel.status == true){
            prescriptionId = state.addPrescriptionModel.prescription?.prescriptionId;
            Navigator.of(context).push(_createAllMedicationsRoute(state.addPrescriptionModel.prescription?.prescriptionId ,
              state.addPrescriptionModel.prescription?.cardId));

          }else {
            showFlutterToast(message: '${state.addPrescriptionModel.message}', state: ToastStates.error, context: context);
          }
        }
      },
      builder: (context , state) {

        var cubit = AppCubit.get(context);
        var doctor = cubit.doctorProfile;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Add Prescription',
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
                  const Text(
                    'Enter the date : ',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          lastDate: DateTime.parse('2040-01-01')
                      ).then((value) {
                        prescriptionDateController.text = DateFormat("yyyy-MM-dd").format(value!);
                      });
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty) {
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
                    condition: state is! LoadingAddPrescriptionAppState,
                    builder: (context) => Align(
                      alignment: Alignment.center,
                      child: defaultButton2(
                          width: 180.0,
                          function: (){
                            if(CheckCubit.get(context).hasInternet) {
                              if(formKey.currentState!.validate()){
                                cubit.addPrescription(
                                  idCard: widget.card?.cardId,
                                  date: prescriptionDateController.text,
                                  body: doctor?.doctor?.user?.name ?? '',
                                  idUserPatient: widget.card?.patient?.user?.userId,
                                );
                                focusNode.unfocus();
                              }
                              focusNode.unfocus();

                            } else {

                              focusNode.unfocus();
                              showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                            }

                          },
                          text: 'Next',
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

  Route _createAllMedicationsRoute(idPrescription , idCard) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AllMedicationsScreen(prescriptionId: idPrescription, cardId: idCard , idUserPatient: widget.idUserPatient),
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




