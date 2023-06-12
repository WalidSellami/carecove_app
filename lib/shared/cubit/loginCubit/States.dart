import 'package:project_final/model/authModels/loginModel/LoginModel.dart';

abstract class LoginStates {}

class InitialLoginState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {

  final LoginModel loginModel;
  SuccessLoginState(this.loginModel);

}

class ErrorLoginState extends LoginStates {

  dynamic error;
  ErrorLoginState(this.error);

}