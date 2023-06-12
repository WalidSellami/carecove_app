import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/allUsersModel/AllUsersModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class EditSecondScreen extends StatefulWidget {

  final AllUserModel? userData;

  const EditSecondScreen({super.key , this.userData});

  @override
  State<EditSecondScreen> createState() => _EditSecondScreenState();
}

class _EditSecondScreenState extends State<EditSecondScreen> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var specialityController = TextEditingController();
  var namePharmacyController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();


  @override
  void initState() {
    if(widget.userData != null) {
      nameController.text = (widget.userData?.name).toString();
      phoneController.text = (widget.userData?.phone).toString();
      specialityController.text = (widget.userData?.doctor?.speciality).toString();
      if(widget.userData?.doctor?.localAddress != null) {
        addressController.text = (widget.userData?.doctor?.localAddress).toString();
      } else {
        addressController.text = (widget.userData?.pharmacist?.pharmacy?.localAddress).toString();
      }

    }
    super.initState();
  }


  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    specialityController.dispose();
    namePharmacyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {
            if(state is SuccessUpdateProfileAppState) {
              AppCubit.get(context).getAllUsers();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Edit User Info',
              ),
              body: (checkCubit.hasInternet) ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        defaultFormField(
                            text: 'Full Name',
                            controller: nameController,
                            type: TextInputType.name,
                            focusNode: focusNode1,
                            prefix: Icons.person,
                            validate: (value){
                              if(value == null || value.isEmpty){
                                return 'Full Name must not be empty';
                              }
                              if(value.length < 4) {
                                return 'Full Name must be at least 4 characters';
                              }
                              bool validName = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$').hasMatch(value);
                              if(!validName) {
                                return 'Enter a valid name , Don\'t enter only numbers and without (,-)';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            text: 'Phone',
                            controller: phoneController,
                            type: TextInputType.phone,
                            prefix: Icons.phone,
                            focusNode: focusNode2,
                            validate: (value){
                              if(value == null || value.isEmpty){
                                return 'Phone must not be empty';
                              }
                              if (value.length < 9 || value.length > 10) {
                                return 'Phone must be 9 or 10 numbers with 0 in the beginning';
                              }
                              String firstLetter =
                              value.substring(0, 1).toUpperCase();
                              if (firstLetter != '0') {
                                return 'Phone must be starting with 0';
                              }
                              return null;
                            }),
                        if((widget.userData != null && (widget.userData?.role == 'Doctor')))
                          const SizedBox(
                          height: 30.0,
                        ),
                        if((widget.userData != null && (widget.userData?.role == 'Doctor')))
                        defaultFormField(
                            text: 'Local Address Work',
                            controller: addressController,
                            focusNode: focusNode3,
                            type: TextInputType.streetAddress,
                            prefix: Icons.place_outlined,
                            validate: (value){
                              if(value == null || value.isEmpty){
                                return 'Address must not be empty';
                              }
                              if(value.contains('(') || value.contains(')')) {
                                return 'Don\'t use brackets ()';
                              }
                              bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s]+$').hasMatch(value);
                              if(!nameValid) {
                                return 'Enter a valid address (city or district) without numbers and without (,.-_)';
                              }
                              return null;
                            }),
                        if((widget.userData != null && (widget.userData?.role == 'Doctor')))
                         const SizedBox(
                           height: 30.0,
                         ),
                          if((widget.userData != null && (widget.userData?.role == 'Doctor')))
                          defaultFormField(
                              text: 'Speciality',
                              controller: specialityController,
                              type: TextInputType.text,
                              prefix: EvaIcons.fileTextOutline,
                              focusNode: focusNode4,
                              validate: (value){
                                if(value == null || value.isEmpty){
                                  return 'Speciality must not be empty';
                                }
                                bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s,._]+$').hasMatch(value);
                                if(!nameValid) {
                                  return 'Enter a valid name without numbers';
                                }
                                return null;
                              }),
                        if((widget.userData != null && (widget.userData?.role == 'Pharmacist')))
                          const SizedBox(
                            height: 30.0,
                          ),
                        if((widget.userData != null && (widget.userData?.role == 'Pharmacist')))
                          defaultFormField(
                              text: 'Pharmacy Name',
                              controller: namePharmacyController,
                              type: TextInputType.text,
                              focusNode: focusNode5,
                              prefix: Icons.local_pharmacy_outlined,
                              validate: (value){
                                if(value == null || value.isEmpty){
                                  return 'Pharmacy Name must not be empty';
                                }
                                bool validName = RegExp(r'^\w+ pharmacy$').hasMatch(value);
                                if(!validName) {
                                  return 'Enter a valid name --> nameOfPharmacy pharmacy \nAvoid space after pharmacy';
                                }
                                if(value.contains('(') || value.contains(')')) {
                                  return 'Don\'t use brackets ()';
                                }
                                return null;
                              }),
                        if((widget.userData != null && (widget.userData?.role == 'Pharmacist')))
                          const SizedBox(
                            height: 30.0,
                          ),
                        if((widget.userData != null && (widget.userData?.role == 'Pharmacist')))
                          defaultFormField(
                              text: 'Local Address Pharmacy',
                              controller: addressController,
                              type: TextInputType.streetAddress,
                              prefix: Icons.place_outlined,
                              focusNode: focusNode6,
                              validate: (value){
                                if(value == null || value.isEmpty){
                                  return 'Local Address must not be empty';
                                }
                                bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s]+$').hasMatch(value);
                                if(!nameValid) {
                                  return 'Enter a valid address (city or district) without numbers and without (,.-_)';
                                }
                                if(value.contains('(') || value.contains(')')) {
                                  return 'Don\'t use brackets ()';
                                }
                                return null;
                              }),
                          const SizedBox(
                          height: 35.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                          ),
                          child: ConditionalBuilder(
                            condition: state is! LoadingUpdateProfileAppState,
                            builder: (context) => defaultButton2(
                                function: () {
                                  if(formKey.currentState!.validate()) {

                                    if((widget.userData != null && widget.userData?.role == 'Doctor')) {

                                      cubit.updateProfileDoctorData(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          specialty: specialityController.text,
                                          idUser: widget.userData?.userId,
                                          context: context);
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                      focusNode4.unfocus();

                                    } else if((widget.userData != null && widget.userData?.role == 'Pharmacist')) {

                                      cubit.updateProfilePharmacistData(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          pharmacyName: namePharmacyController.text,
                                          idUser: widget.userData?.userId,
                                          idPharmacy: widget.userData?.pharmacist?.pharmacy?.pharmacyId ,
                                          context: context);
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode5.unfocus();
                                      focusNode6.unfocus();

                                    }

                                  }

                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                  focusNode4.unfocus();
                                  focusNode5.unfocus();
                                  focusNode6.unfocus();

                                },
                                text: 'Update'.toUpperCase(),
                                context: context),
                            fallback: (context) => Center(child: IndicatorScreen(os: getOs())),
                          ),
                        ),
                      ],
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
  }
}
