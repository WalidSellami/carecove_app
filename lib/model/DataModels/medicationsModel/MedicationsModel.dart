class MedicationsModel {

  bool? status;
  List<MedicationData> medications = [];

  MedicationsModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    json['medications'].forEach((element) {

      medications.add(MedicationData.fromJson(element));

    });
  }



}



class MedicationData {

  int? medicationId;
  String? name;
  String? description;

  MedicationData.fromJson(Map<String , dynamic> json) {

    medicationId = json['medication_id'];
    name = json['name'];
    description = json['description'];


  }




}