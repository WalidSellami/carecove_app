import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class AddMedicationInStockScreen extends StatefulWidget {
  final MedicationData medication;
  const AddMedicationInStockScreen({super.key, required this.medication});

  @override
  State<AddMedicationInStockScreen> createState() =>
      _AddMedicationInStockScreenState();
}

class _AddMedicationInStockScreenState
    extends State<AddMedicationInStockScreen> {
  var quantityController = TextEditingController();
  var dateManufactureController = TextEditingController();
  var dateExpirationController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  var scrollController = ScrollController();

  @override
  void dispose() {
    quantityController.dispose();
    dateManufactureController.dispose();
    dateExpirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessAddMedicationInStockAppState) {
              if (state.simpleModel.status == true) {
                showFlutterToast(
                    message: '${state.simpleModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context).getAllMedicationsFromStock();
                AppCubit.get(context).removeMedicationImage();
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                showFlutterToast(
                    message: '${state.simpleModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }

            if (state is SuccessGetMedicationImageAppState) {
              Future.delayed(const Duration(milliseconds: 100)).then((value) {
                setState(() {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              });
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var userProfile = cubit.profile;
            var pharmacy = cubit.pharmacyProfile;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (cubit.medicationImage != null) {
                      cubit.removeMedicationImage();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  tooltip: 'Back',
                ),
                title: Text(
                  '${widget.medication.name}',
                ),
              ),
              body: (checkCubit.hasInternet) ? SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Form(
                    key: formKey,
                    // autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description : ',
                          style: TextStyle(
                            fontSize: 17.5,
                            height: 1.8,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 6.0,
                          ),
                          child: Text(
                            '${widget.medication.description}',
                            style: const TextStyle(
                              fontSize: 16.5,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        const Text(
                          '* To add this medication fill the fields.',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultSimpleFormField(
                            text: 'Quantity',
                            controller: quantityController,
                            focusNode: focusNode1,
                            type: TextInputType.number,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Quantity must not be empty';
                              }
                              if (value == '0') {
                                return 'Quantity must be greater than 0';
                              }
                              if(value.substring(0,1) == '-') {
                                return 'Quantity must not be negative';
                              }
                              bool nameValid = RegExp(r'^[a-zA-Z]+$').hasMatch(value);
                              if(value.contains('-') || value.contains('.') || nameValid) {
                                return 'Enter a positive integer number';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: dateManufactureController,
                          keyboardType: TextInputType.datetime,
                          focusNode: focusNode2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          decoration: InputDecoration(
                            label: const Text(
                              'Date of Manufacture',
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
                              dateManufactureController.text =
                                  DateFormat("yyyy-MM-dd").format(value!);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of Manufacture must not be empty';
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
                        TextFormField(
                          controller: dateExpirationController,
                          keyboardType: TextInputType.datetime,
                          focusNode: focusNode3,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          decoration: InputDecoration(
                            label: const Text(
                              'Date of Expiration',
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
                              dateExpirationController.text =
                                  DateFormat("yyyy-MM-dd").format(value!);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of Expiration must not be empty';
                            }

                            if (value == dateManufactureController.text) {
                              return 'Date of Expiration must be different';
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
                        (cubit.medicationImage == null)
                            ? Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                              focusNode3.unfocus();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Material(
                                        color: ThemeCubit.get(context).isDark
                                            ? HexColor('121212')
                                            : Colors.white,
                                        child: Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.camera_alt),
                                              title:
                                              const Text('Take a photo'),
                                              onTap: () async {
                                                cubit.getMedicationImage(
                                                    context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library),
                                              title: const Text(
                                                  'Choose from gallery'),
                                              onTap: () async {
                                                cubit.getMedicationImage(
                                                    context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(
                              EvaIcons.imageOutline,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  ThemeCubit.get(context).isDark
                                      ? HexColor('158b96')
                                      : HexColor('c1dfff'),
                                ),
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(
                                    12.0,
                                  ),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ),
                                  ),
                                )),
                            label: Text(
                              'Add Image',
                              style: TextStyle(
                                fontSize: 15.5,
                                color: ThemeCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                            : Center(
                          child: SizedBox(
                            height: 220.0,
                            width: 230.0,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showImage(context,'image', cubit.medicationImage);
                                      },
                                      child: Hero(
                                        tag: 'image',
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            border: Border.all(
                                              width: 0.0,
                                              color: Colors.grey.shade900,
                                            ),
                                          ),
                                          clipBehavior:
                                          Clip.antiAliasWithSaveLayer,
                                          child: Image.file(
                                            File(cubit.medicationImage!.path),
                                            width: 200.0,
                                            height: 180.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.removeMedicationImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 18.0,
                                    backgroundColor:
                                    ThemeCubit.get(context).isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade300,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingAddMedicationInStockAppState,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: (cubit.medicationImage != null)
                                ? defaultButton2(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    List<int?>? pharmacists = pharmacy?.pharmacy?.pharmacists.map((e) => e.user?.userId).toList();
                                    pharmacists?.remove(userId);
                                    cubit.addMedicationInStock(
                                        quantity: quantityController.text,
                                        dateManufacture:
                                        dateManufactureController.text,
                                        dateExpiration:
                                        dateExpirationController.text,
                                        medicationId:
                                        widget.medication.medicationId,
                                        pharmacyId: pharmacyId,
                                        body: (userProfile?.user?.name)!.toString(),
                                        idUser: pharmacists,
                                    );
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                  }
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                },
                                text: 'Add',
                                context: context)
                                : null,
                          ),
                          fallback: (context) =>
                              Center(child: IndicatorScreen(os: getOs())),
                        ),
                        const SizedBox(
                          height: 12.0,
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

  dynamic showImage(BuildContext context , tag , XFile? image) {

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: defaultAppBar(
            context: context),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Hero(
              tag: tag,
              child: Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.file(File(image!.path),
                  width: double.infinity,
                  height: 455.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      );
    }

    )
    );

  }


}

