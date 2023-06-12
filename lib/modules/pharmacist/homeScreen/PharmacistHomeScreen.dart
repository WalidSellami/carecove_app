import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/orderModel/OrderModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class PharmacistHomeScreen extends StatefulWidget {
  const PharmacistHomeScreen({super.key});

  @override
  State<PharmacistHomeScreen> createState() => _PharmacistHomeScreenState();
}

class _PharmacistHomeScreenState extends State<PharmacistHomeScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppCubit.get(context).getProfile();
    AppCubit.get(context).getProfilePharmacist();
    AppCubit.get(context).checkAccountUser();
    pharmacistId = CacheHelper.getData(key: 'pharmacistId');
    pharmacyId = CacheHelper.getData(key: 'pharmacyId');


    if (pharmacyId != null) {
      AppCubit.get(context).getPharmacy();
      AppCubit.get(context).getPharmacyOrders();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(pharmacyId != null) {
          AppCubit.get(context).getPharmacy();
          AppCubit.get(context).getPharmacyOrders();
        }
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<ThemeCubit, ThemeStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var themeCubit = ThemeCubit.get(context);

                return BlocConsumer<AppCubit, AppStates>(
                  listener: (context, state) {

                    // if (state is SuccessSendNotificationAppState) {
                    //   if ((AppCubit.get(context).title == 'New Order') &&
                    //       (AppCubit.get(context).id == userId) &&
                    //       CheckCubit.get(context).hasInternet) {
                    //     AppCubit.get(context)
                    //         .getPharmacyOrders();
                    //   }
                    // }

                    if ((state is SuccessGetProfilePharmacistAppState) &&
                        (pharmacistId == null)) {
                      CacheHelper.saveData(
                          key: 'pharmacistId',
                          value: state.pharmacistProfile.pharmacist?.pharmacistId)
                          .then((value) {
                        pharmacistId = state.pharmacistProfile.pharmacist?.pharmacistId;
                      });

                      CacheHelper.saveData(
                          key: 'pharmacyId',
                          value: state.pharmacistProfile.pharmacist?.pharmacyId)
                          .then((value) {
                        pharmacyId = state.pharmacistProfile.pharmacist?.pharmacyId;

                        AppCubit.get(context).getPharmacy();
                        AppCubit.get(context).getPharmacyOrders();
                      });
                    }

                    if(state is SuccessAcceptOrderAppState) {

                      if(state.simpleModel.status == true) {

                        AppCubit.get(context).getPharmacyOrders();
                        Future.delayed(const Duration(milliseconds: 350)).then((value) {
                          Navigator.pop(context);
                        });

                      } else {

                        showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);

                      }
                    }

                    if(state is SuccessRefuseOrderAppState) {

                      if(state.simpleModel.status == true) {

                        AppCubit.get(context).getPharmacyOrders();
                        Future.delayed(const Duration(milliseconds: 350)).then((value) {
                          Navigator.pop(context);
                        });

                      } else {

                        showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);

                      }
                    }
                  },
                  builder: (context, state) {
                    var cubit = AppCubit.get(context);
                    var orders = cubit.orderModel;

                    return Scaffold(
                      body: (checkCubit.hasInternet) ? ConditionalBuilder(
                        condition: (orders?.orders.length ?? 0) > 0,
                        builder: (context) => RefreshIndicator(
                          key: refreshIndicator,
                          color: themeCubit.isDark
                              ? HexColor('21b8c9')
                              : HexColor('0571d5'),
                          backgroundColor:
                          themeCubit.isDark ? HexColor('181818') : Colors.white,
                          strokeWidth: 2.5,
                          onRefresh: () async {
                            if(checkCubit.hasInternet) {
                              cubit.getPharmacyOrders();
                            }
                            return Future<void>.delayed(const Duration(seconds: 2));
                          },
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                buildItemOrder(orders!.orders[index]),
                            itemCount: orders?.orders.length ?? 0,
                          ),
                        ),
                        fallback: (context) =>
                        (state is LoadingGetOrdersAppState || orders == null)
                            ? Center(child: IndicatorScreen(os: getOs()))
                            : const Center(
                          child: Text(
                            'There is no orders',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
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
          },
        );
      }
    );
  }

  Widget buildItemOrder(OrderData model) => Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 12.0,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  bottom: 16.0,
                ),
                child: Text(
                  'Doctor ${model.prescription?.card?.doctor?.user?.name}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Patient Name : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                  Text(
                    '${model.prescription?.card?.patient?.user?.name}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              Row(
                children: [
                  const Text(
                    'Patient Phone : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                  Text(
                    '${model.prescription?.card?.patient?.user?.phone}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              Row(
                children: [
                  const Text(
                    'Patient Address : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                  Text(
                    '${model.prescription?.card?.patient?.address}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              Row(
                children: [
                  const Text(
                    'Date : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                  Text(
                    '${model.orderDate}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.medication,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    'Medications :',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildItemMedicationOrder(
                      model.prescription!.prescriptionMedications[index]),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 12.0,
                      ),
                  itemCount:
                      model.prescription?.prescriptionMedications.length ?? 0),
              const SizedBox(
                height: 10.0,
              ),
              (model.status == 'En hold')
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 3.0,
                          color: HexColor('f9325f'),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              showLoading(context);
                              AppCubit.get(context)
                                  .refuseOrder(
                                  orderId: model.orderId,
                                  body: model.pharmacy?.pharmacyName ?? '',
                                  idUserPatient: model.prescription?.card?.patient?.user?.userId,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(13.0),
                              child: const Text(
                                'Refuse',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 14.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 3.0,
                          color: ThemeCubit.get(context).isDark
                              ? HexColor('15909d')
                              : HexColor('b3d8ff'),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              showLoading(context);
                              AppCubit.get(context)
                                  .acceptOrder(
                                  orderId: model.orderId,
                                  body: model.pharmacy?.pharmacyName ?? '',
                                  idUserPatient: model.prescription?.card?.patient?.user?.userId,
                              );
                              String medications = model
                                  .prescription!.prescriptionMedications
                                  .map((e) => e.medicationId.toString())
                                  .toList()
                                  .join(',');
                              String quantities = model.prescription!.prescriptionMedications.map((e) => e.quantity.toString()).toList().join(',');
                              Future.delayed(const Duration(milliseconds: 1500)).then((value) {
                                AppCubit.get(context).decrementQuantityMedication(
                                    medications: medications,
                                    quantities: quantities,
                                    idPharmacy: pharmacyId ?? model.pharmacyId);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(13.0),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ((model.status == 'Accepted')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${model.status}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: HexColor('1599a6'),
                              ),
                            ),
                            Icon(
                              EvaIcons.doneAllOutline,
                              color: HexColor('1599a6'),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${model.status}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: HexColor('f9325f'),
                              ),
                            ),
                            Icon(
                              Icons.close_rounded,
                              color: HexColor('f9325f'),
                            ),
                          ],
                        )),
            ],
          ),
        ),
      );

  Widget buildItemMedicationOrder(PrescriptionMedicationsOrderData model) =>
      Row(
        children: [
          Icon(
            EvaIcons.arrowRight,
            color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            '${model.quantity} -> ',
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${model.medication?.name}',
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

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
}
