class PrescriptionsModel {

  bool? status;
  List<PrescriptionData> prescription = [];

  PrescriptionsModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    json['prescription'].forEach((element) {

      prescription.add(PrescriptionData.fromJson(element));

    });

  }

}


class PrescriptionData {

  int? prescriptionId;
  String? prescriptionDate;
  int? cardId;
  List<PrescriptionMedicationsData> prescriptionMedications = [];
  List<OrderPrescriptionData> orders = [];

  PrescriptionData.fromJson(Map<String , dynamic> json) {

    prescriptionId = json['prescription_id'];
    prescriptionDate = json['prescription_date'];
    cardId = json['card_id'];
    prescriptionId = json['prescription_id'];
    json['prescription_medications'].forEach((element) {
      prescriptionMedications.add(PrescriptionMedicationsData.fromJson(element));
    });
    json['orders'].forEach((element) {
      orders.add(OrderPrescriptionData.fromJson(element));
    });

  }

}

class OrderPrescriptionData {

  int? orderId;
  String? orderDate;
  String? status;
  int? pharmacyId;
  int? prescriptionId;


  OrderPrescriptionData.fromJson(Map<String , dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    status = json['status'];
    pharmacyId = json['pharmacy_id'];
    prescriptionId = json['prescription_id'];

  }

}



class PrescriptionMedicationsData {
  int? prescriptionMedicationId;
  String? dosage;
  int? quantity;
  int? prescriptionId;
  int? medicationId;
  MedicationsPrescriptionData? medication;

  PrescriptionMedicationsData.fromJson(Map<String , dynamic> json) {
    prescriptionMedicationId = json['prescription_medication_id'];
    dosage = json['dosage'];
    quantity = json['quantity'];
    prescriptionId = json['prescription_id'];
    medicationId = json['medication_id'];
    medication = MedicationsPrescriptionData.fromJson(json['medication']);
  }



}


class MedicationsPrescriptionData {

  int? medicationId;
  String? name;
  String? description;

  MedicationsPrescriptionData.fromJson(Map<String, dynamic> json) {
    medicationId = json['medication_id'];
    name = json['name'];
    description = json['description'];
  }

}