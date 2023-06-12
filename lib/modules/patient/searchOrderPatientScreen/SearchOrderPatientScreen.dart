import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/DataModels/orderModel/OrderModel.dart';
import 'package:project_final/modules/patient/ordersStatusDetailsScreen/OrderStatusDetailsScreen.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SearchOrderPatientScreen extends StatefulWidget {
  const SearchOrderPatientScreen({super.key});

  @override
  State<SearchOrderPatientScreen> createState() => _SearchOrderPatientScreenState();
}

class _SearchOrderPatientScreenState extends State<SearchOrderPatientScreen> {

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

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var cubit = AppCubit.get(context);
            var orders = cubit.orderModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if(orders == null) {
                      cubit.getPatientOrders();
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
                          'Type name pharmacy ...',
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
                            cubit.clearSearchOrderPatient();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ) : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchOrderPatient(value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (orders?.orders.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) =>
                            buildItemStatusOrder(orders!.orders[index] , context),
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
  Widget buildItemStatusOrder(OrderData model, context) => Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        right: 8.0,
        left: 8.0,
        bottom: 4.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.medication_rounded,
                  color: ThemeCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                '${model.pharmacy?.pharmacyName}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6.0,
          ),
          Row(
            children: [
              Icon(EvaIcons.pinOutline,
                  color: ThemeCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                '${model.pharmacy?.localAddress}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14.0,
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(
              text: 'Your Order is : ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '${model.status}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (model.status == 'Accepted')
                    ? HexColor('1599a6')
                    : ((model.status == 'En hold')
                    ? Colors.amber.shade700
                    : HexColor('f9325f')),
              ),
            ),
          ])),
          const SizedBox(
            height: 4.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(_createDetailsOrderRoute(model));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'More Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Route _createDetailsOrderRoute(orderData) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OrderStatusDetailsScreen(order: orderData),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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
