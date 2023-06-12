class PharmacistCompleteModel {

  bool? status;
  String? message;
  PharmacyData? pharmacy;
  PharmacistData? pharmacist;

  PharmacistCompleteModel.fromJson(Map<String , dynamic> json){

    status = json['status'];
    message = json['message'];
    pharmacy = (json['pharmacy'] != null) ? PharmacyData.fromJson(json['pharmacy']) : null;
    pharmacist = (json['pharmacist'] != null) ? PharmacistData.fromJson(json['pharmacist']) : null;
  }


}


class PharmacyData {

  int? pharmacyId;
  String? name;
  String? localAddress;

  PharmacyData.fromJson(Map<String , dynamic> json) {

    pharmacyId = json['pharmacy_id'];
    name = json['pharmacy_name'];
    localAddress = json['local_address'];

  }

}


class PharmacistData {

  int? pharmacistId;

  PharmacistData.fromJson(Map<String , dynamic> json) {

    pharmacistId = json['pharmacist_id'];

  }

}

