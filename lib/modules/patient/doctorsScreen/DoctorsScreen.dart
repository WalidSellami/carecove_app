import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/doctorsModel/DoctorsModel.dart';
import 'package:project_final/modules/patient/DetailsDoctorScreen/DetailsDoctorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';

class DoctorsScreen extends StatelessWidget {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).checkAccountUser();
        AppCubit.get(context).getAllDoctors();
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<ThemeCubit , ThemeStates>(
              listener: (context , state) {},
              builder: (context , state) {

                var themeCubit = ThemeCubit.get(context);

                return BlocConsumer<AppCubit , AppStates>(
                  listener: (context , state) {},
                  builder: (context , state) {

                    var cubit = AppCubit.get(context);
                    var doctors = cubit.doctorsModel;

                    return Scaffold(
                      body: (checkCubit.hasInternet) ? ConditionalBuilder(
                        condition: ((doctors?.doctors.length?? 0) > 0),
                        builder: (context) =>
                            RefreshIndicator(
                              key: _refreshIndicatorKey,
                              color: themeCubit.isDark ? HexColor('21b8c9') : HexColor('0571d5'),
                              backgroundColor: themeCubit.isDark ? HexColor('181818') : Colors.white ,
                              strokeWidth: 2.5,
                              onRefresh: () async {
                                cubit.getAllDoctors();
                                return Future<void>.delayed(const Duration(seconds: 2));
                              },
                              child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    buildItemDoctor(doctors!.doctors[index] , context),
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  child: Divider(
                                    thickness: 0.8,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                itemCount: doctors?.doctors.length ?? 0,
                              ),
                            ),
                        fallback: (context) =>
                        (state is LoadingGetAllDoctorsAppState || doctors == null)
                            ? Center(child: IndicatorScreen(os: getOs()))
                            : const Center(
                          child: Text(
                            'There is no doctors',
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
                  },
                );
              },
            );
          },
        );
      }
    );
  }


  Widget buildItemDoctor(DoctorDataModel model , context) => InkWell(
    onTap: () {
      navigatorTo(context: context, screen: DetailsDoctorScreen(doctor: model,));
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
            backgroundColor: ThemeCubit.get(context).isDark ? HexColor('2eb7c9') : HexColor('b3d8ff'),
            child: CircleAvatar(
              radius: 27.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: CircleAvatar(
                  radius: 26.0,
                  backgroundColor: ThemeCubit.get(context).isDark ? HexColor('2eb7c9') : HexColor('b3d8ff'),
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

}
