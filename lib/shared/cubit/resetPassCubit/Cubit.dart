import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/resetPasswordModel/checkEmailModel/CheckEmailModel.dart';
import 'package:project_final/shared/EndPoints.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/resetPassCubit/States.dart';
import 'package:project_final/shared/network/remot/DioHelper.dart';

class ResetPassCubit extends Cubit<ResetPassStates> {
  ResetPassCubit() : super(InitialForgoPassState());

  static ResetPassCubit get(context) => BlocProvider.of(context);

  CheckEmailModel? checkModel;

  void searchEmail({
    required String email,
  }) {
    emit(LoadingCheckEmailState());

    DioHelper.postData(url: CHECK_EMAIL, data: {
      'email': email,
    }).then((value) {
      checkModel = CheckEmailModel.fromJson(value?.data);
      emit(SuccessCheckEmailState(checkModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckEmailState(error));
    });
  }

  SimpleModel? resetModel;

  void resetPassword({
    required String password,
  }) {
    emit(LoadingResetPasswordState());

    DioHelper.putData(url: '/api/user/reset-password/$emailChecker', data: {
      'password': password,
    }).then((value) {
      resetModel = SimpleModel.fromJson(value?.data);
      emit(SuccessResetPasswordState(resetModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorResetPasswordState(error));
    });
  }
}
