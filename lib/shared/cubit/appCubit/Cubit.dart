import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_final/model/DataModels/allUsersModel/AllUsersModel.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/cardModel/CardPatientModel.dart';
import 'package:project_final/model/DataModels/doctorsModel/DoctorsModel.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/model/DataModels/orderModel/OrderModel.dart';
import 'package:project_final/model/DataModels/patientClaimsModel/patientClaimsModel.dart';
import 'package:project_final/model/DataModels/patientsModel/PatientsModel.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/model/DataModels/pharmacyModel/PharmacyModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/AddPrescriptionModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/DataModels/userClaimsModel/UserClaimsModel.dart';
import 'package:project_final/model/mapModels/PlaceDetailsModel/PlaceDetailsModel.dart';
import 'package:project_final/model/mapModels/directionModel/DirectionModel.dart';
import 'package:project_final/model/profileModel/profileAdminModel/ProfileAdminModel.dart';
import 'package:project_final/model/profileModel/profileDoctorModel/ProfileDoctorModel.dart';
import 'package:project_final/model/profileModel/profilePatientModel/ProfilePatientModel.dart';
import 'package:project_final/model/profileModel/profilePharmacistModel/ProfilePharmacistModel.dart';
import 'package:project_final/model/profileModel/profileUserModel/ProfileModel.dart';
import 'package:project_final/modules/admin/homeScreen/AdminHomeScreen.dart';
import 'package:project_final/modules/doctor/patientsScreen/PatientsScreen.dart';
import 'package:project_final/modules/doctor/stocksScreen/StocksScreen.dart';
import 'package:project_final/modules/patient/doctorsScreen/DoctorsScreen.dart';
import 'package:project_final/modules/patient/homeScreen/PatientHomeScreen.dart';
import 'package:project_final/modules/patient/orderStatusScreen/OrderStatusScreen.dart';
import 'package:project_final/modules/pharmacist/homeScreen/PharmacistHomeScreen.dart';
import 'package:project_final/modules/pharmacist/mapScreen/MapScreen.dart';
import 'package:project_final/modules/pharmacist/stockScreen/StockScreen.dart';
import 'package:project_final/modules/settings/SettingsScreen.dart';
import 'package:project_final/shared/EndPoints.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/network/remot/DioHelper.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/shared/notification/Notifications.dart';
import 'package:pusher_client/pusher_client.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<GButton> adminItems = const [
    GButton(
      icon: EvaIcons.home,
      text: 'Home',
    ),
    GButton(
      icon: EvaIcons.settings,
      text: 'Settings',
    ),
  ];

  List<GButton> doctorItems = const [
    GButton(
      icon: Icons.people_rounded,
      text: 'Patients',
    ),
    GButton(
      icon: Icons.medication_rounded,
      text: 'Pharmacies',
    ),
    GButton(
      icon: EvaIcons.settings,
      text: 'Settings',
    ),
  ];

  List<GButton> patientItems = const [
    GButton(
      icon: EvaIcons.home,
      text: 'Home',
    ),
    GButton(
      icon: Icons.people_rounded,
      text: 'Doctors',
    ),
    GButton(
      icon: EvaIcons.activityOutline,
      text: 'Order Status',
    ),
    GButton(
      icon: EvaIcons.settings,
      text: 'Settings',
    ),
  ];

  List<Widget> adminScreens = [
    const AdminHomeScreen(),
    const SettingsScreen(),
  ];

  List<Widget> pharmacistScreens = [
    const PharmacistHomeScreen(),
    const StockScreen(),
    const MapScreen(),
    const SettingsScreen(),
  ];

  List<Widget> doctorScreens = [
    const PatientsScreen(),
    StocksScreen(),
    const SettingsScreen(),
  ];

  List<Widget> patientScreens = [
    const PatientHomeScreen(),
    DoctorsScreen(),
    OrderStatusScreen(),
    const SettingsScreen(),
  ];

  List<String> adminTitles = ['Home', 'Settings'];

  List<String> pharmacistTitles = ['Home', 'Stock', 'Map', 'Settings'];

  List<String> doctorTitles = ['Patients', 'Pharmacies', 'Settings'];

  List<String> patientTitles = ['Home', 'Doctors', 'Order Status', 'Settings'];

  void changeNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavAppState());
  }

  ProfileModel? profile;

  SimpleModel? simpleModel;

  void getProfile() {
    emit(LoadingGetProfileAppState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      profile = ProfileModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessGetProfileAppState(profile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }

      emit(ErrorGetProfileAppState(error));
    });
  }

  void resendCodeAuth(context) {
    emit(LoadingResendCodeAuthAppState());
    DioHelper.putData(
      url: '/api/user/update-code-auth/$userId',
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Code send with success', state: ToastStates.success ,  context: context);
      getProfile();
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorResendCodeAuthAppState(error));
    });
  }


  void changePassword({
    required String password,
  }) {
    emit(LoadingChangePasswordAppState());
    DioHelper.putData(
      url: '/api/user/change-password/$userId',
      data: {
        'password': password,
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessChangePasswordAppState(simpleModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorChangePasswordAppState(error));
      // showFlutterToast(message: 'Error , try again', state: ToastStates.error);
    });
  }


  var picker = ImagePicker();

  XFile? imageProfile;

  Future<void> getImageProfile(context , ImageSource source) async{

    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null){

      imageProfile = XFile(pickedFile.path);
      emit(SuccessGetImageProfileAppState());

    }else {

      // showFlutterToast(message: 'No image selected', state: ToastStates.error , context: context);
      emit(ErrorGetImageProfileAppState());
    }


  }

  void removeImageProfile(){
    imageProfile = null;
    emit(SuccessRemoveImageAppState());

  }


  void logOut({
    required dynamic idUser,
}) {

    emit(LoadingLogOutAppState());
    DioHelper.postData(
        url: LOG_OUT,
        data: {
          'user_id': idUser,
        },
     token: token,
    ).then((value) {
      emit(SuccessLogOutAppState());
    }).catchError((error) {

      emit(ErrorLogOutAppState(error));
    });

  }

  MedicationsModel? medicationsModel;

  MedicationsStockModel? medicationsStockModel;


  void addClaimToAdmin({
    required String message,
    required String claimDate,
    required String body,
    required dynamic idUser,
}) {

    emit(LoadingAddClaimToAdminAppState());
    DioHelper.postData(
        url: ADD_CLAIM_TO_ADMIN,
        data: {
          'message': message,
          'claim_date': claimDate,
          'user_id': userId,
          'body': body,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddClaimToAdminAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddClaimToAdminAppState(error));
    });

  }

  void checkAccountUser() {
    emit(LoadingCheckAccountUserAppState());
    DioHelper.postData(
        url: CHECK_ACCOUNT,
        data: {
          'user_id': userId,
        },
    ).then((value) {

        simpleModel = SimpleModel.fromJson(value?.data);
        // print(value?.data);
        emit(SuccessCheckAccountUserAppState(simpleModel!));


    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckAccountUserAppState(error));
    });
  }

  // **************************************   Admin   ************************************** //

  ProfileAdminModel? adminProfile;

  void getProfileAdmin() {
    emit(LoadingGetProfileAdminAppState());
    DioHelper.getData(
      url: '/api/admin/profile-admin/$userId',
      token: token,
    ).then((value) {
      adminProfile = ProfileAdminModel.fromJson(value?.data);
      emit(SuccessGetProfileAdminAppState(adminProfile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetProfileAdminAppState(error));
    });
  }



  void updateProfileAdmin({
    required String name,
    required String phone,
    required String address,
    required dynamic idUser,
    required BuildContext context,

  }) {

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/admin/update-profile/$idUser',
      data: {
        'name': name,
        'phone': phone,
        'address': address,
      },
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getProfileAdmin();
    }).catchError((error) {
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateProfileAppState(error));

    });



  }

  void updateProfileAdminWithImage({
    required String name,
    required String phone,
    required String address,
    required BuildContext context,

  }) async {

    List<int> imageBytes = await imageProfile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/admin/update-profile-with-image/$userId',
      data: {
        'name': name,
        'profile_image': base64Image,
        'phone': phone,
        'address': address,
      },
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);

      getProfile();
      getProfileAdmin();
      removeImageProfile();

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });

  }


  AllUsersModel? allUsersModel;

  void getAllUsers() {

    emit(LoadingGetAllUsersAppState());
    DioHelper.getData(
        url: ALL_USERS,
        token: token,
    ).asStream().listen((value) {

      allUsersModel = AllUsersModel.fromJson(value?.data);
      emit(SuccessGetAllUsersAppState());

    });

  }

  void addUserAccount({
    required String name,
    required String role,
    required String phone,
    required String address,
    required String email,
    required String password,
    required BuildContext context,
}) {

    emit(LoadingAddAccountUserAppState());
    DioHelper.postData(
        url: ADD_ACCOUNT_USER,
        data: {
          'name': name,
          'role': role,
          'phone': phone,
          'address': address,
          'email': email,
          'password': password,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddAccountUserAppState(simpleModel!));

    }).catchError((error) {

      if(error.response != null) {
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
      }
       emit(ErrorAddAccountUserAppState(error));
    });


  }

  void deleteAccountUser({
    required dynamic idUser,
  }) {

    emit(LoadingDeleteAccountUserAppState());
    DioHelper.deleteData(
      url: '/api/admin/delete-user/$idUser',
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessDeleteAccountUserAppState(simpleModel!));
    }).catchError((error) {

      emit(ErrorDeleteAccountUserAppState(error));
    });

  }


  void updateProfileDoctorData({
    required String name,
    required String phone,
    required String localAddress,
    required String specialty,
    required dynamic idUser,
    required BuildContext context,

  }) {

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/doctor/update-profile/$idUser',
      data: {
        'name': name,
        'phone': phone,
        'local_address': localAddress,
        'specialty': specialty,
      },
      token: token,
    ).then((value) {

      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      emit(SuccessUpdateProfileAppState());
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });



  }

  void updateProfilePharmacistData({
    required String name,
    required String phone,
    required String localAddress,
    required String pharmacyName,
    required dynamic idUser,
    required dynamic idPharmacy,
    required BuildContext context,

  }) {
    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/pharmacist/update-profile/$idUser/pharmacy/$idPharmacy',
      data: {
        'name': name,
        'phone': phone,
        'local_address': localAddress,
        'pharmacy_name': pharmacyName,
      },
      token: token,
    ).then((value) {
      showFlutterToast(
          message: 'Update done successfully', state: ToastStates.success , context: context);
      emit(SuccessUpdateProfileAppState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));
    });
  }

  void updateProfilePatientData({
    required String name,
    required String phone,
    required String address,
    required dynamic idUser,
    required BuildContext context,

  }) {

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/patient/update-profile/$idUser',
      data: {
        'name': name,
        'phone': phone,
        'address': address,
      },
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      emit(SuccessUpdateProfileAppState());
    }).catchError((error) {
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateProfileAppState(error));

    });
  }


  UserClaimsModel? userClaimsModel;

  void getAllUserClaims() {

    emit(LoadingGetAllUserClaimsAppState());
    DioHelper.getData(
      url: GET_USER_CLAIMS,
      token: token,
    ).asStream().listen((value) {

      userClaimsModel = UserClaimsModel.fromJson(value?.data);
      emit(SuccessGetAllUserClaimsAppState(userClaimsModel!));
    });
  }



  void changeStatusUserNotice({
    required dynamic idUserClaim,
  }) {
    DioHelper.postData(
      url: CHANGE_STATUS_USER_CLAIM,
      data: {
        'user_claim_id': idUserClaim,
      },
      token: token,
    ).then((value) {
      getAllUserClaims();
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorChangeStatusUserClaimsAppState(error));
    });

  }


  void removeUserClaim({
    required dynamic idUserClaim,
}) {

    emit(LoadingRemoveUserClaimAppState());
    DioHelper.deleteData(
        url: DELETE_USER_CLAIM,
        data: {
          'user_claim_id': idUserClaim,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRemoveUserClaimAppState(simpleModel!));
    }).catchError((error) {

      emit(ErrorRemoveUserClaimAppState(error));
    });

  }


  void searchUser({
    required String name,
}) {

    emit(LoadingSearchAppState());
    DioHelper.postData(
        url: SEARCH_USER,
        data: {
          'name': name,
        },
        token: token
    ).then((value) {

      allUsersModel = AllUsersModel.fromJson(value?.data);
      emit(SuccessSearchAppState());
    }).catchError((error) {

      emit(ErrorSearchAppState(error));
    });
  }


  void clearSearchUser() {
    allUsersModel = null;
    emit(SuccessClearAppState());
  }




