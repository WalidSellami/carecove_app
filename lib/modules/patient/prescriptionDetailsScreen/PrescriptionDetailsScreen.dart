import 'dart:ui' as ui;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:project_final/model/DataModels/cardModel/CardPatientModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/model/profileModel/profilePatientModel/ProfilePatientModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class PrescriptionDetailsScreen extends StatefulWidget {

  final CardsPatientData? card;
  final ProfilePatientModel? patient;
  final PrescriptionData prescription;

  const PrescriptionDetailsScreen({super.key , required this.card , required this.patient , required this.prescription});

  @override
  State<PrescriptionDetailsScreen> createState() => _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {

  GlobalKey globalKey = GlobalKey();

  Future<void> captureAndSaveImage() async {
    double devicePixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;

    try {

      await Future.delayed(const Duration(milliseconds: 300)).then((value) async {

        RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
        ui.Image? image = await boundary.toImage(pixelRatio: devicePixelRatio);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? pngBytes = byteData?.buffer.asUint8List();

        // Save the image to the device's gallery
        await ImageGallerySaver.saveImage(pngBytes!);


        showAlert(context);

      });



    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      showFlutterToast(message: e.toString(), state: ToastStates.error, context: context);

    }

  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return  BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            return Scaffold(
              appBar: defaultAppBar(
                  context: context,
                  actions: [
                    if(checkCubit.hasInternet)
                    Tooltip(
                      message: 'Save',
                      child: TextButton(
                        onPressed: () async {
                          await captureAndSaveImage();
                        },
                        child: const Icon(
                          Icons.save_alt_rounded,
                        ),
                      ),
                    ),
                    if(checkCubit.hasInternet)
                    const SizedBox(
                      width: 6.0,
                    ),
                  ]
              ),
              body: (checkCubit.hasInternet) ? Center(
                child: SingleChildScrollView(
                  child: buildItemPrescription(widget.prescription),
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

  buildItemPrescription(PrescriptionData model) => RepaintBoundary(
    key: globalKey,
    child: Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            Text(
              'Doctor ${widget.card?.doctor?.user?.name}',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 17.0,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 4.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Date :',
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    '${model.prescriptionDate}',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        EvaIcons.fileTextOutline,
                        size: 26.0,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        'Informations :',
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${widget.patient?.patient?.user?.name}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Age',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '${widget.card?.age}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    child: Divider(
                      thickness: 0.6,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              'Medication',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              'Dosage',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          buildItemPrescriptionMedication(
                              model.prescriptionMedications[index] , context),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 14.0,
                      ),
                      itemCount: model.prescriptionMedications.length),
                ],
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
          ],
        ),
      ),
    ),
  );

  buildItemPrescriptionMedication(PrescriptionMedicationsData model , context) =>
      Row(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.medication?.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          if(model.dosage.toString().length < 12)
            Expanded(
            flex: 2,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${model.dosage}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          if(model.dosage.toString().length > 12)
            Expanded(
            flex: 2,
            child: Text(
              '${model.dosage}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      );


  dynamic showAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              'Image Saved',
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'The prescription has been saved to your gallery.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
