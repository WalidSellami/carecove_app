class ProfileAdminModel {

  bool? status;
  AdminModel? admin;

  ProfileAdminModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    admin = (json['admin'] != null) ? AdminModel.fromJson(json['admin']) : null;
  }

}


class AdminModel {
  int? adminId;
  String? address;
  UserModel? user;

  AdminModel.fromJson(Map<String , dynamic> json) {
    adminId = json['admin_id'];
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