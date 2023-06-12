import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/modules/doctor/detailsMedicationStockScreen/DetailsMedicationStockScreen.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';

class SearchMedicationInStockPharmacyScreen extends StatefulWidget {

  final int? idPharmacy;
  const SearchMedicationInStockPharmacyScreen({super.key , required this.idPharmacy});

  @override
  State<SearchMedicationInStockPharmacyScreen> createState() => _SearchMedicationInStockPharmacyScreenState();
}

class _SearchMedicationInStockPharmacyScreenState extends State<SearchMedicationInStockPharmacyScreen> {


  var searchMedicationStockController = TextEditingController();

  @override
  void initState() {
    searchMedicationStockController.addListener(() {
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

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var allMedicationsStock = cubit.medicationsStockModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (allMedicationsStock == null) {
                      cubit.getAllMedicationsFromStockPharmacy(idPharmacy: widget.idPharmacy);
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Medication',
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
                      controller: searchMedicationStockController,
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
                        suffixIcon: searchMedicationStockController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            searchMedicationStockController.text = '';
                            cubit.clearSearchMedicationInStockPharmacy();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                            : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchMedicationInStockPharmacy(
                            name: value,
                            idPharmacy: widget.idPharmacy);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (allMedicationsStock?.medicationsStock.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) => buildItemMedicationStock(
                            allMedicationsStock!.medicationsStock[index], index , context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: allMedicationsStock?.medicationsStock.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no medication',
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

  Widget buildItemMedicationStock(MedicationStockData model, index, context) =>
      InkWell(
        onTap: () {
          Navigator.of(context).push(_createMedicationsRoute(model));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 18.0,
          ),
          child: Row(
            children: [
              const Text(
                '- ',
                style: TextStyle(
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


}
