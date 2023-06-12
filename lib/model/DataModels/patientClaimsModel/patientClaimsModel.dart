class PatientClaimsModel {

  bool? status;
  int? numberClaim;
  List<PatientClaimData> patientClaims = [];

  PatientClaimsModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    numberClaim = json['numberClaim'];
    json['patientClaims'].forEach((element) {
      
      patientClaims.add(PatientClaimData.fromJson(element));
    });


  }


}


class PatientClaimData {

  int? patientClaimId;
  String? message;
  String? claimDate;
  String? statusClaim;
  int? patientId;
  int? doctorId;
  PatientData? patient;


  PatientClaimData.fromJson(Map<String , dynamic> json) {

    patientClaimId = json['patient_claim_id'];
    message = json['message'];
    claimDate = json['claim_date'];
    statusClaim = json['is_read'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    patient = (json['patient'] != null) ? PatientData.fromJson(json['patient']) : null;



  }

}

class PatientData {
  int? patientId;
  String? address;
  UserData? user;

  PatientData.fromJson(Map<String , dynamic> json) {
    patientId = json['patient_id'];
    address = json['address'];
    user = (json['user'] != null) ? UserData.fromJson(json['user']) : null;
  }


}


class UserData {

  String? name;
  String? role;
  String? phone;
  String? email;
  String? profileImage;
  int? codeAuth;
  int? userId;


  UserData.fromJson(Map<String , dynamic> json) {

    name = json['name'];
    role = json['role'];
    phone = json['phone'];
    email = json['email'];
    profileImage = json['profile_image'];
    codeAuth = json['code_auth'];
    userId = json['user_id'];

  }



}
