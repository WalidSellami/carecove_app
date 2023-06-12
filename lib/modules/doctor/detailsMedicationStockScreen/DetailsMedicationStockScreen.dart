import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class DetailsMedicationStockScreen extends StatelessWidget {
  final MedicationStockData medication;
  const DetailsMedicationStockScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: '${medication.medication?.name}',
          ),
          body: (checkCubit.hasInternet) ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showImage(context, 'image', medication.medicationImage);
                    },
                    child: Hero(
                      tag: 'image',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: ThemeCubit.get(context).isDark ? null : Border.all(
                            width: 0.0,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          '${medication.medicationImage}',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                width: double.infinity,
                                height: 250.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: ThemeCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                child:
                                Center(child: IndicatorRingScreen(os: getOs())),
                              );
                            }
                          },
                          width: double.infinity,
                          height: 250.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                                width: double.infinity,
                                height: 250.0,
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
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Text(
                        '${medication.dateManufacture}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: (medication.dateManufacture.toString() == medication.dateExpiration.toString()) ? HexColor('f9325f') : (ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          '||',
                          style: TextStyle(
                              fontSize: 14.0,
                            color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${medication.dateExpiration}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: (medication.dateManufacture.toString() == medication.dateExpiration.toString()) ? HexColor('f9325f') : (ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600),
                        ),
                      ),
                      const Spacer(),
                      (medication.quantity > 1) ? Text(
                        '${medication.quantity} pieces',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: (ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                          fontWeight: FontWeight.bold,
                        ),
                      ) : Text(
                        '${medication.quantity} piece',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: (medication.quantity == 0) ? HexColor('f9325f') : (ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
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
                      '${medication.medication?.description}',
                      style: const TextStyle(
                        fontSize: 16.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
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
  }

  dynamic showImage(BuildContext context, String tag, medicationImage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: defaultAppBar(context: context),
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
                child: Image.network(
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
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
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
    }));
  }
}
