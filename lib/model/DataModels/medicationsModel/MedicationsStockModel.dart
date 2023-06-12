class MedicationsStockModel {

  bool? status;
  List<MedicationStockData> medicationsStock = [];

  MedicationsStockModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    json['medicationsStock'].forEach((element) {

      medicationsStock.add(MedicationStockData.fromJson(element));

    });
  }



}


class MedicationStockData {

  int? stockId;
  dynamic quantity;
  String? medicationImage;
  dynamic dateManufacture;
  dynamic dateExpiration;
  int? medicationId;
  int? pharmacyId;
  MedicationDbData? medication;

  MedicationStockData.fromJson(Map<String , dynamic> json) {

    stockId = json['stock_id'];
    quantity = json['quantity'];
    medicationImage = json['medication_image'];
    dateManufacture = json['date_of_manufacture'];
    dateExpiration = json['date_of_expiration'];
    medicationId = json['medication_id'];
    pharmacyId = json['pharmacy_id'];
    medication = (json['medication'] != null) ? MedicationDbData.fromJson(json['medication']) : null;

  }




}


class MedicationDbData {

  int? medicationId;
  String? name;
  String? description;

  MedicationDbData.fromJson(Map<String , dynamic> json) {

    medicationId = json['medication_id'];
    name = json['name'];
    description = json['description'];


  }




}