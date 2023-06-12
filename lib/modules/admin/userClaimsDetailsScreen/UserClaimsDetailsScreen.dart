import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/userClaimsModel/UserClaimsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class UserClaimsDetailsScreen extends StatelessWidget {
  final UserClaimData userClaim;
  const UserClaimsDetailsScreen({super.key, required this.userClaim});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {

            if(state is SuccessRemoveUserClaimAppState) {
              if(state.simpleModel.status == true) {
                showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.success, context: context);
                AppCubit.get(context).getAllUserClaims();
                Navigator.pop(context);
                Navigator.pop(context);

              } else {
                showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);
              }
            }
          },
          builder: (context , state) {

            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: '${userClaim.user?.name}',
                actions: [
                  if(checkCubit.hasInternet)
                    ConditionalBuilder(
                      condition: state is! LoadingRemoveUserClaimAppState,
                      builder: (context) => IconButton(
                        onPressed: () {
                          showAlert(context, userClaim.userClaimId);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: 26.0,
                          color: HexColor('f9325f'),
                        ),
                        tooltip: 'Remove',
                      ),
                      fallback: (context) =>  Padding(
                        padding: const EdgeInsets.only(
                          right: 6.0,
                        ),
                        child: IndicatorRingScreen(os: getOs()),
                      ),
                    ),
                  if(checkCubit.hasInternet)
                    const SizedBox(
                      width: 6.0,
                    ),
                ],
              ),
              body: (checkCubit.hasInternet) ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userClaim.message}',
                      style: const TextStyle(
                        fontSize: 16.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${userClaim.claimDate}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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

  dynamic showAlert(BuildContext context, id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Do you want to remove this claim ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showLoading(context);
                  AppCubit.get(context).removeUserClaim(idUserClaim: id);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: HexColor('f9325f'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
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
}