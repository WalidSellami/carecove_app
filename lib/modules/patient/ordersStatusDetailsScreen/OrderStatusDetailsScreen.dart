import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/DataModels/orderModel/OrderModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class OrderStatusDetailsScreen extends StatelessWidget {
  final OrderData? order;
  const OrderStatusDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: defaultAppBar(context: context, title: 'Order Details'),
              body: (checkCubit.hasInternet) ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Name : ',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          '${order?.prescription?.card?.patient?.user?.name}',
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          'From : ',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          '${order?.prescription?.card?.patient?.address}',
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                        text: 'Your Order is : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                      TextSpan(
                        text: '${order?.status}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: (order?.status == 'Accepted')
                              ? HexColor('1599a6')
                              : ((order?.status == 'En hold')
                              ? Colors.amber.shade700
                              : HexColor('f9325f')),
                        ),
                      ),
                    ])),
                    if (order?.status == 'Accepted')
                      const SizedBox(
                        height: 16.0,
                      ),
                    if (order?.status == 'Accepted')
                      const Text(
                        '* We will contact you about the price and delivery of your medications.',
                        style: TextStyle(
                          fontSize: 15.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (order?.status == 'Accepted')
                      const SizedBox(
                        height: 20.0,
                      ),
                    if (order?.status == 'Accepted')
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          '* Your Medications : ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (order?.status == 'Accepted')
                      const SizedBox(
                        height: 14.0,
                      ),
                    if (order?.status == 'Accepted')
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                buildItemMedicationOrderDetails(
                                    order!.prescription!
                                        .prescriptionMedications[index],
                                    context),
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 10.0,
                            ),
                            itemCount: order?.prescription?.prescriptionMedications
                                .length ??
                                0),
                      ),
                  ],
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

  Widget buildItemMedicationOrderDetails(
          PrescriptionMedicationsOrderData model, context) =>
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        child: Row(
          children: [
            Icon(
              EvaIcons.arrowRight,
              color:
                  ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              '${model.quantity}',
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' -> ${model.medication?.name}',
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
