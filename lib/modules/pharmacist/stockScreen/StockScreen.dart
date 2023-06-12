import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/modules/doctor/detailsMedicationStockScreen/DetailsMedicationStockScreen.dart';
import 'package:project_final/modules/pharmacist/editMedicationInStock/EditMedicationInStockScreen.dart';
import 'package:project_final/modules/pharmacist/medicationsScreen/MedicationScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  bool isScrolled = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppCubit.get(context).checkAccountUser();
    if (pharmacyId == null) {
      AppCubit.get(context).getProfilePharmacist();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (pharmacyId != null) {
        AppCubit.get(context).getAllMedicationsFromStock();
      }
      return BlocConsumer<CheckCubit, CheckStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<ThemeCubit, ThemeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var themeCubit = ThemeCubit.get(context);

              return BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {
                  if (state is SuccessGetProfilePharmacistAppState &&
                      pharmacistId == null) {
                    CacheHelper.saveData(
                            key: 'pharmacistId',
                            value: state
                                .pharmacistProfile.pharmacist?.pharmacistId)
                        .then((value) {
                      pharmacistId =
                          state.pharmacistProfile.pharmacist?.pharmacistId;
                    });

                    CacheHelper.saveData(
                            key: 'pharmacyId',
                            value:
                                state.pharmacistProfile.pharmacist?.pharmacyId)
                        .then((value) {
                      pharmacyId =
                          state.pharmacistProfile.pharmacist?.pharmacyId;
                      AppCubit.get(context).getPharmacy();
                    });
                  }

                  if (state is SuccessGetPharmacyAppState) {
                    AppCubit.get(context).getAllMedicationsFromStock();
                  }

                  if (state is SuccessDeleteMedicationFromStockAppState) {
                    if (state.simpleModel.status == true) {
                      showFlutterToast(
                          message: '${state.simpleModel.message}',
                          state: ToastStates.success,
                          context: context);
                      AppCubit.get(context).getAllMedicationsFromStock();
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
                  var medicationsStock = cubit.medicationsStockModel;
                  var userProfile = cubit.profile;
                  var pharmacy = cubit.pharmacyProfile;

                  List<int?>? pharmacists = pharmacy?.pharmacy?.pharmacists
                      .map((e) => e.user?.userId)
                      .toList();
                  pharmacists?.remove(userId);

                  return Scaffold(
                    body: (checkCubit.hasInternet)
                        ? ConditionalBuilder(
                            condition:
                                ((medicationsStock?.medicationsStock.length ??
                                        0) >
                                    0),
                            builder: (context) =>
                                NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                if (notification.direction ==
                                    ScrollDirection.forward) {
                                  setState(() {
                                    isScrolled = true;
                                  });
                                } else if (notification.direction ==
                                    ScrollDirection.reverse) {
                                  setState(() {
                                    isScrolled = false;
                                  });
                                }

                                return true;
                              },
                              child: RefreshIndicator(
                                key: _refreshIndicatorKey,
                                color: themeCubit.isDark
                                    ? HexColor('21b8c9')
                                    : HexColor('0571d5'),
                                backgroundColor: themeCubit.isDark
                                    ? HexColor('181818')
                                    : Colors.white,
                                strokeWidth: 2.5,
                                onRefresh: () async {
                                  cubit.getAllMedicationsFromStock();
                                  return Future<void>.delayed(
                                      const Duration(seconds: 2));
                                },
                                child: ListView.builder(
                                  itemBuilder: (context, index) =>
                                      buildItemMedicationStock(
                                          medicationsStock!
                                              .medicationsStock[index],
                                          context,
                                          userProfile?.user?.name,
                                          pharmacists),
                                  itemCount: medicationsStock
                                          ?.medicationsStock.length ??
                                      0,
                                ),
                              ),
                            ),
                            fallback: (context) => (state
                                        is LoadingGetProfilePharmacistAppState ||
                                    state is LoadingGetPharmacyAppState ||
                                    state
                                        is LoadingGetAllMedicationsFromStockAppState ||
                                    medicationsStock == null)
                                ? Center(child: IndicatorScreen(os: getOs()))
                                : const Center(
                                    child: Text(
                                      'There is no medications',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          )
                        : const Center(
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
                    floatingActionButton:
                        ((medicationsStock?.medicationsStock != null) &&
                                (checkCubit.hasInternet))
                            ? Visibility(
                                visible: isScrolled,
                                child: Container(
                                  height: 55.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: FloatingActionButton.extended(
                                      isExtended: true,
                                      icon: Icon(
                                        EvaIcons.editOutline,
                                        color: ThemeCubit.get(context).isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      backgroundColor:
                                          ThemeCubit.get(context).isDark
                                              ? HexColor('15909d')
                                              : HexColor('c1dfff'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(_createMedicationsRoute());
                                      },
                                      label: Text(
                                        'New medication',
                                        style: TextStyle(
                                          color: ThemeCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              )
                            : null,
                  );
                },
              );
            },
          );
        },
      );
    });
  }
}

