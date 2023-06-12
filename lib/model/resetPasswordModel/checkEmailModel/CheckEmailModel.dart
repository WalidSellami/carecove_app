class CheckEmailModel {

  bool? status;
  String? message;
  String? email;
  int? codeAuth;

  CheckEmailModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    message = json['message'];
    email = json['email'];
    codeAuth = json['code_auth'];

  }


}