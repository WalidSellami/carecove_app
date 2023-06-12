class ProfileDoctorModel {

  bool? status;
  DoctorModel? doctor;

  ProfileDoctorModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    doctor = (json['doctor'] != null) ? DoctorModel.fromJson(json['doctor']) : null;
  }

}


class DoctorModel {
  int? doctorId;
  String? localAddress;
  String? speciality;
  UserModel? user;

  DoctorModel.fromJson(Map<String , dynamic> json) {
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