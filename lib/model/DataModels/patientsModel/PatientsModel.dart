class PatientsModel {

  bool? status;
  List<PatientDataModel> patients = [];

  PatientsModel.fromJson(Map<String , dynamic> json) {
     status = json['status'];
     json['patients'].forEach((element){
       patients.add(PatientDataModel.fromJson(element));
     });
  }

}


class PatientDataModel {
  int? patientId;
  String? address;
  UserModel? user;

  PatientDataModel.fromJson(Map<String , dynamic> json) {
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
  int? codeAuth;
  int? userId;


  UserModel.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    codeAuth = json['code_auth'];
    userId = json['user_id'];

  }



}