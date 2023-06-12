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

class SearchOrderScreen extends StatefulWidget {
  const SearchOrderScreen({super.key});

  @override
  State<SearchOrderScreen> createState() => _SearchOrderScreenState();
}

class _SearchOrderScreenState extends State<SearchOrderScreen> {

  var searchOrderController = TextEditingController();

  @override
  void initState() {
    searchOrderController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return  BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {

            if(state is SuccessAcceptOrderAppState) {

              if(state.simpleModel.status == true) {

                AppCubit.get(context).getPharmacyOrders();
                Future.delayed(const Duration(milliseconds: 350)).then((value) {
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                });

              } else {

                showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);

              }
            }
          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);
            var orders = cubit.orderModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if(orders == null) {
                      cubit.getPharmacyOrders();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Order',
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 14.0,
                    ),
                    child: TextFormField(
                      controller: searchOrderController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Type name doctor ...',
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(
                          EvaIcons.searchOutline,
                        ),
                        suffixIcon: searchOrderController.text.isNotEmpty ?
                        IconButton(
                          onPressed: () {
                            searchOrderController.text = '';
                            cubit.clearSearchOrder();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ) : null,
                      ),
                      onChanged: (String value) {
                        cubit.searchOrder(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (orders?.orders.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) =>
                            buildItemOrder(orders!.orders[index]),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: orders?.orders.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no order',
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
                  ),
                ],
              ),
            );
          },
        );
      },
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
                    : HexColor('c1dfff'),
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
