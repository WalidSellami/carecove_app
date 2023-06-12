class DoctorCompleteModel {

  bool? status;
  String? message;
  Data? data;

  DoctorCompleteModel.fromJson(Map<String , dynamic> json){

    status = json['status'];
    message = json['message'];
    data = (json['data'] != null) ? Data.fromJson(json['data']) : null;

  }


}

class Data {

  String? localAddress;
  int? doctorId;

  Data.fromJson(Map<String , dynamic> json) {

    localAddress = json['local_address'];
    doctorId = json['doctor_id'];

  }

}