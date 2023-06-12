import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/modules/doctor/addPatientScreen/AddPatientScreen.dart';
import 'package:project_final/modules/doctor/cardPatientScreen/CardPatientScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool isScrolled = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppCubit.get(context).getProfile();
    AppCubit.get(context).checkAccountUser();
    AppCubit.get(context).getProfileDoctor();
    doctorId = CacheHelper.getData(key: 'doctorId');
    if (doctorId != null) {
      AppCubit.get(context).getAllPatientClaims();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllPatients();
      if (doctorId != null) {
        AppCubit.get(context).getAllPatientClaims();
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
                  if ((state is SuccessGetProfileDoctorAppState) &&
                      (doctorId == null)) {
                    CacheHelper.saveData(
                        key: 'doctorId',
                        value: state.doctorProfile.doctor?.doctorId)
                        .then((value) {
                      doctorId = state.doctorProfile.doctor?.doctorId;

                      AppCubit.get(context).getAllPatientClaims();
                    });
                  }
                },
                builder: (context, state) {
                  var cubit = AppCubit.get(context);
                  var allPatients = cubit.patientsModel;

                  return Scaffold(
                    body: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: ((allPatients?.patients.length ?? 0) > 0),
                      builder: (context) =>
                          NotificationListener<UserScrollNotification>(
                            onNotification: (notification) {
                              if (notification.direction == ScrollDirection.forward) {
                                setState(() {
                                  isScrolled = true;
                                });
                              } else if (notification.direction ==
                                  ScrollDirection.reverse) {
                                setState(() {
                                  isScrolled = false;
                                });
                              }
                              return true;
                            },
                            child: RefreshIndicator(
                              key: _refreshIndicatorKey,
                              color: ThemeCubit.get(context).isDark
                                  ? HexColor('21b8c9')
                                  : HexColor('0571d5'),
                              backgroundColor: ThemeCubit.get(context).isDark
                                  ? HexColor('181818')
                                  : Colors.white,
                              strokeWidth: 2.5,
                              onRefresh: () async {
                                cubit.getAllPatients();
                                return Future<void>.delayed(const Duration(seconds: 2));
                              },
                              child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    buildItemPatient(allPatients!.patients[index]),
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  child: Divider(
                                    thickness: 0.8,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                itemCount: allPatients?.patients.length ?? 0,
                              ),
                            ),
                          ),
                      fallback: (context) =>
                      (state is LoadingGetAllPatientsAppState ||
                          allPatients == null)
                          ? Center(child: IndicatorScreen(os: getOs()))
                          : const Center(
                        child: Text(
                          'There is no patients',
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
                    floatingActionButton: ((allPatients?.patients != null) && (checkCubit.hasInternet))
                        ? Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: FloatingActionButton.extended(
                          isExtended: isScrolled,
                          icon: Icon(
                            EvaIcons.editOutline,
                            color: themeCubit.isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                          backgroundColor: themeCubit.isDark
                              ? HexColor('15909d')
                              : HexColor('b3d8ff'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              14.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(_createFormPatientRoute());
                          },
                          label: Text(
                            'New patient',
                            style: TextStyle(
                              color: themeCubit.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                        : null,
                  );
                },
              );
            },
          );

        },
      );
    });
  }

  Widget buildItemPatient(PatientDataModel model) => InkWell(
        onTap: () {
          navigatorTo(
              context: context,
              screen: CardPatientScreen(
                patient: model,
              ));
          AppCubit.get(context).clearCardData();
          AppCubit.get(context).getCardPatient(idPatient: model.patientId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.5,
                backgroundColor: ThemeCubit.get(context).isDark
                    ? HexColor('2eb7c9')
                    : HexColor('b3d8ff'),
                child: CircleAvatar(
                  radius: 27.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                      radius: 26.0,
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('2eb7c9')
                          : HexColor('b3d8ff'),
                      backgroundImage:
                          NetworkImage('${model.user?.profileImage}')),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Text(
                  '${model.user?.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Route _createFormPatientRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddPatientScreen(),
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
