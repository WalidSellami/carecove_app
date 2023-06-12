
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/model/authModels/loginModel/LoginModel.dart';
import 'package:project_final/shared/EndPoints.dart';
import 'package:project_final/shared/cubit/loginCubit/States.dart';
import 'package:project_final/shared/network/remot/DioHelper.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit() : super(InitialLoginState());

  static LoginCubit get(context) => BlocProvider.of(context);


  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
}){

    emit(LoadingLoginState());
    DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password
        }).then((value) {

        loginModel = LoginModel.fromJson(value?.data);
        emit(SuccessLoginState(loginModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorLoginState(error));
    });

  }

}