
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/model/DataModels/pharmacyModel/PharmacyModel.dart';
import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/DoctorCompleteModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/PharmacistCompleteModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/PharmacistCompleteSimpleModel.dart';
import 'package:project_final/model/authModels/registerModel/RegisterModel.dart';
import 'package:project_final/shared/EndPoints.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/registerCubit/States.dart';
import 'package:project_final/shared/network/remot/DioHelper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCubit extends Cubit<RegisterStates> {

  RegisterCubit() : super(InitialRegisterState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  RegisterModel? registerModel;

  void userRegister({
    required String fullName,
    required String job,
    required String phone,
    required String email,
    required String password,
    required BuildContext context,
}) {

    emit(LoadingRegisterState());

    DioHelper.postData(
        url: REGISTER,
        data: {
          'name': fullName,
          'role': job,
          'phone': phone,
          'email': email,
          'password': password,
        }).then((value) {

          registerModel = RegisterModel.fromJson(value?.data);
          emit(SuccessRegisterState(registerModel!));

    }).catchError((error) {

      if (error.response != null) {
        final responseData = error.response!.data;
        final errors = responseData['errors'] as Map<String, dynamic>;
        if (errors.containsKey('email')) {
          final emailErrors = errors['email'] as List<dynamic>;
          final errorMessage = emailErrors.join('\n');
          showFlutterToast(message: errorMessage,
              state: ToastStates.error,
              context: context);
        } else if (errors.containsKey('phone')) {
          final phoneErrors = errors['phone'] as List<dynamic>;
          final errorMessage = phoneErrors.join('\n');
          showFlutterToast(message: errorMessage,
              state: ToastStates.error,
              context: context);
        }

        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorRegisterState(error));
      }

    });

  }


  var picker = ImagePicker();

  XFile? imageCertificate;

  Future<void> getCertificateImage(context , ImageSource source) async{

    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null){

      imageCertificate = XFile(pickedFile.path);
      emit(SuccessGetImageRegisterState());

    }else {

      showFlutterToast(message: 'No image selected', state: ToastStates.error , context: context);
      emit(ErrorGetImageRegisterState());
    }


  }

  void removeImage(){
    imageCertificate = null;
    emit(RemoveImageRegisterState());

  }

  DoctorCompleteModel? doctorCompleteModel;
  PharmacistCompleteModel? pharmacistCompleteModel;
  PharmacistCompleteSimpleModel? pharmacistCompleteSimpleModel;


  void doctorCompleteRegister({
    required String addressLocal,
    required String specialty,
    required dynamic idUser,
}) async {

    List<int> imageBytes = await imageCertificate!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingDoctorCompleteRegisterState());

    DioHelper.postData(
        url: DOCTOR_REGISTER,
        data: {
          'local_address': addressLocal,
          'specialty': specialty,
          'certificat_image': base64Image,
          'user_id': idUser,
        },
        token: token,
    ).then((value) {

      doctorCompleteModel = DoctorCompleteModel.fromJson(value?.data);
      emit(SuccessDoctorCompleteRegisterState(doctorCompleteModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorDoctorCompleteRegisterState(error));

    });


  }


  void pharmacistCompleteRegister({
    required String addressLocal,
    required String pharmacyName,
    required dynamic idUser,
  }) async {

    List<int> imageBytes = await imageCertificate!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingPharmacistCompleteRegisterState());

    DioHelper.postData(
      url: PHARMACIST_REGISTER,
      data: {
        'local_address': addressLocal,
        'certificat_image': base64Image,
        'pharmacy_name': pharmacyName,
        'user_id': idUser,
      },
      token: token,
    ).then((value) {

      pharmacistCompleteModel = PharmacistCompleteModel.fromJson(value?.data);
      emit(SuccessPharmacistCompleteRegisterState(pharmacistCompleteModel!));


    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorPharmacistCompleteRegisterState(error));

    });


  }



  void pharmacistCompleteRegisterSimple({
    required dynamic idUser,
    required dynamic idPharmacy,
  }) async {

    List<int> imageBytes = await imageCertificate!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingPharmacistCompleteSimpleRegisterState());

    DioHelper.postData(
      url: PHARMACIST_REGISTER_SIMPLE,
      data: {
        'certificat_image' : base64Image,
        'user_id': idUser,
        'pharmacy_id': idPharmacy,
      },
      token: token,
    ).then((value) {

      pharmacistCompleteSimpleModel = PharmacistCompleteSimpleModel.fromJson(value?.data);
      emit(SuccessPharmacistCompleteSimpleRegisterState(pharmacistCompleteSimpleModel!));


    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorPharmacistCompleteSimpleRegisterState(error));

    });


  }

  PharmacyModel? pharmacyModel;
  SimpleModel? simpleModel;

  void checkExistPharmacy({
    required String pharmacyName,
}) {

    emit(LoadingCheckExistPharmacy());
    DioHelper.postData(
        url: CHECK_EXIST_PHARMACY,
        data: {
          'pharmacy_name' : pharmacyName,
        },
        token: token,
    ).then((value) {

      pharmacyModel = PharmacyModel.fromJson(value?.data);
      emit(SuccessCheckExistPharmacy(pharmacyModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckExistPharmacy(error));
    });



  }



  void checkPharmacyName({
    required String pharmacyName,
}) {

    emit(LoadingCheckPharmacyName());
    DioHelper.postData(
        url: CHECK_PHARMACY_NAME,
        data: {
          'pharmacy_name' : pharmacyName,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessCheckPharmacyName(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckPharmacyName(error));
    });



  }


  void deleteAccount({
    required dynamic idUser,
}) {

    emit(LoadingDeleteAccountState());
    DioHelper.deleteData(
        url: DELETE_ACCOUNT,
        data: {
          'user_id': idUser,
        },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessDeleteAccountState(simpleModel!));
    }).catchError((error) {

      emit(ErrorDeleteAccountState(error));
    });

  }




}