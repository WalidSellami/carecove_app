class LoginModel {

  bool? status;
  String? message;
  UserModel? user;
  String? token;

  LoginModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    message = json['message'];
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