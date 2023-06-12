import 'package:project_final/model/DataModels/pharmacyModel/PharmacyModel.dart';
import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/DoctorCompleteModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/PharmacistCompleteModel.dart';
import 'package:project_final/model/authModels/completeRegisterModel/PharmacistCompleteSimpleModel.dart';
import 'package:project_final/model/authModels/registerModel/RegisterModel.dart';

abstract class RegisterStates {}

class InitialRegisterState extends RegisterStates {}

class LoadingRegisterState extends RegisterStates {}

class SuccessRegisterState extends RegisterStates {

  final RegisterModel registerModel;
  SuccessRegisterState(this.registerModel);

}

class ErrorRegisterState extends RegisterStates {

  dynamic error;
  ErrorRegisterState(this.error);

}


// Get Image Certificate
class SuccessGetImageRegisterState extends RegisterStates {}

class RemoveImageRegisterState extends RegisterStates {}

class ErrorGetImageRegisterState extends RegisterStates {}


// Doctor Complete Register
class LoadingDoctorCompleteRegisterState extends RegisterStates {}

class SuccessDoctorCompleteRegisterState extends RegisterStates {

  final DoctorCompleteModel doctorCompleteModel;
  SuccessDoctorCompleteRegisterState(this.doctorCompleteModel);

}

class ErrorDoctorCompleteRegisterState extends RegisterStates {

  dynamic error;
  ErrorDoctorCompleteRegisterState(this.error);

}


// Pharmacist Complete Register
class LoadingPharmacistCompleteRegisterState extends RegisterStates {}

class SuccessPharmacistCompleteRegisterState extends RegisterStates {

  final PharmacistCompleteModel pharmacistCompleteModel;
  SuccessPharmacistCompleteRegisterState(this.pharmacistCompleteModel);

}

class ErrorPharmacistCompleteRegisterState extends RegisterStates {

  dynamic error;
  ErrorPharmacistCompleteRegisterState(this.error);

}


class LoadingPharmacistCompleteSimpleRegisterState extends RegisterStates {}

class SuccessPharmacistCompleteSimpleRegisterState extends RegisterStates {

  final PharmacistCompleteSimpleModel pharmacistCompleteSimpleModel;
  SuccessPharmacistCompleteSimpleRegisterState(this.pharmacistCompleteSimpleModel);

}

class ErrorPharmacistCompleteSimpleRegisterState extends RegisterStates {

  dynamic error;
  ErrorPharmacistCompleteSimpleRegisterState(this.error);

}


class LoadingCheckExistPharmacy extends RegisterStates {}

class SuccessCheckExistPharmacy extends RegisterStates {
  final PharmacyModel pharmacyModel;
  SuccessCheckExistPharmacy(this.pharmacyModel);
}

class ErrorCheckExistPharmacy extends RegisterStates {

  dynamic error;
  ErrorCheckExistPharmacy(this.error);

}


class LoadingCheckPharmacyName extends RegisterStates {}

class SuccessCheckPharmacyName extends RegisterStates {
  final SimpleModel simpleModel;
  SuccessCheckPharmacyName(this.simpleModel);
}

class ErrorCheckPharmacyName extends RegisterStates {

  dynamic error;
  ErrorCheckPharmacyName(this.error);

}


// Delete account

class LoadingDeleteAccountState extends RegisterStates {}

class SuccessDeleteAccountState extends RegisterStates {

  final SimpleModel simpleModel;
  SuccessDeleteAccountState(this.simpleModel);
}

class ErrorDeleteAccountState extends RegisterStates {

  dynamic error;
  ErrorDeleteAccountState(this.error);
}



