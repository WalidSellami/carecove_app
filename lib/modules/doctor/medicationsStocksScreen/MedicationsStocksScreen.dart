import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/modules/doctor/detailsMedicationStockScreen/DetailsMedicationStockScreen.dart';
import 'package:project_final/modules/doctor/searchMedicationInStockPharmacy/SearchMedicationInStockPharmacyScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class MedicationsStocksScreen extends StatefulWidget {

  final PharmacyDataModel pharmacy;
  const MedicationsStocksScreen({super.key, required this.pharmacy});

  @override
  State<MedicationsStocksScreen> createState() =>
      _MedicationsStocksScreenState();
}

class _MedicationsStocksScreenState extends State<MedicationsStocksScreen> {
  
  
  final GlobalKey<RefreshIndicatorState> refreshIndicator = GlobalKey<RefreshIndicatorState>();
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var medicationsStock = cubit.medicationsStockModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    cubit.clearMedicationsStock();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: Text(
                  widget.pharmacy.pharmacyName ?? 'Medications',
                  style: const TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
                actions: [
                  ((medicationsStock?.medicationsStock.length ?? 0) > 0) ? IconButton(
                    onPressed: () {
                      if(CheckCubit.get(context).hasInternet) {
                        Navigator.of(context).push(_createSearchMedicationInStockRoute());
                      } else {
                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                      }
                    },
                    icon: const Icon(
                      EvaIcons.searchOutline,
                    ),
                    tooltip: 'Search',
                  ) : Container(),
                  const SizedBox(
                    width: 6.0,
                  ),
                ],
              ),
              body: (checkCubit.hasInternet) ? ConditionalBuilder(
                condition: (medicationsStock?.medicationsStock.length ?? 0) > 0,
                builder: (context) => RefreshIndicator(
                  key: refreshIndicator,
                  color: ThemeCubit.get(context).isDark ? HexColor('21b8c9') : HexColor('0571d5'),
                  backgroundColor: ThemeCubit.get(context).isDark ? HexColor('181818') : Colors.white ,
                  strokeWidth: 2.5,
                  onRefresh: () async {
                    if(CheckCubit.get(context).hasInternet) {
                      cubit.getAllMedicationsFromStockPharmacy(idPharmacy: widget.pharmacy.pharmacyId);
                    }
                    return Future<void>.delayed(const Duration(seconds: 2));
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) => buildItemMedicationStock(
                          medicationsStock!.medicationsStock[index], index, context),
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                        child: Divider(
                          thickness: 0.8,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      itemCount: medicationsStock?.medicationsStock.length ?? 0),
                ),
                fallback: (context) =>
                (state is LoadingGetAllMedicationsFromStockAppState ||
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

  Widget buildItemMedicationStock(MedicationStockData model, index, context) =>
      InkWell(
        onTap: () {
          if(CheckCubit.get(context).hasInternet) {
            Navigator.of(context).push(_createMedicationsRoute(model));
          } else {
            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 18.0,
          ),
          child: Row(
            children: [
              Text(
                '${index + 1} - ',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                '${model.medication?.name}',
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );


  Route _createMedicationsRoute(medication) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsMedicationStockScreen(medication: medication),
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

  Route _createSearchMedicationInStockRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchMedicationInStockPharmacyScreen(idPharmacy: widget.pharmacy.pharmacyId),
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

}


