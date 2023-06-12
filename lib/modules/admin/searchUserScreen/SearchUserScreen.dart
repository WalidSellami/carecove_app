import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/model/DataModels/allUsersModel/AllUsersModel.dart';
import 'package:project_final/modules/admin/UserInfoScreen/FirstScreen.dart';
import 'package:project_final/modules/admin/UserInfoScreen/SecondScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {

  var searchUserController = TextEditingController();


  @override
  void initState() {
    searchUserController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var allUsers = cubit.allUsersModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (allUsers == null) {
                      cubit.getAllUsers();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search User',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
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
                      controller: searchUserController,
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
                        suffixIcon: searchUserController.text.isNotEmpty
                            ? IconButton(
                          onPressed: () {
                            searchUserController.text = '';
                            cubit.clearSearchUser();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                            : null,
                      ),
                      onChanged: (String value) {
                        if(checkCubit.hasInternet) {
                          cubit.searchUser(name: value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: (checkCubit.hasInternet) ? ConditionalBuilder(
                      condition: (allUsers?.users.length ?? 0) > 0,
                      builder: (context) => ListView.separated(
                        itemBuilder: (context, index) =>
                            buildItemUser(allUsers!.users[index], context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        itemCount: allUsers?.users.length ?? 0,
                      ),
                      fallback: (context) => const Center(
                        child: Text(
                          'There is no users',
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

}