// **************************************   Doctor   ************************************** //

  ProfileDoctorModel? doctorProfile;

  void getProfileDoctor() {
    emit(LoadingGetProfileDoctorAppState());
    DioHelper.getData(
      url: '/api/doctor/profile-doctor/$userId',
      token: token,
    ).then((value) {
      doctorProfile = ProfileDoctorModel.fromJson(value?.data);
      emit(SuccessGetProfileDoctorAppState(doctorProfile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetProfileDoctorAppState(error));
    });
  }

  void updateProfileDoctor({
    required String name,
    required String phone,
    required String localAddress,
    required String specialty,
    required BuildContext context,

}) {

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
        url: '/api/doctor/update-profile/$userId',
        data: {
          'name': name,
          'phone': phone,
          'local_address': localAddress,
          'specialty': specialty,
        },
        token: token,
    ).then((value) {

      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getProfileDoctor();
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });



  }

  void updateProfileDoctorWithImage({
    required String name,
    required String phone,
    required String localAddress,
    required String specialty,
    required BuildContext context,

  }) async {

    List<int> imageBytes = await imageProfile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/doctor/update-profile-with-image/$userId',
      data: {
        'name': name,
        'profile_image': base64Image,
        'phone': phone,
        'local_address': localAddress,
        'specialty': specialty,
      },
      token: token,
    ).then((value) {

      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getProfileDoctor();
      removeImageProfile();
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });



  }



  void addPatientAccount({
    required String name,
    required String role,
    required String phone,
    required String address,
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(LoadingAddPatientAccountAppState());
    DioHelper.postData(
      url: ADD_PATIENT,
      data: {
        'name': name,
        'role': role,
        'phone': phone,
        'email': email,
        'password': password,
        'address': address,
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddPatientAccountAppState(simpleModel!));
    }).catchError((error) {
      if(error.response != null){
        final responseData = error.response!.data;
        final errors = responseData['errors'] as Map<String , dynamic>;
        if(errors.containsKey('email')) {
          final emailErrors = errors['email'] as List<dynamic>;
          final errorMessage = emailErrors.join('\n');
          showFlutterToast(message: errorMessage, state: ToastStates.error, context: context);

        }else if(errors.containsKey('phone')) {
          final phoneErrors = errors['phone'] as List<dynamic>;
          final errorMessage = phoneErrors.join('\n');
          showFlutterToast(message: errorMessage, state: ToastStates.error, context: context);
        }
      }
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddPatientAccountAppState(error));
    });
  }

  PatientsModel? patientsModel;

  void getAllPatients() {

    emit(LoadingGetAllPatientsAppState());

    DioHelper.getData(
      url: ALL_PATIENTS,
      token: token,
    ).asStream().listen((value) {

      patientsModel = PatientsModel.fromJson(value?.data);
      emit(SuccessGetAllPatientsAppState());

    });
  }

  void searchPatient(String name) {

    emit(LoadingSearchPatientAppState());
    DioHelper.postData(
        url: SEARCH_PATIENT,
        data: {
          'name': name,
        },
        token: token,
    ).then((value) {

      patientsModel = PatientsModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessSearchPatientAppState());

    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchPatientAppState(error));
    });


  }


  void clearSearchPatient() {
    patientsModel = null;
    emit(SuccessClearAppState());
  }


  void addCardPatient({
    required String age,
    required String weight,
    required String sickness,
    required String body,
    required dynamic idPatient,
    required dynamic idDoctor,
    required dynamic idUserPatient,
}) {

    emit(LoadingAddCardPatientAppState());
    DioHelper.postData(
        url: ADD_CARD_PATIENT,
        data: {
          'age': age,
          'weight': weight,
          'sickness': sickness,
          'patient_id': idPatient,
          'doctor_id': idDoctor,
          'body': body,
          'userId': idUserPatient,
        },
        token: token,
    ).then((value) {

          simpleModel = SimpleModel.fromJson(value?.data);
          emit(SuccessAddCardPatientAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddCardPatientAppState(error));
    });


  }

  CardModel? cardModel;

  void getCardPatient({
    required dynamic idPatient,
}) {

    emit(LoadingGetCardPatientAppState());
    DioHelper.getData(
        url: '/api/doctor/card/$doctorId/patient/$idPatient',
        token: token,
    ).then((value) {

      cardModel = CardModel.fromJson(value?.data);
      emit(SuccessGetCardPatientAppState(cardModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetCardPatientAppState(error));
    });

  }

  void clearCardData() {
    cardModel = null;
    emit(ClearCardDataAppState());

  }


  void editCardPatient({
    required String age,
    required String weight,
    required String sickness,
    required String body,
    required dynamic cardId,
    required dynamic idUserPatient,
  }) {

    emit(LoadingEditCardPatientAppState());
    DioHelper.putData(
      url: UPDATE_CARD_PATIENT,
      data: {
        'age': age,
        'weight': weight,
        'sickness': sickness,
        'card_id': cardId,
        'body': body,
        'userId': idUserPatient,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditCardPatientAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorEditCardPatientAppState(error));
    });

  }


  void deleteCardPatient({
    required dynamic cardId,
    required String body,
    required dynamic idUserPatient,
}) {

    emit(LoadingDeleteCardPatientAppState());
    DioHelper.deleteData(
        url: DELETE_CARD_PATIENT,
        data: {
          'card_id': cardId,
          'body': body,
          'userId': idUserPatient,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessDeleteCardPatientAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorDeleteCardPatientAppState(error));
    });

  }


  PharmaciesModel? pharmaciesModel;
  void getAllPharmacies() {

    emit(LoadingGetAllPharmaciesAppState());
    DioHelper.getData(
        url: ALL_PHARMACIES,
        token: token,
    ).then((value) {

      pharmaciesModel = PharmaciesModel.fromJson(value?.data);
      emit(SuccessGetAllPharmaciesAppState(pharmaciesModel!));

    }).catchError((error) {

      emit(ErrorGetAllPharmaciesAppState(error));
    });


  }

  void searchPharmacy(String name) {

    emit(LoadingSearchPharmacyAppState());
    DioHelper.postData(
      url: SEARCH_PHARMACY,
      data: {
        'pharmacy_name': name,
      },
      token: token,
    ).then((value) {

      pharmaciesModel = PharmaciesModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessSearchPharmacyAppState());

    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchPharmacyAppState(error));
    });


  }

  void clearSearchPharmacy() {
    pharmaciesModel = null;
    emit(SuccessClearAppState());
  }


  void getAllMedicationsFromStockPharmacy({
    required dynamic idPharmacy,
}) {

    emit(LoadingGetAllMedicationsFromStockAppState());
    DioHelper.postData(
      url: GET_ALL_MEDICATION_FROM_STOCK_PHARMACY,
      data: {
        'pharmacy_id': idPharmacy,
      },
      token: token,
    ).asStream().listen((value) {

      medicationsStockModel = MedicationsStockModel.fromJson(value?.data);
      emit(SuccessGetAllMedicationsFromStockAppState(medicationsStockModel!));

    });

  }

  void clearSearchMedicationInStockPharmacy() {
    medicationsStockModel = null;
    emit(SuccessClearAppState());
  }


  void searchMedicationInStockPharmacy({
    required String name,
    required dynamic idPharmacy,
  }) {

    emit(LoadingSearchMedicationInStockAppState());
    DioHelper.postData(
      url: SEARCH_MEDICATION_IN_STOCK_PHARMACY,
      data: {
        'pharmacy_id': idPharmacy,
        'name': name,
      },
      token: token,
    ).then((value) {

      medicationsStockModel = MedicationsStockModel.fromJson(value?.data);
      emit(SuccessSearchMedicationsInStockAppState(medicationsStockModel!));

    }).catchError((error) {

      if(kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchMedicationsInStockAppState(error));
    });

  }

  void clearMedicationsStock() {
    medicationsStockModel = null;
    emit(SuccessClearAppState());
  }


  AddPrescriptionModel? addPrescriptionModel;

  void addPrescription({
    required dynamic idCard,
    required String date,
    required String body,
    required dynamic idUserPatient,

  }) {

    emit(LoadingAddPrescriptionAppState());
    DioHelper.postData(
      url: ADD_PRESCRIPTION,
      data: {
        'card_id': idCard,
        'prescription_date': date,
        'body': body,
        'userId': idUserPatient,
      },
      token: token,
    ).then((value) {

      addPrescriptionModel = AddPrescriptionModel.fromJson(value?.data);
      emit(SuccessAddPrescriptionAppState(addPrescriptionModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddPrescriptionAppState(error));
    });


  }


  void addPrescriptionMedication({
    required dynamic idPrescription,
    required String dosage,
    required String quantity,
    required dynamic idMedication,
    required String body,
    required dynamic idUserPatient,

}) {

    emit(LoadingAddPrescriptionMedicationAppState());
    DioHelper.postData(
        url: ADD_PRESCRIPTION_MEDICATION,
        data: {
          'prescription_id': idPrescription,
          'medication_id': idMedication,
          'dosage': dosage,
          'quantity': quantity,
          'body': body,
          'userId': idUserPatient
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddPrescriptionMedicationAppState(simpleModel!));

    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddPrescriptionMedicationAppState(error));
    });


  }



  PrescriptionsModel? prescriptionsModel;


  void getAllPatientPrescriptions({
    required dynamic idCard,
  }) {
    emit(LoadingGetPrescriptionsAppState());
    DioHelper.getData(
      url: '/api/doctor/all-prescriptions/$idCard',
      token: token,
    ).asStream().listen((value) {
      prescriptionsModel = PrescriptionsModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessGetPrescriptionsAppState());
    });

  }

  void clearDataPrescription() {
    prescriptionsModel = null;
    emit(SuccessClearAppState());
  }


  void editPrescription({
    required dynamic idPrescription,
    required String date,
    required String body,
    required dynamic idUserPatient,

  }) {

    emit(LoadingEditPrescriptionAppState());
    DioHelper.putData(
      url: '/api/doctor/edit-prescription/$idPrescription',
      data: {
        'prescription_date': date,
        'body': body,
        'userId': idUserPatient
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditPrescriptionAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorEditPrescriptionAppState(error));
    });


  }

  void editDosageMedicationPrescription({
    required dynamic idPrescriptionMedication,
    required String dosage,
    required String quantity,
    required String body,
    required dynamic idUserPatient,

  }) {

    emit(LoadingEditDosageMedicationPrescriptionAppState());
    DioHelper.putData(
      url: '/api/doctor/edit-medications-prescription/$idPrescriptionMedication',
      data: {
        'dosage': dosage,
        'quantity': quantity,
        'body': body,
        'userId': idUserPatient
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditDosageMedicationPrescriptionAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorEditDosageMedicationPrescriptionAppState(error));
    });


  }



  void removePrescription({
    required dynamic idPrescription,
    required String body,
    required dynamic idUserPatient,
  }) {

    emit(LoadingRemovePrescriptionAppState());
    DioHelper.deleteData(
      url: '/api/doctor/remove-prescription/$idPrescription',
      data: {
        'body': body,
        'userId': idUserPatient
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRemovePrescriptionAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorRemovePrescriptionAppState(error));
    });


  }

  void removeMedicationFromPrescription({
    required dynamic idPrescriptionMedication,
    required String body,
    required dynamic idUserPatient,

  }) {

    emit(LoadingRemoveMedicationFromPrescriptionAppState());
    DioHelper.deleteData(
      url: '/api/doctor/remove-medication-prescription/$idPrescriptionMedication',
      data: {
        'body': body,
        'userId': idUserPatient
      },
      token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRemoveMedicationFromPrescriptionAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorRemoveMedicationFromPrescriptionAppState(error));
    });


  }


  void checkExistMedicationInPrescription({
    required dynamic idPrescription,
    required dynamic idMedication
}) {

    emit(LoadingCheckExistMedicationPrescriptionAppState());
    DioHelper.postData(
        url: CHECK_EXIST_MEDICATION_PRESCRIPTION,
        data: {
          'prescription_id': idPrescription,
          'medication_id': idMedication,
        },
        token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessCheckExistMedicationPrescriptionAppState(simpleModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckExistMedicationPrescriptionAppState(error));
    });

  }

  PatientClaimsModel? patientClaimsModel;

  void getAllPatientClaims() {

    emit(LoadingGetAllPatientClaimsAppState());
    DioHelper.getData(
        url: '/api/doctor/all-patient-claims/$doctorId',
        token: token,
    ).asStream().listen((value) {

      patientClaimsModel = PatientClaimsModel.fromJson(value?.data);
      emit(SuccessGetAllPatientClaimsAppState(patientClaimsModel!));
    });
  }



  void changeStatusNotice({
    required dynamic idPatientClaim,
}) {
    DioHelper.postData(
        url: CHANGE_STATUS_CLAIM,
        data: {
          'patient_claim_id': idPatientClaim,
        },
        token: token,
    ).then((value) {
      getAllPatientClaims();
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorChangeStatusPatientClaimsAppState(error));
    });


  }


  void getPharmaciesWithMedicationsPrescription({
    required dynamic medications,
    required dynamic quantities,
}) {

    emit(LoadingGetPharmaciesWithMedicationsPrescriptionAppState());
    DioHelper.getData(
        url: '/api/doctor/get-pharmacies/$medications/quantity/$quantities',
        token: token,
    ).then((value) {
      pharmaciesModel = PharmaciesModel.fromJson(value?.data);
      emit(SuccessGetPharmaciesWithMedicationsPrescriptionAppState(pharmaciesModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPharmaciesWithMedicationsPrescriptionAppState(error));
    });

  }

  void clearPharmacies() {
    pharmaciesModel = null;
    emit(SuccessClearAppState());
  }



  void sendOrderToPharmacy({
    required String orderDate,
    required String body,
    required dynamic idPrescription,
    required dynamic idPharmacy,
    required dynamic idUserPharmacist,
}) {

    emit(LoadingSendOrderToPharmacyAppState());
    DioHelper.postData(
        url: SEND_ORDER_TO_PHARMACY,
        data: {
         'order_date': orderDate,
         'prescription_id': idPrescription,
         'pharmacy_id': idPharmacy,
          'body': body,
          'userId': idUserPharmacist,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessSendOrderToPharmacyAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSendOrderToPharmacyAppState(error));
    });


  }


  // void checkSendOrder({
  //   required dynamic idPrescription,
  // }) {
  //
  //   emit(LoadingCheckSendOrderAppState());
  //   DioHelper.postData(
  //     url: CHECK_SEND_ORDER_TO_PHARMACY,
  //     data: {
  //       'prescription_id': idPrescription,
  //     },
  //     token: token,
  //   ).then((value) {
  //
  //     simpleModel = SimpleModel.fromJson(value?.data);
  //     emit(SuccessCheckSendOrderAppState(simpleModel!));
  //   }).catchError((error) {
  //
  //     if (kDebugMode) {
  //       print(error.toString());
  //     }
  //     emit(ErrorCheckSendOrderAppState(error));
  //   });
  //
  //
  // }


  void removeOrderRefused({
    required dynamic idPrescription
}) {

    emit(LoadingRemoveOrderRefusedAppState());
    DioHelper.deleteData(
      url: '/api/doctor/remove-order/$idPrescription',
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRemoveOrderRefusedAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorRemoveOrderRefusedAppState(error));
    });
  }


  void removePatientClaim({
    required dynamic idClaim
  }) {

    emit(LoadingRemoveOrderRefusedAppState());
    DioHelper.deleteData(
      url: REMOVE_PATIENT_CLAIM,
      data: {
        'patient_claim_id': idClaim,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRemovePatientClaimAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorRemovePatientClaimAppState(error));
    });
  }



