import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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

class SearchCardScreen extends StatefulWidget {
  const SearchCardScreen({super.key});

  @override
  State<SearchCardScreen> createState() => _SearchCardScreenState();
}

class _SearchCardScreenState extends State<SearchCardScreen> {

  var searchCardController = TextEditingController();

  @override
  void initState() {
    searchCardController.addListener(() {
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
            var cards = cubit.cardPatientModel;
            var patientProfile = cubit.patientProfile;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if(cards == null) {
                      cubit.getAllCards(idPatient: patientId);
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Card',
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
                      controller: searchCardController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Type name your doctor ...',
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
                        suffixIcon: searchCardController.text.isNotEmpty ?
                        IconButton(
                          onPressed: () {
                            searchCardController.text = '';
                            cubit.clearSearchCardPatient();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ) : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchCardPatient(value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (cards?.cards.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) =>
                            buildItemCard(cards!.cards[index] , patientProfile),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: cards?.cards.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no card',
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
                    style: const TextStyle(
                      fontSize: 17.0,
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
                style: const TextStyle(
                  fontSize: 17.0,
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
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600,
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
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600,
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
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600,
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
                                  color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600,
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
                                    color: ThemeCubit.get(context).isDark ? Colors.grey : Colors.grey.shade600,
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