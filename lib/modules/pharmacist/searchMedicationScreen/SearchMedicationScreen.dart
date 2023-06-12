import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/modules/pharmacist/addMedicationInStock/AddMedicationInStockScreen.dart';
import 'package:project_final/modules/pharmacist/editMedicationInDB/EditMedicationInDbScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SearchMedicationScreen extends StatefulWidget {
  const SearchMedicationScreen({super.key});

  @override
  State<SearchMedicationScreen> createState() => _SearchMedicationScreenState();
}

class _SearchMedicationScreenState extends State<SearchMedicationScreen> {

  var searchMedicationController = TextEditingController();

  bool? isExist;

  @override
  void initState() {
    searchMedicationController.addListener(() {
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
          listener: (context , state) {
            if(state is SuccessCheckExistMedicationInStockAppState){
              if(state.simpleModel.status == true) {

                setState(() {
                  isExist = true;
                });

                if(isExist == true) {
                  Navigator.pop(context);
                  showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);
                }

              }else {

                setState(() {
                  isExist = false;
                });
              }
            }
          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);
            var medication = cubit.medicationsModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if(medication == null) {
                      cubit.getAllMedications();
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
                      controller: searchMedicationController,
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
                        suffixIcon: searchMedicationController.text.isNotEmpty ?
                        IconButton(
                          onPressed: () {
                            searchMedicationController.text = '';
                            cubit.clearSearchMedication();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ) : null,
                      ),
                      onChanged: (String value) {
                        cubit.searchMedication(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (medication?.medications.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) => buildItemMedication(medication!.medications[index] , index , context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: medication?.medications.length ?? 0,
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

  Widget buildItemMedication(MedicationData model , index , context) => InkWell(
    onTap: () {
      showLoading(context);
      AppCubit.get(context).checkExistMedicationInStock(idMedication: model.medicationId, idPharmacy: pharmacyId);
      Future.delayed(const Duration(milliseconds: 1200)).then((value) {
        if(isExist == false) {
          Navigator.pop(context);
          Navigator.of(context).push(_createAddMedicationInStockRoute(model));
        }
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
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
            width: 8.0,
          ),
          Text(
            '${model.name}',
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(_createEditMedicationInDbRoute(model));
            },
            icon: const Icon(
              EvaIcons.editOutline,
            ),
            tooltip: 'Edit',
          ),
        ],
      ),
    ),
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
                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade900 : Colors.white,
                ),
                child: IndicatorScreen(os: getOs())),
          );
        });
  }


}



Route _createEditMedicationInDbRoute(medication) {

  return PageRouteBuilder(
      pageBuilder: (context , animation , secondaryAnimation) => EditMedicationInDbScreen(medicationData: medication,),
      transitionsBuilder: (context , animation , secondaryAnimation , child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin , end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );

}

Route _createAddMedicationInStockRoute(medication) {

  return PageRouteBuilder(
      pageBuilder: (context , animation , secondaryAnimation) => AddMedicationInStockScreen(medication: medication,),
      transitionsBuilder: (context , animation , secondaryAnimation , child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin , end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );

}


