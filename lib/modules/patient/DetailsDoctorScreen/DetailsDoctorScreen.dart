import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/model/DataModels/doctorsModel/DoctorsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class DetailsDoctorScreen extends StatelessWidget {
  final DoctorDataModel doctor;
  const DetailsDoctorScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Profile ${doctor.user?.name ?? ''}',
              ),
              body: (checkCubit.hasInternet) ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 54.5,
                        backgroundColor: ThemeCubit.get(context).isDark
                            ? HexColor('2eb7c9')
                            : HexColor('b3d8ff'),
                        child: CircleAvatar(
                          radius: 52.0,
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: GestureDetector(
                            onTap: () {
                              showImage(context, 'image', doctor.user?.profileImage);
                            },
                            child: Hero(
                              tag: 'image',
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: ThemeCubit.get(context).isDark
                                      ? HexColor('2eb7c9')
                                      : HexColor('b3d8ff'),
                                  backgroundImage:
                                  NetworkImage('${doctor.user?.profileImage}'),
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
                        '${doctor.user?.name}',
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 17.0,
                      ),
                      Text(
                        '${doctor.user?.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.5,
                          color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
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
                                    '${doctor.user?.phone}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      overflow: TextOverflow.ellipsis,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
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
                                  'Local Address Work :',
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
                                    '${doctor.localAddress}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      height: 1.4,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
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
                                  'Speciality :',
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
                                    '${doctor.speciality}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      overflow: TextOverflow.ellipsis,
                                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
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
