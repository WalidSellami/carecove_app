import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/resetPasswordModel/checkEmailModel/CheckEmailModel.dart';

abstract class ResetPassStates {}

class InitialForgoPassState extends ResetPassStates {}

class LoadingCheckEmailState extends ResetPassStates {}

class SuccessCheckEmailState extends ResetPassStates {

  final CheckEmailModel checkModel;
  SuccessCheckEmailState(this.checkModel);

}

class ErrorCheckEmailState extends ResetPassStates {

  dynamic error;
  ErrorCheckEmailState(this.error);

}

class LoadingResetPasswordState extends ResetPassStates {}

class SuccessResetPasswordState extends ResetPassStates {

  final SimpleModel resetModel;
  SuccessResetPasswordState(this.resetModel);

}

class ErrorResetPasswordState extends ResetPassStates {

  dynamic error;
  ErrorResetPasswordState(this.error);

}