class PharmaciesModel {

  bool? status;
  List<PharmacyDataModel> pharmacies = [];

  PharmaciesModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    json['pharmacies'].forEach((element){
      pharmacies.add(PharmacyDataModel.fromJson(element));
    });
  }

}


class PharmacyDataModel {
  int? pharmacyId;
  String? pharmacyName;
  String? localAddress;
  int? pharmacistId;
  List<PharmacistDataModel> pharmacists = [];

  PharmacyDataModel.fromJson(Map<String , dynamic> json) {
    pharmacyId = json['pharmacy_id'];
    pharmacyName = json['pharmacy_name'];
    localAddress = json['local_address'];
    json['pharmacists'].forEach((element) {
      pharmacists.add(PharmacistDataModel.fromJson(element));
    });
  }


}


class PharmacistDataModel {
  int? pharmacistId;
  UserModel? user;

  PharmacistDataModel.fromJson(Map<String , dynamic> json) {
    pharmacistId = json['pharmacist_id'];
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