// **************************************   Pharmacist   ************************************** //

  ProfilePharmacistModel? pharmacistProfile;

  void getProfilePharmacist() {
    emit(LoadingGetProfilePharmacistAppState());
    DioHelper.getData(
      url: '/api/pharmacist/profile-pharmacist/$userId',
      token: token,
    ).then((value) {
      pharmacistProfile = ProfilePharmacistModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessGetProfilePharmacistAppState(pharmacistProfile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetProfilePharmacistAppState(error));
    });
  }


  PharmacyModel? pharmacyProfile;

  void getPharmacy() {
    emit(LoadingGetPharmacyAppState());
    DioHelper.getData(
      url: '/api/pharmacist/pharmacy/$pharmacyId',
      token: token,
    ).then((value) {
      pharmacyProfile = PharmacyModel.fromJson(value?.data);
      emit(SuccessGetPharmacyAppState(pharmacyProfile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPharmacyAppState(error));
    });
  }


  void updateProfilePharmacist({
    required String name,
    required String phone,
    required String localAddress,
    required String pharmacyName,
    required BuildContext context,

  }) {
    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/pharmacist/update-profile/$userId/pharmacy/$pharmacyId',
      data: {
        'name': name,
        'phone': phone,
        'local_address': localAddress,
        'pharmacy_name': pharmacyName,
      },
      token: token,
    ).then((value) {
      showFlutterToast(
          message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getPharmacy();
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));
    });
  }


  void updateProfilePharmacistWithImage({
    required String name,
    required String phone,
    required String localAddress,
    required String pharmacyName,
    required BuildContext context

  }) async {

    List<int> imageBytes = await imageProfile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/pharmacist/update-profile-with-image/$userId/pharmacy/$pharmacistId',
      data: {
        'name': name,
        'profile_image': base64Image,
        'phone': phone,
        'local_address': localAddress,
        'pharmacy_name': pharmacyName,
      },
      token: token,
    ).then((value) {

      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getPharmacy();
      removeImageProfile();

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });

  }



  void getAllMedications() {

    emit(LoadingGetAllMedicationsAppState());
    DioHelper.getData(
        url: GET_ALL_MEDICATIONS,
        token: token,
    ).asStream().listen((value) {

      medicationsModel = MedicationsModel.fromJson(value?.data);
      emit(SuccessGetAllMedicationsAppState(medicationsModel!));
    });

  }

  void searchMedication(String name) {
    emit(LoadingSearchMedicationAppState());
    DioHelper.postData(
        url: SEARCH_MEDICATION,
        data: {
          'name': name,
        },
        token: token,
    ).then((value) {

      medicationsModel = MedicationsModel.fromJson(value?.data);
      emit(SuccessSearchMedicationAppState());

    }).catchError((error) {

      emit(ErrorSearchMedicationAppState(error));
    });

  }


  void checkExistMedicationInDb({
    required String name,
}) {

    emit(LoadingCheckExistMedicationInDbAppState());
    DioHelper.postData(
        url: CHECK_EXIST_MEDICATION,
        data: {
          'name': name,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessCheckExistMedicationInDbAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckExistMedicationInDbAppState(error));
    });

  }

  void addMedicationInDb({
    required String name,
    required String description,
    required BuildContext context,
}) {

    emit(LoadingAddMedicationInDbAppState());
    DioHelper.postData(
        url: ADD_MEDICATION_IN_DB,
        data: {
          'name': name,
          'description': description,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddMedicationInDbAppState(simpleModel!));
    }).catchError((error) {


      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddMedicationInDbAppState(error));
    });

  }

  void editMedicationInDb({
    required String name,
    required String description,
    required dynamic medicationId
  }) {

    emit(LoadingEditMedicationInDbAppState());
    DioHelper.putData(
      url: EDIT_MEDICATION_IN_DB,
      data: {
        'name': name,
        'description': description,
        'medication_id': medicationId,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditMedicationInDbAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      // showFlutterToast(message: error.toString(), state: ToastStates.error);
      emit(ErrorEditMedicationInDbAppState(error));
    });

  }



  XFile? medicationImage;

  Future<void> getMedicationImage(context , ImageSource source) async{

    final pickedFile = await picker.pickImage(source: source);
    if(pickedFile != null){

      medicationImage = XFile(pickedFile.path);

      emit(SuccessGetMedicationImageAppState());
    }else {

      // showFlutterToast(message: 'No image select!', state: ToastStates.error , context: context);
      emit(ErrorGetMedicationImageAppState());
    }

  }


  void addMedicationInStock({
    required String quantity,
    required String body,
    required String dateManufacture,
    required String dateExpiration,
    required dynamic medicationId,
    required dynamic pharmacyId,
    required dynamic idUser,
}) async {

    List<int> imageBytes = await medicationImage!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingAddMedicationInStockAppState());
    DioHelper.postData(
        url: ADD_MEDICATION_IN_STOCK,
        data: {
          'quantity': quantity,
          'medication_image': base64Image,
          'date_of_manufacture': dateManufacture,
          'date_of_expiration': dateExpiration,
          'medication_id': medicationId,
          'pharmacy_id': pharmacyId,
          'body': body,
          'userId' : idUser,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddMedicationInStockAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      // showFlutterToast(message: 'Error , something happen try later', state: ToastStates.error);
      emit(ErrorAddMedicationInStockAppState(error));
    });

  }


  void removeMedicationImage() {

    medicationImage = null;
    emit(SuccessRemoveImageAppState());
  }



  void getAllMedicationsFromStock() {

    emit(LoadingGetAllMedicationsFromStockAppState());
    DioHelper.getData(
        url: '/api/pharmacist/stock/all-medications/$pharmacyId',
        token: token,
    ).asStream().listen((value) {

      medicationsStockModel = MedicationsStockModel.fromJson(value?.data);
      // print(value?.data);
      emit(SuccessGetAllMedicationsFromStockAppState(medicationsStockModel!));

    });

  }

  void clearStockPharmacy() {
    medicationsStockModel = null;
    emit(SuccessClearAppState());
  }

  void editMedicationInStock({
    required dynamic stockId,
    required String quantity,
    required String body,
    required String dateManufacture,
    required String dateExpiration,
    required dynamic idUser,
  }) {

    emit(LoadingEditMedicationInStockAppState());
    DioHelper.putData(
      url: EDIT_MEDICATION_IN_STOCK,
      data: {
        'stock_id': stockId,
        'quantity': quantity,
        'date_of_manufacture': dateManufacture,
        'date_of_expiration': dateExpiration,
        'body': body,
        'userId' : idUser,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditMedicationInStockAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      // showFlutterToast(message: 'Error , something happen try later', state: ToastStates.error);
      emit(ErrorEditMedicationInStockAppState(error));
    });




  }


  void editMedicationInStockWithImage({
    required dynamic stockId,
    required String quantity,
    required String body,
    required String dateManufacture,
    required String dateExpiration,
    required dynamic idUser,
  }) async {

    List<int> imageBytes = await medicationImage!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingEditMedicationInStockAppState());
    DioHelper.putData(
      url: EDIT_MEDICATION_IN_STOCK_WITH_IMAGE,
      data: {
        'stock_id': stockId,
        'quantity': quantity,
        'medication_image' : base64Image,
        'date_of_manufacture': dateManufacture,
        'date_of_expiration': dateExpiration,
        'body': body,
        'userId' : idUser,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessEditMedicationInStockAppState(simpleModel!));

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      // showFlutterToast(message: 'Error , something happen try later', state: ToastStates.error);
      emit(ErrorEditMedicationInStockAppState(error));
    });

  }


  void searchMedicationStock(String name) {
    emit(LoadingSearchMedicationAppState());
    DioHelper.postData(
      url: SEARCH_MEDICATION_STOCK,
      data: {
        'name': name,
        'pharmacy_id': pharmacyId,
      },
      token: token,
    ).then((value) {

      medicationsStockModel = MedicationsStockModel.fromJson(value?.data);
      emit(SuccessSearchMedicationAppState());

    }).catchError((error) {

      emit(ErrorSearchMedicationAppState(error));
    });

  }



  void deleteMedicationStock({
    required dynamic stockId,
    required String body,
    required dynamic idUser,
}) {

    emit(LoadingDeleteMedicationFromStockAppState());
    DioHelper.deleteData(
        url: DELETE_MEDICATION_IN_STOCK,
        data: {
          'stock_id': stockId,
          'body': body,
          'userId' : idUser,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessDeleteMedicationFromStockAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorDeleteMedicationFromStockAppState(error));
    });

  }


  void clearSearchMedication() {
    medicationsModel = null;
    emit(SuccessClearAppState());
  }

  void clearSearchMedicationStock() {
    medicationsStockModel = null;
    emit(SuccessClearAppState());
  }


  void checkExistMedicationInStock({
    required dynamic idMedication,
    required dynamic idPharmacy,
}) {

    emit(LoadingCheckExitMedicationInStockAppState());
    DioHelper.postData(
        url: CHECK_EXIST_MEDICATION_IN_STOCK,
        data: {
          'medication_id': idMedication,
          'pharmacy_id': idPharmacy,
        },
        token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessCheckExistMedicationInStockAppState(simpleModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCheckExistMedicationInStockAppState(error));
    });

  }

  OrderModel? orderModel;

  void getPharmacyOrders() {

    emit(LoadingGetOrdersAppState());
    DioHelper.getData(
        url: '/api/pharmacist/get-orders/$pharmacyId',
        token: token,
    ).asStream().listen((value) {

      orderModel = OrderModel.fromJson(value?.data);
      // if (kDebugMode) {
      //   print(value?.data);
      // }
      emit(SuccessGetOrdersAppState(orderModel!));
    });
  }

  void clearOrders() {

    orderModel = null;
    emit(SuccessClearAppState());

  }


  void acceptOrder({
    required dynamic orderId,
    required String body,
    required dynamic idUserPatient,
}) {

    emit(LoadingChangeStatusOrderAppState());
    DioHelper.postData(
        url: ACCEPT_ORDER,
        data: {
          'order_id': orderId,
          'body': body,
          'userId': idUserPatient,
        },
        token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAcceptOrderAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorChangeStatusOrderAppState(error));
    });

  }


  void refuseOrder({
    required dynamic orderId,
    required String body,
    required dynamic idUserPatient,
  }) {

    emit(LoadingChangeStatusOrderAppState());
    DioHelper.postData(
      url: REFUSE_ORDER,
      data: {
        'order_id': orderId,
        'body': body,
        'userId': idUserPatient,
      },
      token: token,
    ).then((value) {

      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessRefuseOrderAppState(simpleModel!));
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorChangeStatusOrderAppState(error));
    });

  }


  void decrementQuantityMedication({
    required dynamic medications,
    required dynamic quantities,
    required dynamic idPharmacy
}) {

    emit(LoadingDecrementQuantityMedicationAppState());
    DioHelper.getData(
      url: '/api/pharmacist/stock/change-quantity-medication/$medications/quantity/$quantities/pharmacy/$idPharmacy',
      token: token,
    ).then((value) {

      getAllMedicationsFromStock();
    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorDecrementQuantityMedicationAppState(error));
    });

  }

  void searchOrder(String value) {

    emit(LoadingSearchOrderAppState());
    DioHelper.postData(
      url: '/api/pharmacist/search-order/$pharmacyId',
      data: {
        'name': value,
      },
      token: token,
    ).then((value) {

      orderModel = OrderModel.fromJson(value?.data);
      emit(SuccessSearchOrderAppState(orderModel!));

    }).catchError((error) {

      if(kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchOrderAppState(error));
    });
  }

  void clearSearchOrder() {
    orderModel = null;
    emit(SuccessClearAppState());
  }




  // Map
  MapController mapController = MapController();
  LatLng point = LatLng(36.7753606, 3.0601882);
  LatLng point2 = LatLng(0.0, 0.0);

  void changeTap(latLng) {
    point = latLng;
    point2 = LatLng(0, 0);
    points = [];
    emit(SuccessChangePositionTapAppState());
  }

  Dio dio = Dio();
  PlaceDetailsModel? placeDetails;
  String placeName = '';

  void getPlaceDetails({
    required latitude,
    required longitude,
  }) {
    // final apiUrl = "https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&zoom=18";

    dio.get('https://nominatim.openstreetmap.org/reverse', queryParameters: {
      'lat': latitude,
      'lon': longitude,
      'format': 'json',
      'zoom': '18',
    }).then((value) {
      placeDetails = PlaceDetailsModel.fromJson(value.data);
      placeName = placeDetails?.name ?? '';
      emit(SuccessGetPlaceDetailsAppState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPlaceDetailsAppState(error));
    });
  }

  void clear() {
    placeName = '';
    point = LatLng(0, 0);
    emit(SuccessClearAppState());
  }

  void searchPlace(value , context) {
     // final apiUrl = 'https://nominatim.openstreetmap.org/search?q=$namePlace&format=json&limit=1';

    dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': value,
        'format': 'json',
        'limit': '1',
      },
    ).then((value) {
      final lat = double.parse(value.data[0]['lat']);
      final lon = double.parse(value.data[0]['lon']);

      point = LatLng(lat, lon);

      mapController.move(point, 12.0);

      placeName = value.data[0]['display_name'];

      emit(SuccessSearchPlaceAppState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Place not founded!', state: ToastStates.error, context: context);
      emit(ErrorSearchPlaceAppState(error));
    });
  }

  DirectionModel? directionData;

  bool? isGetDirection;

  void searchPlaceDepDes(departure, destination, context) {
    // final apiUrl = 'https://nominatim.openstreetmap.org/search?q=$departure&format=json&limit=1';
    // final apiUrl2 = 'https://nominatim.openstreetmap.org/search?q=$destination&format=json&limit=1';

    emit(LoadingSearchPlaceDepDesAppState());

    dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': departure,
        'format': 'json',
        'limit': '1',
      },
    ).then((value) {
      dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': destination,
          'format': 'json',
          'limit': '1',
        },
      ).then((event) {
        final lat1 = double.parse(value.data[0]['lat']);
        final lon1 = double.parse(value.data[0]['lon']);

        point = LatLng(lat1, lon1);

        final lat2 = double.parse(event.data[0]['lat']);
        final lon2 = double.parse(event.data[0]['lon']);

        point2 = LatLng(lat2, lon2);

        mapController.move(point2, 15.0);

        mapController.move(point, 15.0);

        // emit(SuccessSearchPlaceDepDesAppState());

        getRoute(
            firstLatitude: lat1,
            firstLongitude: lon1,
            secondLatitude: lat2,
            secondLongitude: lon2);

        getDirection(
            firstLatitude: lat1,
            firstLongitude: lon1,
            secondLatitude: lat2,
            secondLongitude: lon2,
            context: context,
        );
      });

      // emit(SuccessSearchPlaceDepDesAppState());
    }).catchError((error) {

      showFlutterToast(message: error.toString(), state: ToastStates.error , context: context);
      emit(ErrorSearchPlaceDepDesAppState(error));
    });
  }


  void getDirection({
    required firstLatitude,
    required firstLongitude,
    required secondLatitude,
    required secondLongitude,
    required BuildContext context,
  }) {
    String url = 'https://api.openrouteservice.org/v2/directions/driving-car?'
        'api_key=5b3ce3597851110001cf6248aed8f3d52e7c4a26ad3f34a6847cb000'
        '&start=$firstLongitude,$firstLatitude&end=$secondLongitude,$secondLatitude';

    dio.get(url).then((value) {
      if (kDebugMode) {
        print(value.data);
      }
      directionData = DirectionModel.fromJson(value.data);
      // print(directionData?.features[0].properties?.segments[0].distance);
      // print(directionData?.features[0].properties?.segments[0].duration);
      emit(SuccessGetDirectionPlaceAppState());

    }).catchError((error) {

      // isGetDirection = false;
      if (kDebugMode) {
        print('Error Direction');
      }
      clearAll();
      emit(ErrorGetDirectionPlaceAppState(error));
      // showFlutterToast(message: error.toString(), state: ToastStates.error, context: context);
    });

  }

  List<LatLng> points = [];

  void getRoute({
    required firstLatitude,
    required firstLongitude,
    required secondLatitude,
    required secondLongitude,
  }) async {
    String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248aed8f3d52e7c4a26ad3f34a6847cb000&start=$firstLongitude,$firstLatitude&end=$secondLongitude,$secondLatitude";
    try {

      http.Response response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(response.body);
      List<LatLng> coordinates = List<LatLng>.from(data['features'][0]
      ['geometry']['coordinates']
          .map((coord) => LatLng(coord[1], coord[0])));
      points.addAll(coordinates);
      isGetDirection = true;
      emit(SuccessGetRouteAppState());

    }catch(error){
      if (kDebugMode) {
        print("Error: $error");
      }
      isGetDirection = false;
      clearAll();
      emit(ErrorGetRouteAppState(error));
    }
    // if (response.statusCode == 200) {
    //
    // } else {

      // showFlutterToast(
      //     message: 'Error: ${response.statusCode}', state: ToastStates.error , context: context);
    // }
  }

  void clearAll() {
    placeName = '';
    directionData = null;
    point = LatLng(0, 0);
    point2 = LatLng(0, 0);
    points = [];
    emit(SuccessClearAppState());
  }




