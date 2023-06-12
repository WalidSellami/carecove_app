class ProfilePharmacistModel {

  bool? status;
  PharmacistModel? pharmacist;

  ProfilePharmacistModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    pharmacist = (json['pharmacist'] != null) ? PharmacistModel.fromJson(json['pharmacist']) : null;
  }

}


class PharmacistModel {
  int? pharmacistId;
  int? pharmacyId;
  int? userId;
  UserModel? user;

  PharmacistModel.fromJson(Map<String , dynamic> json) {
    pharmacistId = json['pharmacist_id'];
    pharmacyId = json['pharmacy_id'];
    userId = json['user_id'];
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
  }


}


class UserModel {

  String? name;
  String? role;
  int? phone;
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