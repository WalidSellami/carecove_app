import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/modules/settings/AddClaimToAdminScreen.dart';
import 'package:project_final/modules/settings/ChangePasswordScreen.dart';
import 'package:project_final/modules/settings/EditProfileScreen.dart';
import 'package:project_final/modules/startup/loginScreen/LoginScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    AppCubit.get(context).checkAccountUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ThemeCubit, ThemeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var themeCubit = ThemeCubit.get(context);

            return BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = AppCubit.get(context);
                var userProfile = cubit.profile;
                var doctorProfile = cubit.doctorProfile;
                var pharmacyProfile = cubit.pharmacyProfile;
                var patientProfile = cubit.patientProfile;
                var adminProfile = cubit.adminProfile;

                return Scaffold(
                  body: (checkCubit.hasInternet) ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 46.0,
                                backgroundColor: ThemeCubit.get(context).isDark
                                    ?HexColor('2eb7c9')
                                    : HexColor('b3d8ff'),
                                child: CircleAvatar(
                                  radius: 44.0,
                                  backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                                  child: GestureDetector(
                                    onTap: () {
                                      showImage(context, 'image', userProfile?.user?.profileImage);
                                    },
                                    child: Hero(
                                      tag: 'image',
                                      child: Container(
                                        decoration: const BoxDecoration(),
                                        child: CircleAvatar(
                                          radius: 42.0,
                                          backgroundColor: ThemeCubit.get(context).isDark
                                              ? HexColor('15909d')
                                              : HexColor('b3d8ff'),
                                          backgroundImage: NetworkImage(
                                              '${userProfile?.user?.profileImage}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userProfile?.user?.name}',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      '${userProfile?.user?.email}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        overflow: TextOverflow.ellipsis,
                                        color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                              ),
                              const SizedBox(
                                width: 14.0,
                              ),
                              Text(
                                '${userProfile?.user?.phone}',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          if (userProfile?.user?.role == 'Doctor')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    '${doctorProfile?.doctor?.localAddress}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (userProfile?.user?.role == 'Pharmacist')
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    pharmacyProfile?.pharmacy?.localAddress ?? '',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (userProfile?.user?.role == 'Patient')
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    '${patientProfile?.patient?.address}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (userProfile?.user?.role == 'Admin')
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    '${adminProfile?.admin?.address}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 8.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SwitchListTile(
                            selected: themeCubit.isDark,
                            activeColor: HexColor('2eb7c9'),
                            value: themeCubit.isDark,
                            onChanged: (value) {
                              themeCubit.changeThemeMode(value);
                            },
                            title: const Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ListTile(
                            onTap: () {
                              if(checkCubit.hasInternet) {
                                Navigator.of(context).push(_createEditProfileRoute());
                              } else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: themeCubit.isDark
                                    ? HexColor('1599a6')
                                    : HexColor('b3d8ff'),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Icon(
                                EvaIcons.edit,
                                color: themeCubit.isDark
                                    ? Colors.grey.shade100
                                    : Colors.black,
                              ),
                            ),
                            title: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ListTile(
                            onTap: () {
                              if(checkCubit.hasInternet) {
                                Navigator.of(context)
                                    .push(_createChangePasswordRoute());
                              }else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }

                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: themeCubit.isDark
                                    ? HexColor('1599a6')
                                    : HexColor('b3d8ff'),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: themeCubit.isDark
                                    ? Colors.grey.shade100
                                    : Colors.black,
                              ),
                            ),
                            title: const Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17.0,
                            ),
                          ),
                          if((userProfile?.user?.role == 'Doctor') || (userProfile?.user?.role == 'Pharmacist'))
                            const SizedBox(
                              height: 10.0,
                            ),
                          if((userProfile?.user?.role == 'Doctor') || (userProfile?.user?.role == 'Pharmacist'))
                            ListTile(
                              onTap: () {
                                if(checkCubit.hasInternet) {
                                  Navigator.of(context).push(_createAddClaimToAdminRoute());
                                } else {
                                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                }
                              },
                              leading: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: themeCubit.isDark
                                      ? HexColor('1599a6')
                                      : HexColor('b3d8ff'),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  color: themeCubit.isDark
                                      ? Colors.grey.shade100
                                      : HexColor('091e28'),
                                ),
                              ),
                              title: const Text(
                                'Add Claim To Admin',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 17.0,
                              ),
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ListTile(
                            onTap: () {
                              if(checkCubit.hasInternet) {
                                showAlert(context);
                              } else {
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: themeCubit.isDark
                                    ? HexColor('1599a6')
                                    : HexColor('b3d8ff'),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Icon(
                                EvaIcons.logOutOutline,
                                color: themeCubit.isDark
                                    ? Colors.grey.shade100
                                    : Colors.black,
                              ),
                            ),
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
      },
    );
  }

  dynamic showImage(BuildContext context , tag , image) {

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: defaultAppBar(
            context: context),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Hero(
              tag: tag,
              child: Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  '$image',
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        width: double.infinity,
                        height: 450.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            width: 1.0,
                            color: ThemeCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        child: const Center(
                            child: Text(
                              'Failed to load',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            )));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                          width: double.infinity,
                          height: 450.0,
                          child: Center(
                              child: IndicatorRingScreen(
                                os: getOs(),
                              )));
                    }
                  },
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  width: double.infinity,
                  height: 450.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      );
    }

    )
    );

  }
}

Route _createEditProfileRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const EditProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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

Route _createChangePasswordRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ChangePasswordScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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

Route _createAddClaimToAdminRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddClaimToAdminScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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


dynamic showAlert(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Log Out',
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: const Text(
            'Do you want to log out ?',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
            TextButton(
                onPressed: () {
                  if(CheckCubit.get(context).hasInternet) {
                    Navigator.pop(dialogContext);
                    showLoading(context);
                    AppCubit.get(context).logOut(idUser: userId);
                    CacheHelper.removeData(key: 'token').then((value) {
                      if (value == true) {
                        CacheHelper.removeData(key: 'userId');
                        CacheHelper.removeData(key: 'isDoctor');
                        CacheHelper.removeData(key: 'isPharmacist');
                        CacheHelper.removeData(key: 'isPatient');
                        CacheHelper.removeData(key: 'isAdmin');
                        switch (AppCubit.get(context).profile?.user?.role) {
                          case 'Doctor':
                            CacheHelper.removeData(key: 'doctorId');
                            break;
                          case 'Pharmacist':
                            CacheHelper.removeData(key: 'pharmacistId');
                            CacheHelper.removeData(key: 'pharmacyId');
                            AppCubit.get(context).clearOrders();
                            AppCubit.get(context).clearStockPharmacy();
                            break;
                          case 'Patient':
                            CacheHelper.removeData(key: 'patientId');
                            AppCubit.get(context).clearCardPatientData();
                            break;
                        }

                        Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                          Navigator.pop(context);
                          navigatorToNotBack(context: context, screen: const LoginScreen());
                          AppCubit.get(context).currentIndex = 0;
                        });
                      }
                    });
                  } else {
                    showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                  }
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
