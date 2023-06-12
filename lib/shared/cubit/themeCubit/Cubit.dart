
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/shared/cubit/themeCubit/States.dart';
import 'package:project_final/shared/network/local/CacheHelper.dart';

class ThemeCubit extends Cubit<ThemeStates> {

  ThemeCubit() : super(InitialThemeState());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeThemeMode(value) {

     isDark = value;
     CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
       emit(ChangeThemeState());
     });

  }



}