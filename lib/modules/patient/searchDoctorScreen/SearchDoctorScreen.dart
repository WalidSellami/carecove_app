import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/DataModels/doctorsModel/DoctorsModel.dart';
import 'package:project_final/modules/patient/DetailsDoctorScreen/DetailsDoctorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SearchDoctorScreen extends StatefulWidget {
  const SearchDoctorScreen({super.key});

  @override
  State<SearchDoctorScreen> createState() => _SearchDoctorScreenState();
}

class _SearchDoctorScreenState extends State<SearchDoctorScreen> {

  var searchDoctorController = TextEditingController();

  @override
  void initState() {
    searchDoctorController.addListener(() {
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
            var doctors = cubit.doctorsModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if(doctors == null) {
                      cubit.getAllDoctors();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Doctor',
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
                      controller: searchDoctorController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Type ...',
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
                        suffixIcon: searchDoctorController.text.isNotEmpty ?
                        IconButton(
                          onPressed: () {
                            searchDoctorController.text = '';
                            cubit.clearSearchDoctor();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ) : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchDoctor(value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (doctors?.doctors.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) =>
                            buildItemDoctor(doctors!.doctors[index] , context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: doctors?.doctors.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no doctor',
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
