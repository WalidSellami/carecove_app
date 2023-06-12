class AddPrescriptionModel {

  bool? status;
  String? message;
  Prescription? prescription;

  AddPrescriptionModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    message = json['message'];
    prescription = Prescription.fromJson(json['prescription']);

  }

}

class Prescription {

  int? prescriptionId;
  String? date;
  int? cardId;

  Prescription.fromJson(Map<String , dynamic> json) {

    prescriptionId = json['prescription_id'];
    date = json['prescription_date'];
    cardId = json['card_id'];

  }


}