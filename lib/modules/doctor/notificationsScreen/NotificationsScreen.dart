import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/patientClaimsModel/patientClaimsModel.dart';
import 'package:project_final/modules/doctor/notificationDetails/NotificationDetails.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isSelected = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllPatientClaims();
      return BlocConsumer<CheckCubit , CheckStates>(
        listener: (context , state) {},
        builder: (context , state) {

          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = AppCubit.get(context);
                var patientClaims = cubit.patientClaimsModel;

                return Scaffold(
                  appBar: defaultAppBar(
                    context: context,
                    title: 'Notifications',
                  ),
                  body: (checkCubit.hasInternet) ? ConditionalBuilder(
                    condition: (patientClaims?.patientClaims.length ?? 0) > 0,
                    builder: (context) => RefreshIndicator(
                      key: refreshIndicator,
                      color: ThemeCubit.get(context).isDark
                          ? HexColor('21b8c9')
                          : HexColor('0571d5'),
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('181818')
                          : Colors.white,
                      strokeWidth: 2.5,
                      onRefresh: () async {
                        cubit.getAllPatientClaims();
                        return Future<void>.delayed(const Duration(seconds: 2));
                      },
                      child: ListView.separated(
                          itemBuilder: (context, index) => buildItemNotification(
                              patientClaims!.patientClaims[index]),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: patientClaims?.patientClaims.length ?? 0),
                    ),
                    fallback: (context) =>
                    (state is LoadingGetAllPatientClaimsAppState ||
                        patientClaims == null)
                        ? Center(child: IndicatorScreen(os: getOs()))
                        : const Center(
                      child: Text(
                        'There is no notifications',
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
              });
        },
      );
    });
  }

  buildItemNotification(PatientClaimData model) => InkWell(
        onTap: () {
          showLoading(context);
          if (model.statusClaim == 'false') {
            AppCubit.get(context)
                .changeStatusNotice(idPatientClaim: model.patientClaimId);
          }
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            Navigator.pop(context);
            navigatorTo(
                context: context,
                screen: NotificationDetails(
                  patientClaim: model,
                ));
          });
        },
        child: Container(
          padding: const EdgeInsets.all(
            6.0,
          ),
          decoration: BoxDecoration(
            color: (model.statusClaim == 'false')
                ? (ThemeCubit.get(context).isDark
                    ? Colors.grey.shade800.withOpacity(.7)
                    : Colors.grey.shade200)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22.5,
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('2eb7c9')
                          : HexColor('b3d8ff'),
                      child: CircleAvatar(
                        radius: 21.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: ThemeCubit.get(context).isDark
                                ? HexColor('2eb7c9')
                                : HexColor('b3d8ff'),
                            backgroundImage: NetworkImage(
                                '${model.patient?.user?.profileImage}')),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '${model.patient?.user?.name}',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 14.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    '${model.message}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15.0,
                      height: 1.4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${model.claimDate}',
                    style: const TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                color: ThemeCubit.get(context).isDark
                    ? Colors.grey.shade900
                    : Colors.white,
              ),
              child: IndicatorScreen(os: getOs())),
        );
      });
}
