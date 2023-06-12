import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardPatientModel.dart';
import 'package:project_final/model/profileModel/profilePatientModel/ProfilePatientModel.dart';
import 'package:project_final/modules/patient/claimScreen/ClaimScreen.dart';
import 'package:project_final/modules/patient/prescriptionScreen/PrescriptionScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppCubit.get(context).getProfile();
    AppCubit.get(context).checkAccountUser();
    patientId = CacheHelper.getData(key: 'patientId');
    if (patientId != null) {
      AppCubit.get(context).getProfilePatient();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (patientId != null) {
        AppCubit.get(context).getAllCards(idPatient: patientId);
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
                  if ((state is SuccessGetProfilePatientAppState) &&
                      (patientId == null)) {
                    AppCubit.get(context).getAllCards(
                        idPatient: state.patientProfile.patient?.patientId);

                    CacheHelper.saveData(
                        key: 'patientId',
                        value: state.patientProfile.patient?.patientId)
                        .then((value) {
                      patientId = state.patientProfile.patient?.patientId;
                    });
                  }
                },
                builder: (context, state) {
                  var cubit = AppCubit.get(context);
                  var patientProfile = cubit.patientProfile;
                  var cards = cubit.cardPatientModel;

                  return (checkCubit.hasInternet) ? ConditionalBuilder(
                    condition: ((cards?.cards.length ?? 0) > 0),
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
                          cubit.getAllCards(idPatient: patientId);
                        }
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            buildItemCard(cards?.cards[index], patientProfile),
                        itemCount: cards?.cards.length,
                      ),
                    ),
                    fallback: (context) =>
                    (state is LoadingGetProfilePatientAppState ||
                        state is LoadingGetAllCardsAppState ||
                        cards == null)
                        ? Center(child: IndicatorScreen(os: getOs()))
                        : const Center(
                      child: Text(
                        'There is no cards',
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
                  );
                },
              );
            },
          );
        },
      );
    });
  }

  Widget buildItemCard(CardsPatientData? card, ProfilePatientModel? patient) =>
      Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Text(
                    'Doctor ${card?.doctor?.user?.name}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 17.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                '${patient?.patient?.user?.name}',
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 17.0,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Age',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${card?.age}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Weight',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${card?.weight}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Sickness',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${card?.sickness}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Phone',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                '${patient?.patient?.user?.phone}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  '${patient?.patient?.address}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  defaultNewButton(
                      toolTip: 'Message',
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      padding: 10.0,
                      icon: EvaIcons.messageSquareOutline,
                      colorIcon: ThemeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                      onPress: () {
                        Navigator.of(context).push(_createClaimRoute(card));
                      }),
                  const SizedBox(
                    width: 15.0,
                  ),
                  defaultNewButton(
                      toolTip: 'More',
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      padding: 10.0,
                      icon: EvaIcons.arrowForwardOutline,
                      colorIcon: ThemeCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                      onPress: () {
                        AppCubit.get(context).clearPrescriptions();
                        navigatorTo(
                            context: context,
                            screen: PrescriptionScreen(
                              card: card,
                              patient: patient,
                            ));
                      }),
                ],
              ),
            ],
          ),
        ),
      );
}

Route _createClaimRoute(card) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ClaimScreen(cardPatient: card),
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
