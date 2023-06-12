import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/modules/pharmacist/addMedicationInDB/AddMedicationInDbScreen.dart';
import 'package:project_final/modules/pharmacist/addMedicationInStock/AddMedicationInStockScreen.dart';
import 'package:project_final/modules/pharmacist/editMedicationInDB/EditMedicationInDbScreen.dart';
import 'package:project_final/modules/pharmacist/searchMedicationScreen/SearchMedicationScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  bool isVisible = true;

  bool? isExist;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getAllMedications();
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
                var medications = cubit.medicationsModel;

                return Scaffold(
                  appBar: defaultAppBar(
                      context: context,
                      title: 'Medications',
                      actions: [
                        ((medications?.medications.length ?? 0) > 5) ? IconButton(
                          onPressed: () {
                            if(checkCubit.hasInternet) {
                              Navigator.of(context).push(_createSearchMedicationInDbRoute());
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
                      ]
                  ),
                  body: (checkCubit.hasInternet) ? ConditionalBuilder(
                    condition: (medications?.medications.length ?? 0) > 0,
                    builder: (context) => NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {

                        if(notification.direction == ScrollDirection.forward) {

                          setState(() {
                            isVisible = true;
                          });

                        }else if(notification.direction == ScrollDirection.reverse) {

                          setState(() {
                            isVisible = false;
                          });

                        }
                        return true;

                      },
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        color:  ThemeCubit.get(context).isDark
                            ? HexColor('21b8c9')
                            : HexColor('0571d5'),
                        backgroundColor:
                        ThemeCubit.get(context).isDark ? HexColor('181818') : Colors.white,
                        strokeWidth: 2.5,
                        onRefresh: () async {
                          cubit.getAllMedications();
                          return Future<void>.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.separated(
                            itemBuilder: (context , index) => buildItemMedication(medications!.medications[index] , index),
                            separatorBuilder: (context , index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Divider(
                                thickness: 0.8,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            itemCount: medications?.medications.length ?? 0),
                      ),
                    ),
                    fallback: (context) => (state is LoadingGetAllMedicationsAppState || medications == null) ?
                    Center(child: IndicatorScreen(os: getOs())) :
                    const Center(
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
                  floatingActionButton: (((state is! LoadingGetAllMedicationsAppState) || (medications != null)) && (checkCubit.hasInternet)) ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 65.0,
                      height: 55.0,
                      child: Visibility(
                        visible: isVisible,
                        child: FloatingActionButton.extended(
                          tooltip: 'Add',
                          isExtended: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('b3d8ff'),
                          onPressed: (){
                            Navigator.of(context).push(_createAddMedicationInDbRoute());
                          },
                          label: const Text(''),
                          icon: Icon(
                            Icons.add,
                            color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                            size: 26.0,
                          ),
                        ),
                      ),
                    ),
                  ) : null,
                );
              },
            );
          },
        );
      }
    );
  }

  Widget buildItemMedication(MedicationData model , index) => InkWell(
    onTap: () {
      showLoading(context);
      AppCubit.get(context).checkExistMedicationInStock(idMedication: model.medicationId, idPharmacy: pharmacyId);
      Future.delayed(const Duration(milliseconds: 1500)).then((value) {
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
          Text(
            '${index + 1} -',
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 10.0,
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

  Route _createAddMedicationInDbRoute() {

    return PageRouteBuilder(
        pageBuilder: (context , animation , secondaryAnimation) => const AddMedicationInDbScreen(),
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

  Route _createSearchMedicationInDbRoute() {

    return PageRouteBuilder(
        pageBuilder: (context , animation , secondaryAnimation) => SearchMedicationScreen(),
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
