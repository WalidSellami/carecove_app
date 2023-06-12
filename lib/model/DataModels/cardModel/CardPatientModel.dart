class CardPatientModel {

  bool? status;
  List<CardsPatientData> cards = [];

  CardPatientModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    json['cards'].forEach((element) {
      cards.add(CardsPatientData.fromJson(element));
    });
  }

}


class CardsPatientData {
  int? cardId;
  int? age;
  dynamic weight;
  String? sickness;
  int? patientId;
  int? doctorId;
  DoctorData? doctor;

  CardsPatientData.fromJson(Map<String , dynamic> json) {

    cardId = json['card_id'];
    age = json['age'];
    weight = json['weight'];
    sickness = json['sickness'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    doctor = DoctorData.fromJson(json['doctor']);
  }


}


class DoctorData {
  int? doctorId;
  // String? localAddress;
  // String? speciality;
  UserModel? user;

  DoctorData.fromJson(Map<String , dynamic> json) {
    doctorId = json['doctor_id'];
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
  }


}


class UserModel {

  String? name;
  String? phone;
  String? email;
  int? userId;


  UserModel.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    userId = json['user_id'];

  }



}