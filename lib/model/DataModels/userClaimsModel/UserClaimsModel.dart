class UserClaimsModel {

  bool? status;
  int? numberClaim;
  List<UserClaimData> userClaims = [];

  UserClaimsModel.fromJson(Map<String , dynamic> json) {

    status = json['status'];
    numberClaim = json['numberClaim'];
    json['userClaims'].forEach((element) {

      userClaims.add(UserClaimData.fromJson(element));
    });


  }


}


class UserClaimData {

  int? userClaimId;
  String? message;
  String? claimDate;
  bool? statusClaim;
  UserData? user;



  UserClaimData.fromJson(Map<String , dynamic> json) {

    userClaimId = json['user_claim_id'];
    message = json['message'];
    claimDate = json['claim_date'];
    statusClaim = json['is_read'];
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
