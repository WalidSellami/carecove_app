import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/allUsersModel/AllUsersModel.dart';
import 'package:project_final/modules/admin/UserInfoScreen/FirstScreen.dart';
import 'package:project_final/modules/admin/UserInfoScreen/SecondScreen.dart';
import 'package:project_final/modules/admin/addUserScreen/AddUserScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  bool isScrolled = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppCubit.get(context).getProfile();
    AppCubit.get(context).getProfileAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFab = MediaQuery.of(context).viewInsets.bottom == 0;
    return Builder(builder: (context) {
      AppCubit.get(context).getAllUsers();
      AppCubit.get(context).getAllUserClaims();
      return BlocConsumer<CheckCubit, CheckStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var checkCubit = CheckCubit.get(context);

          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              var allUsers = cubit.allUsersModel;

              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: (checkCubit.hasInternet)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 6.0,
                          ),
                          Text.rich(
                            TextSpan(text: 'All users : ', children: [
                              TextSpan(
                                  text: '${allUsers?.users.length ?? 0}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                            ]),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: ConditionalBuilder(
                              condition: (allUsers?.users.length ?? 0) > 0,
                              builder: (context) =>
                                  NotificationListener<UserScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.direction ==
                                      ScrollDirection.forward) {
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
                                  backgroundColor:
                                      ThemeCubit.get(context).isDark
                                          ? HexColor('181818')
                                          : Colors.white,
                                  strokeWidth: 2.5,
                                  onRefresh: () async {
                                    cubit.getAllUsers();
                                    return Future<void>.delayed(
                                        const Duration(seconds: 2));
                                  },
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return buildItemUser(
                                            allUsers!.users[index], context);
                                      },
                                      separatorBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0,
                                          ),
                                          child: Divider(
                                            thickness: 0.8,
                                            color: Colors.grey.shade500,
                                          ),
                                        );
                                      },
                                      itemCount: allUsers?.users.length ?? 0),
                                ),
                              ),
                              fallback: (context) => (state
                                          is LoadingGetAllUsersAppState ||
                                      allUsers?.users == null)
                                  ? Center(child: IndicatorScreen(os: getOs()))
                                  : const Center(
                                      child: Text(
                                        'There is no users',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : const Center(
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
                floatingActionButton: ((allUsers?.users != null) &&
                        (checkCubit.hasInternet))
                    ? Visibility(
                        visible: isFab,
                        child: Container(
                          height: 55.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: FloatingActionButton.extended(
                              isExtended: isScrolled,
                              icon: Icon(
                                EvaIcons.editOutline,
                                color: ThemeCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              backgroundColor: ThemeCubit.get(context).isDark
                                  ? HexColor('15909d')
                                  : HexColor('b3d8ff'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(_createAddUserRoute());
                              },
                              label: Text(
                                'New user',
                                style: TextStyle(
                                  color: ThemeCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      )
                    : null,
              );
            },
          );
        },
      );
    });
  }

  Widget buildItemUser(AllUserModel model, context) => InkWell(
        onTap: () {
          if (model.role == 'Admin' || model.role == 'Patient') {
            navigatorTo(
                context: context,
                screen: FirstScreen(
                  userData: model,
                ));
          } else if (model.role == 'Doctor' || model.role == 'Pharmacist') {
            navigatorTo(
                context: context,
                screen: SecondScreen(
                  userData: model,
                ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 27.5,
                backgroundColor: ThemeCubit.get(context).isDark
                    ? HexColor('2eb7c9')
                    : HexColor('b3d8ff'),
                child: CircleAvatar(
                  radius: 26.0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('2eb7c9')
                          : HexColor('b3d8ff'),
                      backgroundImage: NetworkImage('${model.profileImage}')),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Text(
                  '${model.name}',
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

  Route _createAddUserRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddUserScreen(),
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
