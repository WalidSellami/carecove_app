import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/allUsersModel/AllUsersModel.dart';
import 'package:project_final/modules/admin/editUserInfoScreen/EditFirstScreen.dart';
import 'package:project_final/modules/settings/EditProfileScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class FirstScreen extends StatefulWidget {
  final AllUserModel? userData;

  const FirstScreen(
      {super.key, this.userData});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {
            if(state is SuccessDeleteAccountUserAppState) {
              if(state.simpleModel.status == true) {

                showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.success, context: context);
                AppCubit.get(context).getAllUsers();
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
                title:
                '${widget.userData?.name}',
              ),
              body: (checkCubit.hasInternet) ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showImage(
                            context,
                            'image',
                            widget.userData?.profileImage);
                      },
                      child: Hero(
                        tag: 'image',
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: CircleAvatar(
                            radius: 55.0,
                            backgroundColor: ThemeCubit.get(context).isDark
                                ? HexColor('2eb7c9')
                                : HexColor('b3d8ff'),
                            child: CircleAvatar(
                              radius: 53.5,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 52.0,
                                backgroundImage: NetworkImage(
                                    '${widget.userData?.profileImage}'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      '${widget.userData?.name}',
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 17.0,
                    ),
                    Text(
                      '${widget.userData?.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.5,
                        color: ThemeCubit.get(context).isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Row(
                      children: [
                        Icon(
                          EvaIcons.fileTextOutline,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          'Informations :',
                          style: TextStyle(
                            fontSize: 17.5,
                            height: 1.7,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 28.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phone :',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Text(
                                  '${widget.userData?.phone}',
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    overflow: TextOverflow.ellipsis,
                                    color: ThemeCubit.get(context).isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address :',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 6.0,
                                ),
                                child: Text(
                                  '${widget.userData?.admin?.address ?? widget.userData?.patient?.address}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    height: 1.4,
                                    color: ThemeCubit.get(context).isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150.0,
                          child: MaterialButton(
                            height: 42.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () {
                              if(widget.userData != null && (widget.userData?.userId == userId)) {

                                Navigator.of(context).push(_createEditAdminUserRoute());

                              } else {

                                Navigator.of(context).push(_createEditUserRoute());

                              }
                            },
                            color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('b3d8ff'),
                            child: Text(
                              'Edit'.toUpperCase(),
                              style: TextStyle(
                                  color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if(widget.userData?.userId != userId)
                        const SizedBox(
                          width: 30.0,
                        ),
                        if(widget.userData?.userId != userId)
                          SizedBox(
                          width: 150.0,
                          child: MaterialButton(
                            height: 42.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () {
                              showAlert(context, widget.userData?.userId, widget.userData?.name);
                            },
                            color: HexColor('f9325f'),
                            child: Text(
                              'Delete'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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

  dynamic showImage(BuildContext context, String tag, image) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: defaultAppBar(context: context),
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
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
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  width: double.infinity,
                  height: 450.0,
                  fit: BoxFit.fitWidth,
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
                ),
              ),
            ),
          ),
        ),
      );
    }));
  }

  dynamic showAlert(BuildContext context, id , nameUser) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: 'Do you want to remove \n ',
                        style: const TextStyle(
                          fontSize: 19.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '$nameUser',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' ?',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]
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
                  AppCubit.get(context).deleteAccountUser(idUser: id);
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

  Route _createEditUserRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditFirstScreen(userData: widget.userData),
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

  Route _createEditAdminUserRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EditProfileScreen(),
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
