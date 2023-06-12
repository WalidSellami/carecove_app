import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class EditMedicationInStockScreen extends StatefulWidget {
  final MedicationStockData medicationStock;
  const EditMedicationInStockScreen({super.key, required this.medicationStock});

  @override
  State<EditMedicationInStockScreen> createState() =>
      _EditMedicationInStockScreenState();
}

class _EditMedicationInStockScreenState
    extends State<EditMedicationInStockScreen> {
  var quantityController = TextEditingController();
  var dateManufactureController = TextEditingController();
  var dateExpirationController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  @override
  void initState() {
    quantityController.text = widget.medicationStock.quantity.toString();
    dateManufactureController.text =
        widget.medicationStock.dateManufacture.toString();
    dateExpirationController.text =
        widget.medicationStock.dateExpiration.toString();
    super.initState();
  }

  @override
  void dispose() {
    quantityController.dispose();
    dateManufactureController.dispose();
    dateExpirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessEditMedicationInStockAppState) {
          if (state.simpleModel.status == true) {
            showFlutterToast(
                message: '${state.simpleModel.message}',
                state: ToastStates.success,
                context: context);
            AppCubit.get(context).getAllMedicationsFromStock();
            AppCubit.get(context).removeMedicationImage();
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

        var userProfile = cubit.profile;
        var pharmacy = cubit.pharmacyProfile;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: '${widget.medicationStock.medication?.name}',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          if(value.contains('-') || value.contains('.')) {
                            return 'Enter a positive integer number';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: dateManufactureController,
                      keyboardType: TextInputType.number,
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
                      keyboardType: TextInputType.number,
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
                    Center(
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
                                    showImage(context, 'image', cubit.medicationImage , widget.medicationStock.medicationImage);
                                  },
                                  child: Hero(
                                    tag: 'image',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          width: 0.0,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: (cubit.medicationImage != null)
                                          ? Image.file(
                                              File(cubit.medicationImage!.path),
                                              width: 200.0,
                                              height: 180.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              '${widget.medicationStock.medicationImage}',
                                              width: 200.0,
                                              height: 180.0,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                    width: 200.0,
                                                    height: 180.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                        width: 1.0,
                                                        color:
                                                            ThemeCubit.get(context)
                                                                    .isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                        child: Text(
                                                            'Failed to load')));
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            (cubit.medicationImage != null)
                                ? GestureDetector(
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
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    if (cubit.medicationImage == null)
                      const SizedBox(
                        height: 12.0,
                      ),
                    (cubit.medicationImage == null)
                        ? Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                focusNode3.unfocus();
                                if(CheckCubit.get(context).hasInternet) {
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
                                                title: const Text(
                                                    'Take a new photo'),
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
                                } else {
                                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                }
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
                                'Update Image',
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
                        : Container(),
                    const SizedBox(
                      height: 35.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingEditMedicationInStockAppState,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: defaultButton2(
                            function: () {
                              if(CheckCubit.get(context).hasInternet) {
                                if(formKey.currentState!.validate()) {
                                  List<int?>? pharmacists = pharmacy?.pharmacy?.pharmacists.map((e) => e.user?.userId).toList();
                                  pharmacists?.remove(userId);
                                  if (cubit.medicationImage == null) {
                                    cubit.editMedicationInStock(
                                        stockId: widget.medicationStock.stockId,
                                        quantity: quantityController.text,
                                        dateManufacture:
                                        dateManufactureController.text,
                                        dateExpiration:
                                        dateExpirationController.text,
                                        body: (userProfile?.user?.name)!.toString(),
                                        idUser: pharmacists,
                                    );

                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                  } else {
                                    cubit.editMedicationInStockWithImage(
                                        stockId: widget.medicationStock.stockId,
                                        quantity: quantityController.text,
                                        dateManufacture:
                                        dateManufactureController.text,
                                        dateExpiration:
                                        dateExpirationController.text,
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
                                }
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                focusNode3.unfocus();
                              } else {
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                focusNode3.unfocus();
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }

                            },
                            text: 'Update',
                            context: context),
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
          ),
        );
      },
    );
  }

dynamic showImage(BuildContext context , tag , XFile? image , medicationImage) {

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
              child: (image != null) ? Image.file(File(image.path),
                width: double.infinity,
                height: 450.0,
                fit: BoxFit.fitWidth,
              ) : Image.network(
                '$medicationImage',
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                        width: double.infinity,
                        height: 450.0,
                        child: Center(
                            child: IndicatorRingScreen(
                              os: getOs(),
                            )));
                  }
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                width: double.infinity,
                height: 450.0,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                      width: double.infinity,
                      height: 450.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 1.0,
                          color: ThemeCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      child: const Center(
                          child: Text(
                            'Failed to load',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          )));
                },
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
