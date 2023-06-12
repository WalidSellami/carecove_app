import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/modules/doctor/medicationsStocksScreen/MedicationsStocksScreen.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SearchPharmacyScreen extends StatefulWidget {
  const SearchPharmacyScreen({super.key});

  @override
  State<SearchPharmacyScreen> createState() => _SearchPharmacyScreenState();
}

class _SearchPharmacyScreenState extends State<SearchPharmacyScreen> {
  var searchPharmacyController = TextEditingController();

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
            var allPharmacies = cubit.pharmaciesModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (allPharmacies == null) {
                      cubit.getAllPharmacies();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Pharmacy',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
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
                      controller: searchPharmacyController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Type ...',
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
                        suffixIcon: searchPharmacyController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            searchPharmacyController.text = '';
                            cubit.clearSearchPharmacy();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                            : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchPharmacy(value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (allPharmacies?.pharmacies.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) => buildItemPharmacy(
                            allPharmacies!.pharmacies[index], context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: allPharmacies?.pharmacies.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no pharmacy',
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

  Widget buildItemPharmacy(PharmacyDataModel model, context) => InkWell(
        onTap: () {
          AppCubit.get(context)
              .getAllMedicationsFromStockPharmacy(idPharmacy: model.pharmacyId);
          Navigator.of(context).push(_createGetMedicationsPharmacyRoute(model));
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
                      : HexColor('c1dfff'),
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
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey.shade500,
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
}
