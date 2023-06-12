class AllUsersModel {

  bool? status;
  List<AllUserModel> users = [];

  AllUsersModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    json['users'].forEach((element) {
      users.add(AllUserModel.fromJson(element));
    });

  }

}


class AllUserModel {

  String? name;
  String? role;
  String? phone;
  String? email;
  String? profileImage;
  int? codeAuth;
  int? userId;
  AdminUserDataModel? admin;
  DoctorUserDataModel? doctor;
  PatientUserDataModel? patient;
  PharmacistUserDataModel? pharmacist;

  AllUserModel.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    codeAuth = json['code_auth'];
    userId = json['user_id'];
    admin = (json['admin'] != null) ?  AdminUserDataModel.fromJson(json['admin']) : null;
    doctor = (json['doctor'] != null) ?  DoctorUserDataModel.fromJson(json['doctor']) : null;
    patient = (json['patient'] != null) ?  PatientUserDataModel.fromJson(json['patient']) : null;
    pharmacist = (json['pharmacist'] != null) ?  PharmacistUserDataModel.fromJson(json['pharmacist']) : null;

  }



}


class AdminUserDataModel {
  int? adminId;
  String? address;


  AdminUserDataModel.fromJson(Map<String , dynamic> json) {
    adminId = json['admin_id'];
    address = json['address'];

  }


}

class DoctorUserDataModel {
  int? doctorId;
  String? localAddress;
  String? speciality;
  String? certificatImage;

  DoctorUserDataModel.fromJson(Map<String , dynamic> json) {
    doctorId = json['doctor_id'];
    localAddress = json['local_address'];
    speciality = json['specialty'];
    certificatImage = json['certificat_image'];
  }


}


class PharmacistUserDataModel {
  int? pharmacistId;
  String? certificatImage;
  AllUserModel? user;
  PharmacyPharmacistDataModel? pharmacy;

  PharmacistUserDataModel.fromJson(Map<String , dynamic> json) {
    pharmacistId = json['pharmacist_id'];
    certificatImage = json['certificat_image'];
    user = (json['user'] != null) ? AllUserModel.fromJson(json['user']) : null;
    pharmacy = (json['pharmacy'] != null) ? PharmacyPharmacistDataModel.fromJson(json['pharmacy']) : null;
  }


}

class PharmacyPharmacistDataModel {

  int? pharmacyId;
  String? name;
  String? localAddress;

  PharmacyPharmacistDataModel.fromJson(Map<String , dynamic> json) {

    pharmacyId = json['pharmacy_id'];
    name = json['pharmacy_name'];
    localAddress = json['local_address'];
  }

}


class PatientUserDataModel {
  int? patientId;
  String? address;

  PatientUserDataModel.fromJson(Map<String , dynamic> json) {
    patientId = json['patient_id'];
    address = json['address'];
  }


}


