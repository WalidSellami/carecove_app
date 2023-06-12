import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/modules/doctor/medicationsStocksScreen/MedicationsStocksScreen.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';

class StocksScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).checkAccountUser();
      AppCubit.get(context).getAllPharmacies();
      return BlocConsumer<CheckCubit , CheckStates>(
        listener: (context , state) {},
        builder: (context , state) {

          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<ThemeCubit, ThemeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var themeCubit = ThemeCubit.get(context);

              return BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = AppCubit.get(context);
                  var pharmacies = cubit.pharmaciesModel;

                  return Scaffold(
                    body: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: ((pharmacies?.pharmacies.length ?? 0) > 0),
                      builder: (context) => RefreshIndicator(
                        key: _refreshIndicatorKey,
                        color: themeCubit.isDark
                            ? HexColor('21b8c9')
                            : HexColor('0571d5'),
                        backgroundColor:
                        themeCubit.isDark ? HexColor('181818') : Colors.white,
                        strokeWidth: 2.5,
                        onRefresh: () async {
                          if(checkCubit.hasInternet) {
                            cubit.getAllPharmacies();
                          }
                          return Future<void>.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildItemStock(
                              pharmacies!.pharmacies[index], context),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 4.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: pharmacies?.pharmacies.length ?? 0,
                        ),
                      ),
                      fallback: (context) =>
                      (state is LoadingGetAllDoctorsAppState ||
                          pharmacies == null)
                          ? Center(child: IndicatorScreen(os: getOs()))
                          : const Center(
                        child: Text(
                          'There is no pharmacies',
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
    });
  }

  Widget buildItemStock(PharmacyDataModel model, context) => InkWell(
        onTap: () {
          // if(CheckCubit.get(context).hasInternet) {
          AppCubit.get(context).clearMedicationsStock();
            AppCubit.get(context)
                .getAllMedicationsFromStockPharmacy(idPharmacy: model.pharmacyId);
            Navigator.of(context).push(_createGetMedicationsPharmacyRoute(model));
          // } else {
          //   showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
          // }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ThemeCubit.get(context).isDark
                      ? HexColor('1599a6')
                      : HexColor('b3d8ff'),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Icon(
                  Icons.medication_rounded,
                  color: ThemeCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.pharmacyName}',
                      maxLines: 1,
                      // textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '${model.localAddress}',
                      maxLines: 1,
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

Route _createGetMedicationsPharmacyRoute(pharmacy) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MedicationsStocksScreen(pharmacy: pharmacy),
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
