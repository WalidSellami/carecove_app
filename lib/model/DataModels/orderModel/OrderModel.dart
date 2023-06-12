class OrderModel {

  bool? status;
  int? numberOrders;
  List<OrderData> orders = [];

  OrderModel.fromJson(Map<String , dynamic> json) {
    status = json['status'];
    numberOrders = json['numberOrders'];
    json['orders'].forEach((element) {
      orders.add(OrderData.fromJson(element));
    });

  }

}


class OrderData {

  int? orderId;
  String? orderDate;
  String? status;
  int? pharmacyId;
  int? prescriptionId;
  String? isRead;
  PharmacyOrderData? pharmacy;
  PrescriptionOrderData? prescription;

  OrderData.fromJson(Map<String , dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    status = json['status'];
    pharmacyId = json['pharmacy_id'];
    prescriptionId = json['prescription_id'];
    isRead = json['is_read'];
    pharmacy = (json['pharmacy'] != null) ? PharmacyOrderData.fromJson(json['pharmacy']) : null;
    prescription = (json['prescription'] != null) ? PrescriptionOrderData.fromJson(json['prescription']) : null;

  }

}

class PharmacyOrderData{
  int? pharmacyId;
  String? pharmacyName;
  String? localAddress;
  // int? pharmacistId;
  // PharmacistModel? pharmacist;

  PharmacyOrderData.fromJson(Map<String , dynamic> json) {
    pharmacyId = json['pharmacy_id'];
    pharmacyName = json['pharmacy_name'];
    localAddress = json['local_address'];
    // pharmacist = (json['pharmacist'] != null) ? PharmacistModel.fromJson(json['pharmacist']) : null;
  }


}

class PrescriptionOrderData {

  int? prescriptionId;
  String? prescriptionDate;
  int? cardId;
  List<PrescriptionMedicationsOrderData> prescriptionMedications = [];
  CardOrderData? card;

  PrescriptionOrderData.fromJson(Map<String , dynamic> json) {

    prescriptionId = json['prescription_id'];
    prescriptionDate = json['prescription_date'];
    cardId = json['card_id'];
    prescriptionId = json['prescription_id'];
    json['prescription_medications'].forEach((element) {
      prescriptionMedications.add(PrescriptionMedicationsOrderData.fromJson(element));
    });
    card = (json['card'] != null) ? CardOrderData.fromJson(json['card']) : null;

  }

}

class PrescriptionMedicationsOrderData {
  int? prescriptionMedicationId;
  String? dosage;
  int? quantity;
  int? prescriptionId;
  int? medicationId;
  MedicationsPrescriptionOrderData? medication;

  PrescriptionMedicationsOrderData.fromJson(Map<String , dynamic> json) {
    prescriptionMedicationId = json['prescription_medication_id'];
    dosage = json['dosage'];
    quantity = json['quantity'];
    prescriptionId = json['prescription_id'];
    medicationId = json['medication_id'];
    medication = MedicationsPrescriptionOrderData.fromJson(json['medication']);
  }



}


class MedicationsPrescriptionOrderData {

  int? medicationId;
  String? name;
  String? description;

  MedicationsPrescriptionOrderData.fromJson(Map<String, dynamic> json) {
    medicationId = json['medication_id'];
    name = json['name'];
    description = json['description'];
  }

}

class CardOrderData {

  int? cardId;
  int? age;
  dynamic weight;
  String? sickness;
  int? patientId;
  int? doctorId;
  PatientOrderData? patient;
  DoctorOrderData? doctor;

  CardOrderData.fromJson(Map<String , dynamic> json) {

    cardId = json['card_id'];
    age = json['age'];
    weight = json['weight'];
    sickness = json['sickness'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    patient = (json['patient'] != null) ? PatientOrderData.fromJson(json['patient']) : null;
    doctor = (json['doctor'] != null) ? DoctorOrderData.fromJson(json['doctor']) : null;
  }


}


class PatientOrderData {
  int? patientId;
  String? address;
  UserOrderData? user;

  PatientOrderData.fromJson(Map<String , dynamic> json) {
    patientId = json['patient_id'];
    address = json['address'];
    user = (json['user'] != null) ? UserOrderData.fromJson(json['user']) : null;
  }


}

class DoctorOrderData {
  int? doctorId;
  String? localAddress;
  String? speciality;
  UserOrderData? user;

  DoctorOrderData.fromJson(Map<String , dynamic> json) {
    doctorId = json['doctor_id'];
    localAddress = json['local_address'];
    speciality = json['specialty'];
    user = (json['user'] != null) ? UserOrderData.fromJson(json['user']) : null;
  }

}


class UserOrderData {

  String? name;
  String? role;
  String? phone;
  String? email;
  String? profileImage;
  int? codeAuth;
  int? userId;


  UserOrderData.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    codeAuth = json['code_auth'];
    userId = json['user_id'];

  }



}