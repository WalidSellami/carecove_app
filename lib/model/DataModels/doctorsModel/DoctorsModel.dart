class DoctorsModel {

  bool? status;
  List<DoctorDataModel> doctors = [];

  DoctorsModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    json['doctors'].forEach((element) {
      doctors.add(DoctorDataModel.fromJson(element));
    });
  }

}


class DoctorDataModel {
  int? doctorId;
  String? localAddress;
  String? speciality;
  UserModel? user;

  DoctorDataModel.fromJson(Map<String , dynamic> json) {
    doctorId = json['doctor_id'];
    localAddress = json['local_address'];
    speciality = json['specialty'];
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