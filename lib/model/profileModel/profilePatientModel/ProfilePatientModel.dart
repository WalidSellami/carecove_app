class ProfilePatientModel {

  bool? status;
  PatientModel? patient;

  ProfilePatientModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    patient = (json['patient'] != null) ? PatientModel.fromJson(json['patient']) : null;
  }

}


class PatientModel {
  int? patientId;
  String? address;
  UserModel? user;

  PatientModel.fromJson(Map<String , dynamic> json) {
    patientId = json['patient_id'];
    address = json['address'];
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
  }


}


class UserModel {

  String? name;
  String? role;
  String? phone;
  String? email;
  String? profileImage;
  int? userId;


  UserModel.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    userId = json['user_id'];

  }



}