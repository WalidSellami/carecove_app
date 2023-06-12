import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});


  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var specialityController = TextEditingController();
  var namePharmacyController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit , ThemeStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var themeCubit = ThemeCubit.get(context);


        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            var userProfile = cubit.profile;
            var doctorProfile = cubit.doctorProfile;
            var pharmacyProfile = cubit.pharmacyProfile;
            var patientProfile = cubit.patientProfile;
            var adminProfile = cubit.adminProfile;

            nameController.text = (userProfile?.user?.name).toString();
            phoneController.text = (userProfile?.user?.phone).toString();

            if(userProfile?.user?.role == 'Doctor') {

              addressController.text = (doctorProfile?.doctor?.localAddress).toString();
              specialityController.text = (doctorProfile?.doctor?.speciality).toString();

            }else if(userProfile?.user?.role == 'Pharmacist') {

              addressController.text = (pharmacyProfile?.pharmacy?.localAddress).toString();
              namePharmacyController.text = (pharmacyProfile?.pharmacy?.name).toString();

            } else if(userProfile?.user?.role == 'Patient') {

              addressController.text = (patientProfile?.patient?.address).toString();

            } else if(userProfile?.user?.role == 'Admin') {

              addressController.text = (adminProfile?.admin?.address).toString();

            }

            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Edit Profile',
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 58.0,
                              backgroundColor: themeCubit.isDark ? HexColor('2eb7c9') : HexColor('b3d8ff'),
                              child: CircleAvatar(
                                radius: 56.0,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 54.0,
                                  backgroundColor: themeCubit.isDark ? HexColor('2eb7c9')  : HexColor('b3d8ff'),
                                  backgroundImage: (cubit.imageProfile == null) ?
                                  NetworkImage('${userProfile?.user?.profileImage}') :
                                   Image.file(File(cubit.imageProfile!.path)).image,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.5,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            CircleAvatar(
                              radius: 19.5,
                              backgroundColor: themeCubit.isDark ? HexColor('15909d') : HexColor('c1dfff'),
                              child: IconButton(
                                onPressed: () {
                                  if(cubit.imageProfile == null) {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Material(
                                              color: ThemeCubit.get(context).isDark ? HexColor('121212') : Colors.white,
                                              child: Wrap(
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: const Icon(Icons.camera_alt),
                                                    title: const Text('Take a new photo'),
                                                    onTap: () async {
                                                      cubit.getImageProfile(context , ImageSource.camera);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(Icons.photo_library),
                                                    title: const Text('Choose from gallery'),
                                                    onTap: () async{
                                                      cubit.getImageProfile(context , ImageSource.gallery);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                   cubit.removeImageProfile();
                                  }
                                },
                                icon: Icon(
                                  (cubit.imageProfile == null) ? Icons.camera_alt_outlined : Icons.close_rounded,
                                  color: themeCubit.isDark ? Colors.grey.shade100 : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32.0,
                        ),
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
                        if(userProfile?.user?.role == 'Patient' || userProfile?.user?.role == 'Admin')
                        const SizedBox(
                          height: 30.0,
                        ),
                        if(userProfile?.user?.role == 'Patient' || userProfile?.user?.role == 'Admin')
                          defaultFormField(
                            text: 'address',
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
                        if(userProfile?.user?.role == 'Doctor')
                          const SizedBox(
                            height: 30.0,
                          ),
                        if(userProfile?.user?.role == 'Doctor')
                          defaultFormField(
                              text: 'Local Address Work',
                              controller: addressController,
                              type: TextInputType.text,
                              prefix: Icons.place_outlined,
                              focusNode: focusNode4,
                              validate: (value){
                                if(value == null || value.isEmpty){
                                  return 'Local Address Work must not be empty';
                                }
                                if(value.contains('(') || value.contains(')')) {
                                  return 'Don\'t use brackets ()';
                                }
                                bool validName = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s,._]+$').hasMatch(value);
                                if(!validName) {
                                  return 'Enter a valid address , Don\'t enter only numbers';
                                }
                                return null;
                              }),
                        if(userProfile?.user?.role == 'Doctor')
                          const SizedBox(
                            height: 30.0,
                          ),
                        if(userProfile?.user?.role == 'Doctor')
                          defaultFormField(
                              text: 'Speciality',
                              controller: specialityController,
                              type: TextInputType.text,
                              prefix: EvaIcons.fileTextOutline,
                              focusNode: focusNode5,
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
                        if(userProfile?.user?.role == 'Pharmacist')
                          const SizedBox(
                            height: 30.0,
                          ),
                        if(userProfile?.user?.role == 'Pharmacist')
                          defaultFormField(
                              text: 'Pharmacy Name',
                              controller: namePharmacyController,
                              type: TextInputType.text,
                              focusNode: focusNode6,
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
                        if(userProfile?.user?.role == 'Pharmacist')
                          const SizedBox(
                            height: 30.0,
                          ),
                        if(userProfile?.user?.role == 'Pharmacist')
                          defaultFormField(
                              text: 'Local Address Pharmacy',
                              controller: addressController,
                              type: TextInputType.streetAddress,
                              prefix: Icons.place_outlined,
                              focusNode: focusNode7,
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
                        ConditionalBuilder(
                          condition: state is! LoadingUpdateProfileAppState,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: defaultButton2(
                                function: () {
                                  if(CheckCubit.get(context).hasInternet) {
                                    if(formKey.currentState!.validate()){

                                      if((userProfile?.user?.role == 'Doctor') && (cubit.imageProfile == null)) {
                                        cubit.updateProfileDoctor(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          specialty: specialityController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode4.unfocus();
                                        focusNode5.unfocus();

                                      }else if((userProfile?.user?.role == 'Doctor') && (cubit.imageProfile != null)) {

                                        cubit.updateProfileDoctorWithImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          specialty: specialityController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode4.unfocus();
                                        focusNode5.unfocus();

                                      }else if((userProfile?.user?.role == 'Pharmacist') && (cubit.imageProfile == null)) {

                                        cubit.updateProfilePharmacist(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          pharmacyName: namePharmacyController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode6.unfocus();
                                        focusNode7.unfocus();

                                      }else if((userProfile?.user?.role == 'Pharmacist') && (cubit.imageProfile != null)) {

                                        cubit.updateProfilePharmacistWithImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          localAddress: addressController.text,
                                          pharmacyName: namePharmacyController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode6.unfocus();
                                        focusNode7.unfocus();

                                      }else if((userProfile?.user?.role == 'Patient') && (cubit.imageProfile == null)) {

                                        cubit.updateProfilePatient(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode3.unfocus();

                                      }else if((userProfile?.user?.role == 'Patient') && (cubit.imageProfile != null)) {

                                        cubit.updateProfilePatientWithImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode3.unfocus();

                                      }else if((userProfile?.user?.role == 'Admin') && (cubit.imageProfile == null)) {

                                        cubit.updateProfileAdmin(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          idUser: userId,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode3.unfocus();

                                      }else if((userProfile?.user?.role == 'Admin') && (cubit.imageProfile != null)) {

                                        cubit.updateProfileAdminWithImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          context: context,
                                        );

                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode3.unfocus();

                                      }


                                    }

                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    focusNode4.unfocus();
                                    focusNode5.unfocus();
                                    focusNode6.unfocus();
                                    focusNode7.unfocus();

                                  } else {

                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    focusNode4.unfocus();
                                    focusNode5.unfocus();
                                    focusNode6.unfocus();
                                    focusNode7.unfocus();
                                    showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                                  }


                                },
                                text: 'Update',
                                context: context),
                          ),
                          fallback: (context) => Center(child: IndicatorScreen(os: getOs())),
                        )
                      ],
                    ),
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
