class ProfileModel {

  bool? status;
  UserModel? user;
  String? token;

  ProfileModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
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