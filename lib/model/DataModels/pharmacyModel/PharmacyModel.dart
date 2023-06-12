class PharmacyModel {

  bool? status;
  String? message;
  PharmacyData? pharmacy;

  PharmacyModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    message = json['message'];
    pharmacy = (json['pharmacy'] != null) ? PharmacyData.fromJson(json['pharmacy']) : null;
  }


}


class PharmacyData {

  int? pharmacyId;
  String? name;
  String? localAddress;
  List<PharmacistPharmacyDataModel> pharmacists = [];

  PharmacyData.fromJson(Map<String , dynamic> json) {

    pharmacyId = json['pharmacy_id'];
    name = json['pharmacy_name'];
    localAddress = json['local_address'];
    json['pharmacists'].forEach((element) {
      pharmacists.add(PharmacistPharmacyDataModel.fromJson(element));
    });

  }

}

class PharmacistPharmacyDataModel {
  int? pharmacistId;
  UserPharmacyModel? user;

  PharmacistPharmacyDataModel.fromJson(Map<String , dynamic> json) {
    pharmacistId = json['pharmacist_id'];
    user = (json['user'] != null) ? UserPharmacyModel.fromJson(json['user']) : null;
  }


}


class UserPharmacyModel {

  String? name;
  String? role;
  String? phone;
  String? email;
  String? profileImage;
  int? codeAuth;
  int? userId;


  UserPharmacyModel.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    codeAuth = json['code_auth'];
    userId = json['user_id'];

  }



}