Widget buildItemMedicationStock(
        MedicationStockData model, context, pharmacist, pharmacists) =>
    GestureDetector(
      onTap: () {
        navigatorTo(
            context: context,
            screen: DetailsMedicationStockScreen(medication: model));
      },
      child: Card(
        elevation: 4.0,
        shape: ((model.quantity == 0) ||
                (model.dateManufacture.toString() ==
                    model.dateExpiration.toString()))
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  width: 1.0,
                  color: HexColor('f9325f'),
                ),
              )
            : null,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showImage(context, model.stockId.toString(),
                          model.medicationImage);
                    },
                    child: Hero(
                      tag: model.stockId.toString(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: ThemeCubit.get(context).isDark
                              ? null
                              : Border.all(
                                  width: 0.0,
                                  color: Colors.grey.shade900,
                                ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: ThemeCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  width: 120.0,
                                  height: 100.0,
                                  child: Center(
                                      child: IndicatorRingScreen(os: getOs())));
                            }
                          },
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return child;
                          },
                          '${model.medicationImage}',
                          height: 100.0,
                          width: 120.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                                width: 120.0,
                                height: 100.0,
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
                                    fontSize: 13.0,
                                  ),
                                )));
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${model.medication?.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '${model.medication?.description}',

                            maxLines: 2,

                            // overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 15.0,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.grey
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                '${model.dateManufacture}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: (model.dateManufacture.toString() ==
                                          model.dateExpiration.toString())
                                      ? HexColor('f9325f')
                                      : (ThemeCubit.get(context).isDark
                                          ? Colors.grey
                                          : Colors.grey.shade600),
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
                                    color: ThemeCubit.get(context).isDark
                                        ? Colors.grey
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Text(
                                '${model.dateExpiration}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: (model.dateManufacture.toString() ==
                                          model.dateExpiration.toString())
                                      ? HexColor('f9325f')
                                      : (ThemeCubit.get(context).isDark
                                          ? Colors.grey
                                          : Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        (model.quantity > 1)
                            ? Text(
                                '${model.quantity} pieces',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark
                                      ? Colors.grey
                                      : Colors.grey.shade600,
                                ),
                              )
                            : Text(
                                '${model.quantity} piece',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: (model.quantity == 0)
                                      ? HexColor('f9325f')
                                      : (ThemeCubit.get(context).isDark
                                          ? Colors.grey
                                          : Colors.grey.shade600),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  defaultNewButton(
                      toolTip: 'Edit',
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      padding: 11.0,
                      icon: EvaIcons.editOutline,
                      colorIcon: ThemeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                      onPress: () {
                        Navigator.of(context)
                            .push(_createEditMedicationInStockRoute(model));
                      }),
                  const SizedBox(
                    width: 20.0,
                  ),
                  defaultNewButton(
                      toolTip: 'Remove',
                      color: HexColor('f9325f'),
                      padding: 11.0,
                      icon: EvaIcons.close,
                      colorIcon: Colors.white,
                      onPress: () {
                        showAlert(
                            context, model.stockId, pharmacist, pharmacists);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );

Route _createMedicationsRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MedicationsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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

Route _createEditMedicationInStockRoute(medication) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EditMedicationInStockScreen(medicationStock: medication),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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

dynamic showAlert(BuildContext context, id, pharmacist, pharmacists) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Do you want to remove this medication ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19.0,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showLoading(context);
                AppCubit.get(context).deleteMedicationStock(
                    stockId: id, body: pharmacist, idUser: pharmacists);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16.0,
                  color: HexColor('f9325f'),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}

dynamic showLoading(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: ThemeCubit.get(context).isDark
                    ? Colors.grey.shade900
                    : Colors.white,
              ),
              child: IndicatorScreen(os: getOs())),
        );
      });
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
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                width: double.infinity,
                height: 450.0,
                // fit: BoxFit.cover,
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
