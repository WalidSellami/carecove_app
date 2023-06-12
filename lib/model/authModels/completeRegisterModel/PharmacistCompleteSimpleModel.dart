class PharmacistCompleteSimpleModel {

  bool? status;
  String? message;
  PharmacistData? pharmacist;

  PharmacistCompleteSimpleModel.fromJson(Map<String , dynamic> json) {
    
    status = json['status'];
    message = json['message'];
    pharmacist = (json['pharmacist'] != null) ?  PharmacistData.fromJson(json['pharmacist']): null;
    
    
  }



}


class PharmacistData {

  int? pharmacistId;
  int? pharmacyId;

  PharmacistData.fromJson(Map<String , dynamic> json) {

    pharmacistId = json['pharmacist_id'];
    pharmacyId = json['pharmacy_id'];

  }

}
