class CardModel {

  bool? status;
  CardData? card;

  CardModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    card = json['card'] != null ? CardData.fromJson(json['card']) : null;
  }

}


class CardData {

  int? cardId;
  int? age;
  dynamic weight;
  String? sickness;
  int? patientId;
  int? doctorId;
  PatientData? patient;
  DoctorCardData? doctor;

  CardData.fromJson(Map<String , dynamic> json) {

    cardId = json['card_id'];
    age = json['age'];
    weight = json['weight'];
    sickness = json['sickness'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    patient = PatientData.fromJson(json['patient']);
    doctor =  DoctorCardData.fromJson(json['doctor']);
  }


}


class PatientData {
  int? patientId;
  String? address;
  UserModel? user;

  PatientData.fromJson(Map<String , dynamic> json) {
    patientId = json['patient_id'];
    address = json['address'];
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
  }


}

class DoctorCardData {
  int? doctorId;
  UserModel? user;

  DoctorCardData.fromJson(Map<String , dynamic> json) {
    doctorId = json['doctor_id'];
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