// **************************************   Patient   ************************************** //

  ProfilePatientModel? patientProfile;

  void getProfilePatient() {
    emit(LoadingGetProfilePatientAppState());
    DioHelper.getData(
      url: '/api/patient/profile-patient/$userId',
      token: token,
    ).then((value) {
      patientProfile = ProfilePatientModel.fromJson(value?.data);
      emit(SuccessGetProfilePatientAppState(patientProfile!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetProfilePatientAppState(error));
    });
  }

  void updateProfilePatient({
    required String name,
    required String phone,
    required String address,
    required BuildContext context,

  }) {

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/patient/update-profile/$userId',
      data: {
        'name': name,
        'phone': phone,
        'address': address,
      },
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);
      getProfile();
      getProfilePatient();

    }).catchError((error) {
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorUpdateProfileAppState(error));

    });



  }

  void updateProfilePatientWithImage({
    required String name,
    required String phone,
    required String address,
    required BuildContext context,

  }) async {

    List<int> imageBytes = await imageProfile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    emit(LoadingUpdateProfileAppState());
    DioHelper.putData(
      url: '/api/patient/update-profile-with-image/$userId',
      data: {
        'name': name,
        'profile_image': base64Image,
        'phone': phone,
        'address': address,
      },
      token: token,
    ).then((value) {
      showFlutterToast(message: 'Update done successfully', state: ToastStates.success , context: context);

      getProfile();
      getProfilePatient();
      removeImageProfile();

    }).catchError((error) {

      if (kDebugMode) {
        print(error.toString());
      }
      showFlutterToast(message: 'Failed to update', state: ToastStates.error , context: context);
      emit(ErrorUpdateProfileAppState(error));

    });

  }


  CardPatientModel? cardPatientModel;

  void getAllCards({
    required dynamic idPatient,
}) {

    emit(LoadingGetAllCardsAppState());
    DioHelper.getData(
      url: '/api/patient/all-cards/$idPatient',
      token: token,
    ).asStream().listen((value) {

      cardPatientModel = CardPatientModel.fromJson(value?.data);
      emit(SuccessGetAllCardsAppState(cardPatientModel!));

    });

  }

  void clearCardPatientData() {
    cardPatientModel = null;
    emit(ClearCardDataAppState());

  }


  DoctorsModel? doctorsModel;

  void getAllDoctors() {

    emit(LoadingGetAllDoctorsAppState());
    DioHelper.getData(
        url: ALL_DOCTORS,
        token: token,
    ).asStream().listen((value) {

      doctorsModel = DoctorsModel.fromJson(value?.data);
      emit(SuccessGetAllDoctorsAppState(doctorsModel!));
    });

  }

  void addClaimToDoctor({
    required String message,
    required String claimDate,
    required String body,
    required dynamic idPatient,
    required dynamic idDoctor,
    required dynamic idUserDoctor,
}) {

    emit(LoadingAddClaimToDoctorAppState());
    DioHelper.postData(
        url: ADD_CLAIM_TO_DOCTOR,
        data: {
          'message' : message,
          'claim_date' : claimDate,
          'patient_id' : idPatient,
          'doctor_id' : idDoctor,
          'body': body,
          'userId': idUserDoctor,
        },
        token: token,
    ).then((value) {
      simpleModel = SimpleModel.fromJson(value?.data);
      emit(SuccessAddClaimToDoctorAppState(simpleModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorAddClaimToDoctorAppState(error));
    });

  }

  void getPrescriptions({
    required dynamic idCard,
  }) {
    emit(LoadingGetPrescriptionsAppState());
    DioHelper.getData(
      url: '/api/patient/all-prescriptions/$idCard',
      token: token,
    ).asStream().listen((value) {
      prescriptionsModel = PrescriptionsModel.fromJson(value?.data);
      emit(SuccessGetPrescriptionsAppState());
    });

  }

  void clearPrescriptions() {
    prescriptionsModel = null;
    emit(SuccessClearAppState());
  }


  void getPatientOrders() {
    emit(LoadingGetPatientOrdersAppState());
    DioHelper.getData(
        url: '/api/patient/orders/$patientId',
        token: token,
    ).then((value) {
      orderModel = OrderModel.fromJson(value?.data);
      emit(SuccessGetPatientOrdersAppState(orderModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetPatientOrdersAppState(error));
    });
  }


  void searchDoctor(String name) {

    emit(LoadingSearchDoctorAppState());
    DioHelper.postData(
        url: SEARCH_DOCTOR,
        data: {
          'name': name,
        },
        token: token,
    ).then((value) {
      doctorsModel = DoctorsModel.fromJson(value?.data);
      emit(SuccessSearchDoctorAppState(doctorsModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchDoctorAppState(error));
    });

  }

  void clearSearchDoctor() {
    doctorsModel = null;
    emit(SuccessClearAppState());
  }



  void searchCardPatient(String value) {

    emit(LoadingSearchCardPatientAppState());
    DioHelper.postData(
        url: '/api/patient/search-card/$patientId',
        data: {
          'name': value,
        },
        token: token,
    ).then((value) {

      cardPatientModel = CardPatientModel.fromJson(value?.data);
      emit(SuccessSearchCardPatientAppState(cardPatientModel!));

    }).catchError((error) {

      if(kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchCardPatientAppState(error));
    });
  }

  void clearSearchCardPatient() {
    cardPatientModel = null;
    emit(SuccessClearAppState());

  }


  void searchOrderPatient(String value) {

    emit(LoadingSearchOrderPatientAppState());
    DioHelper.postData(
      url: '/api/patient/search-order/$patientId',
      data: {
        'pharmacy_name': value,
      },
      token: token,
    ).then((value) {

      orderModel = OrderModel.fromJson(value?.data);
      emit(SuccessSearchOrderPatientAppState(orderModel!));

    }).catchError((error) {

      if(kDebugMode) {
        print(error.toString());
      }
      emit(ErrorSearchOrderPatientAppState(error));
    });
  }

  void clearSearchOrderPatient() {
    orderModel = null;
    emit(SuccessClearAppState());

  }



  // Notifications

  String? title;
  dynamic id;

  void sendNotification(context) {

    PusherOptions options = PusherOptions(
      host: 'api.pusher.com',
      encrypted: true,
      cluster: 'eu',
    );

    PusherClient pusher = PusherClient('7d789abe15357d526a93' ,
        options ,
        autoConnect: true ,
        enableLogging: true);

    pusher.onConnectionStateChange((state) {
      if (kDebugMode) {
        print('Pusher connection state: $state');
      }
    });

    pusher.connect();

    Channel channel1 = pusher.subscribe('popup-channel');

    Channel channel2 = pusher.subscribe('register-channel');

    channel1.bind('push-notification', (event) async {
      Map<String, dynamic> data = json.decode(event?.data ?? '');
      title = data['title'];
      String body = data['body'];
      id = data['userId'];

      dynamic hasInternet = CheckCubit.get(context).hasInternet;

      if(id is List) {
        // List<int> idList = json.decode(id).cast<int>();
        for(var idPhm in id) {
          if ((userId == idPhm) && (hasInternet == true)) {
            await Notifications().sendNotification(
                title: title!,
                body: body);

            if ((title == 'New Order')) {
              getPharmacyOrders();
            }

            if ((title == 'New Medication Stock') || (title == 'Edit Medication Stock') || (title == 'Delete Medication Stock')) {
              getAllMedicationsFromStock();
            }
          }
        }

      } else if(id is int) {

        if((userId == id) && (hasInternet == true)) {

          await Notifications().sendNotification(
              title: title!,
              body: body);

          if(title == 'New Claim') {
            getAllPatientClaims();
          }

          if((title == 'New Card' || title == 'Update Card' || title == 'Delete Card')) {
            getAllCards(idPatient: patientId);
          }

          if(title == 'Status Order') {
            getPatientOrders();
          }
        }
      }

      emit(SuccessSendNotificationAppState());
    });

    channel2.bind('user-register-notification', (event) async {
      Map<String, dynamic> data = json.decode(event?.data ?? '');

       String title = data['title'];
       String body = data['body'];

      dynamic hasInternet = CheckCubit.get(context).hasInternet;


      if((title == 'New User' || title == 'New User Claim')  && (profile?.user?.role == 'Admin') && (hasInternet == true)) {

        await Notifications().sendNotification(title: title, body: body);

        getAllUsers();
        getAllUserClaims();

       }

      emit(SuccessSendNotificationAppState());

    });
  }
}
