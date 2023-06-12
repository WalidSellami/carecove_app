import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/cardModel/CardPatientModel.dart';
import 'package:project_final/model/DataModels/doctorsModel/DoctorsModel.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsModel.dart';
import 'package:project_final/model/DataModels/medicationsModel/MedicationsStockModel.dart';
import 'package:project_final/model/DataModels/orderModel/OrderModel.dart';
import 'package:project_final/model/DataModels/patientClaimsModel/patientClaimsModel.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/model/DataModels/pharmacyModel/PharmacyModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/AddPrescriptionModel.dart';
import 'package:project_final/model/DataModels/simpleModel/SimpleModel.dart';
import 'package:project_final/model/DataModels/userClaimsModel/UserClaimsModel.dart';
import 'package:project_final/model/profileModel/profileAdminModel/ProfileAdminModel.dart';
import 'package:project_final/model/profileModel/profileDoctorModel/ProfileDoctorModel.dart';
import 'package:project_final/model/profileModel/profilePatientModel/ProfilePatientModel.dart';
import 'package:project_final/model/profileModel/profilePharmacistModel/ProfilePharmacistModel.dart';
import 'package:project_final/model/profileModel/profileUserModel/ProfileModel.dart';

abstract class AppStates {}

class InitialAppState extends AppStates {}

class ChangeBottomNavAppState extends AppStates {}

// Get data profile
class LoadingGetProfileAppState extends AppStates {}

class SuccessGetProfileAppState extends AppStates {

  final ProfileModel profileModel;
  SuccessGetProfileAppState(this.profileModel);

}

class ErrorGetProfileAppState extends AppStates {

  dynamic error;
  ErrorGetProfileAppState(this.error);

}


// Resend code auth
class LoadingResendCodeAuthAppState extends AppStates {}

class ErrorResendCodeAuthAppState extends AppStates {

  dynamic error;
  ErrorResendCodeAuthAppState(this.error);

}

// Change password
class LoadingChangePasswordAppState extends AppStates {}

class SuccessChangePasswordAppState extends AppStates {
  final SimpleModel changePasswordModel;
  SuccessChangePasswordAppState(this.changePasswordModel);
}

class ErrorChangePasswordAppState extends AppStates {

  dynamic error;
  ErrorChangePasswordAppState(this.error);

}

// Image profile
class SuccessGetImageProfileAppState extends AppStates {}

class ErrorGetImageProfileAppState extends AppStates {}

class SuccessRemoveImageAppState extends AppStates {}


// Update profile
class LoadingUpdateProfileAppState extends AppStates {}

class SuccessUpdateProfileAppState extends AppStates {}

class ErrorUpdateProfileAppState extends AppStates {

  dynamic error;
  ErrorUpdateProfileAppState(this.error);

}


// Log Out
class LoadingLogOutAppState extends AppStates {}

class SuccessLogOutAppState extends AppStates {}

class ErrorLogOutAppState extends AppStates {

  dynamic error;
  ErrorLogOutAppState(this.error);
}


// Add Claim To Admin
class LoadingAddClaimToAdminAppState extends AppStates {}

class SuccessAddClaimToAdminAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddClaimToAdminAppState(this.simpleModel);
}

class ErrorAddClaimToAdminAppState extends AppStates {

  dynamic error;
  ErrorAddClaimToAdminAppState(this.error);
}


// Check Account User
class LoadingCheckAccountUserAppState extends AppStates {}

class SuccessCheckAccountUserAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessCheckAccountUserAppState(this.simpleModel);
}

class ErrorCheckAccountUserAppState extends AppStates {

  dynamic error;
  ErrorCheckAccountUserAppState(this.error);
}






// **************************************   Admin   ************************************** //

// Get profile Admin
class LoadingGetProfileAdminAppState extends AppStates {}

class SuccessGetProfileAdminAppState extends AppStates {

  final ProfileAdminModel adminProfile;
  SuccessGetProfileAdminAppState(this.adminProfile);

}

class ErrorGetProfileAdminAppState extends AppStates {

  dynamic error;
  ErrorGetProfileAdminAppState(this.error);

}



// Get All Users
class LoadingGetAllUsersAppState extends AppStates {}

class SuccessGetAllUsersAppState extends AppStates {}

class ErrorGetAllUsersAppState extends AppStates {

  dynamic error;
  ErrorGetAllUsersAppState(this.error);

}



// Add Account User
class LoadingAddAccountUserAppState extends AppStates {}

class SuccessAddAccountUserAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddAccountUserAppState(this.simpleModel);
}

class ErrorAddAccountUserAppState extends AppStates {

  dynamic error;
  ErrorAddAccountUserAppState(this.error);
}




// Delete Account User
class LoadingDeleteAccountUserAppState extends AppStates {}

class SuccessDeleteAccountUserAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessDeleteAccountUserAppState(this.simpleModel);
}

class ErrorDeleteAccountUserAppState extends AppStates {

  dynamic error;
  ErrorDeleteAccountUserAppState(this.error);
}



// Get User Claims
class LoadingGetAllUserClaimsAppState extends AppStates {}

class SuccessGetAllUserClaimsAppState extends AppStates {

  final UserClaimsModel userClaimsModel;
  SuccessGetAllUserClaimsAppState(this.userClaimsModel);
}

class ErrorGetAllUserClaimsAppState extends AppStates {

  dynamic error;
  ErrorGetAllUserClaimsAppState(this.error);
}


class ErrorChangeStatusUserClaimsAppState extends AppStates {

  dynamic error;
  ErrorChangeStatusUserClaimsAppState(this.error);
}


// Remove User Claims
class LoadingRemoveUserClaimAppState extends AppStates {}

class SuccessRemoveUserClaimAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessRemoveUserClaimAppState(this.simpleModel);
}

class ErrorRemoveUserClaimAppState extends AppStates {

  dynamic error;
  ErrorRemoveUserClaimAppState(this.error);
}


class LoadingSearchAppState extends AppStates {}

class SuccessSearchAppState extends AppStates {

  // final AllUsersModel allUsersModel;
  // SuccessSearchAppState(this.allUsersModel);
}

class ErrorSearchAppState extends AppStates {

  dynamic error;
  ErrorSearchAppState(this.error);
}


// **************************************   Doctor   ************************************** //

// Get profile doctor
class LoadingGetProfileDoctorAppState extends AppStates {}

class SuccessGetProfileDoctorAppState extends AppStates {

  final ProfileDoctorModel doctorProfile;
  SuccessGetProfileDoctorAppState(this.doctorProfile);

}

class ErrorGetProfileDoctorAppState extends AppStates {

  dynamic error;
  ErrorGetProfileDoctorAppState(this.error);

}

// Add patient account
class LoadingAddPatientAccountAppState extends AppStates {}

class SuccessAddPatientAccountAppState extends AppStates {

  final SimpleModel addPatientModel;
  SuccessAddPatientAccountAppState(this.addPatientModel);

}

class ErrorAddPatientAccountAppState extends AppStates {

  dynamic error;
  ErrorAddPatientAccountAppState(this.error);

}

// Get all patients
class LoadingGetAllPatientsAppState extends AppStates {}

class SuccessGetAllPatientsAppState extends AppStates {}

class ErrorGetAllPatientsAppState extends AppStates {

  dynamic error;
  ErrorGetAllPatientsAppState(this.error);

}


// Search patient
class LoadingSearchPatientAppState extends AppStates {}

class SuccessSearchPatientAppState extends AppStates {}

class ErrorSearchPatientAppState extends AppStates {

  dynamic error;
  ErrorSearchPatientAppState(this.error);

}


// Add Card Patient
class LoadingAddCardPatientAppState extends AppStates {}

class SuccessAddCardPatientAppState extends AppStates {

  final SimpleModel addPatientModel;
  SuccessAddCardPatientAppState(this.addPatientModel);

}

class ErrorAddCardPatientAppState extends AppStates {

  dynamic error;
  ErrorAddCardPatientAppState(this.error);

}


// Get Card Patient
class LoadingGetCardPatientAppState extends AppStates {}

class SuccessGetCardPatientAppState extends AppStates {

  final CardModel cardModel;
  SuccessGetCardPatientAppState(this.cardModel);

}

class ErrorGetCardPatientAppState extends AppStates {

  dynamic error;
  ErrorGetCardPatientAppState(this.error);

}


class ClearCardDataAppState extends AppStates {}


// Update Card Patient
class LoadingEditCardPatientAppState extends AppStates {}

class SuccessEditCardPatientAppState extends AppStates {

  final SimpleModel editModel;
  SuccessEditCardPatientAppState(this.editModel);

}

class ErrorEditCardPatientAppState extends AppStates {

  dynamic error;
  ErrorEditCardPatientAppState(this.error);

}



// Delete Card Patient
class LoadingDeleteCardPatientAppState extends AppStates {}

class SuccessDeleteCardPatientAppState extends AppStates {

  final SimpleModel deleteModel;
  SuccessDeleteCardPatientAppState(this.deleteModel);

}

class ErrorDeleteCardPatientAppState extends AppStates {

  dynamic error;
  ErrorDeleteCardPatientAppState(this.error);

}


// Get All Pharmacies
class LoadingGetAllPharmaciesAppState extends AppStates {}

class SuccessGetAllPharmaciesAppState extends AppStates {

  final PharmaciesModel pharmaciesModel;
  SuccessGetAllPharmaciesAppState(this.pharmaciesModel);

}

class ErrorGetAllPharmaciesAppState extends AppStates {

  dynamic error;
  ErrorGetAllPharmaciesAppState(this.error);

}

// Search patient
class LoadingSearchPharmacyAppState extends AppStates {}

class SuccessSearchPharmacyAppState extends AppStates {}

class ErrorSearchPharmacyAppState extends AppStates {

  dynamic error;
  ErrorSearchPharmacyAppState(this.error);

}



// add Prescription
class LoadingAddPrescriptionAppState extends AppStates {}

class SuccessAddPrescriptionAppState extends AppStates {

  final AddPrescriptionModel addPrescriptionModel;
  SuccessAddPrescriptionAppState(this.addPrescriptionModel);
}

class ErrorAddPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorAddPrescriptionAppState(this.error);

}


class LoadingAddPrescriptionMedicationAppState extends AppStates {}

class SuccessAddPrescriptionMedicationAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddPrescriptionMedicationAppState(this.simpleModel);
}

class ErrorAddPrescriptionMedicationAppState extends AppStates {

  dynamic error;
  ErrorAddPrescriptionMedicationAppState(this.error);

}



// Get Prescriptions
class LoadingGetPrescriptionsAppState extends AppStates {}

class SuccessGetPrescriptionsAppState extends AppStates {}

// class LoadingGetPrescriptionsMedicationsAppState extends AppStates {}
//
// class SuccessGetPrescriptionsMedicationsAppState extends AppStates {}



// Edit Prescription
class LoadingEditPrescriptionAppState extends AppStates {}

class SuccessEditPrescriptionAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessEditPrescriptionAppState(this.simpleModel);
}

class ErrorEditPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorEditPrescriptionAppState(this.error);

}


// Get Medications From Prescription
class LoadingGetMedicationsPrescriptionAppState extends AppStates {}

class SuccessGetMedicationsPrescriptionAppState extends AppStates {}

class ErrorGetMedicationsPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorGetMedicationsPrescriptionAppState(this.error);

}


// Edit Dosage Medication Prescription
class LoadingEditDosageMedicationPrescriptionAppState extends AppStates {}

class SuccessEditDosageMedicationPrescriptionAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessEditDosageMedicationPrescriptionAppState(this.simpleModel);
}

class ErrorEditDosageMedicationPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorEditDosageMedicationPrescriptionAppState(this.error);

}


// Remove Prescription
class LoadingRemovePrescriptionAppState extends AppStates {}

class SuccessRemovePrescriptionAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessRemovePrescriptionAppState(this.simpleModel);
}

class ErrorRemovePrescriptionAppState extends AppStates {

  dynamic error;
  ErrorRemovePrescriptionAppState(this.error);

}

// Remove Medication From Prescription
class LoadingRemoveMedicationFromPrescriptionAppState extends AppStates {}

class SuccessRemoveMedicationFromPrescriptionAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessRemoveMedicationFromPrescriptionAppState(this.simpleModel);
}

class ErrorRemoveMedicationFromPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorRemoveMedicationFromPrescriptionAppState(this.error);

}


// Check Exist Medication In Prescription
class LoadingCheckExistMedicationPrescriptionAppState extends AppStates {}

class SuccessCheckExistMedicationPrescriptionAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessCheckExistMedicationPrescriptionAppState(this.simpleModel);
}

class ErrorCheckExistMedicationPrescriptionAppState extends AppStates {

  dynamic error;
  ErrorCheckExistMedicationPrescriptionAppState(this.error);

}


// Get All Patient Claims
class LoadingGetAllPatientClaimsAppState extends AppStates {}

class SuccessGetAllPatientClaimsAppState extends AppStates {
  final PatientClaimsModel patientClaimsModel;
  SuccessGetAllPatientClaimsAppState(this.patientClaimsModel);
}


// Change Status Patient Claims
class LoadingChangeStatusPatientClaimsAppState extends AppStates {}

class SuccessChangeStatusPatientClaimsAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessChangeStatusPatientClaimsAppState(this.simpleModel);
}

class ErrorChangeStatusPatientClaimsAppState extends AppStates {
  dynamic error;
  ErrorChangeStatusPatientClaimsAppState(this.error);
}


// Get Pharmacies With Medications Prescription
class LoadingGetPharmaciesWithMedicationsPrescriptionAppState extends AppStates {}

class SuccessGetPharmaciesWithMedicationsPrescriptionAppState extends AppStates {
  final PharmaciesModel pharmaciesModel;
  SuccessGetPharmaciesWithMedicationsPrescriptionAppState(this.pharmaciesModel);
}

class ErrorGetPharmaciesWithMedicationsPrescriptionAppState extends AppStates {
  dynamic error;
  ErrorGetPharmaciesWithMedicationsPrescriptionAppState(this.error);
}


// Send Order To Pharmacy
class LoadingSendOrderToPharmacyAppState extends AppStates {}

class SuccessSendOrderToPharmacyAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessSendOrderToPharmacyAppState(this.simpleModel);
}

class ErrorSendOrderToPharmacyAppState extends AppStates {
  dynamic error;
  ErrorSendOrderToPharmacyAppState(this.error);
}


// Check Send Order
class LoadingCheckSendOrderAppState extends AppStates {}

class SuccessCheckSendOrderAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessCheckSendOrderAppState(this.simpleModel);
}

class ErrorCheckSendOrderAppState extends AppStates {
  dynamic error;
  ErrorCheckSendOrderAppState(this.error);
}


// Remove Patient Claim
class LoadingRemovePatientClaimAppState extends AppStates {}

class SuccessRemovePatientClaimAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessRemovePatientClaimAppState(this.simpleModel);
}

class ErrorRemovePatientClaimAppState extends AppStates {
  dynamic error;
  ErrorRemovePatientClaimAppState(this.error);
}







// **************************************   Pharmacist   ************************************** //

// Get profile pharmacist
class LoadingGetProfilePharmacistAppState extends AppStates {}

class SuccessGetProfilePharmacistAppState extends AppStates {

  final ProfilePharmacistModel pharmacistProfile;
  SuccessGetProfilePharmacistAppState(this.pharmacistProfile);

}

class ErrorGetProfilePharmacistAppState extends AppStates {

  dynamic error;
  ErrorGetProfilePharmacistAppState(this.error);

}

// Get pharmacy
class LoadingGetPharmacyAppState extends AppStates {}

class SuccessGetPharmacyAppState extends AppStates {

  final PharmacyModel pharmacyProfile;
  SuccessGetPharmacyAppState(this.pharmacyProfile);

}

class ErrorGetPharmacyAppState extends AppStates {

  dynamic error;
  ErrorGetPharmacyAppState(this.error);

}


// Get All Medications
class LoadingGetAllMedicationsAppState extends AppStates {}

class SuccessGetAllMedicationsAppState extends AppStates {

  final MedicationsModel medicationsModel;
  SuccessGetAllMedicationsAppState(this.medicationsModel);

}



// Search Medication
class LoadingSearchMedicationAppState extends AppStates {}

class SuccessSearchMedicationAppState extends AppStates {}

class ErrorSearchMedicationAppState extends AppStates {

  dynamic error;
  ErrorSearchMedicationAppState(this.error);

}


// Check Exist Medication In DB
class LoadingCheckExistMedicationInDbAppState extends AppStates {}

class SuccessCheckExistMedicationInDbAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessCheckExistMedicationInDbAppState(this.simpleModel);

}

class ErrorCheckExistMedicationInDbAppState extends AppStates {

  dynamic error;
  ErrorCheckExistMedicationInDbAppState(this.error);

}


// Add Medication In DB
class LoadingAddMedicationInDbAppState extends AppStates {}

class SuccessAddMedicationInDbAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddMedicationInDbAppState(this.simpleModel);

}

class ErrorAddMedicationInDbAppState extends AppStates {

  dynamic error;
  ErrorAddMedicationInDbAppState(this.error);

}


// Edit Medication In DB
class LoadingEditMedicationInDbAppState extends AppStates {}

class SuccessEditMedicationInDbAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessEditMedicationInDbAppState(this.simpleModel);

}

class ErrorEditMedicationInDbAppState extends AppStates {

  dynamic error;
  ErrorEditMedicationInDbAppState(this.error);

}


// Add Medication In Stock
class LoadingAddMedicationInStockAppState extends AppStates {}

class SuccessAddMedicationInStockAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddMedicationInStockAppState(this.simpleModel);

}

class ErrorAddMedicationInStockAppState extends AppStates {

  dynamic error;
  ErrorAddMedicationInStockAppState(this.error);

}

class SuccessGetMedicationImageAppState extends AppStates {}

class ErrorGetMedicationImageAppState extends AppStates {}


// Get All Medications In Stock
class LoadingGetAllMedicationsFromStockAppState extends AppStates {}

class SuccessGetAllMedicationsFromStockAppState extends AppStates {

  final MedicationsStockModel medicationsStockModel;
  SuccessGetAllMedicationsFromStockAppState(this.medicationsStockModel);

}

// Search Medications In Stock
class LoadingSearchMedicationInStockAppState extends AppStates {}

class SuccessSearchMedicationsInStockAppState extends AppStates {

  final MedicationsStockModel medicationsStockModel;
  SuccessSearchMedicationsInStockAppState(this.medicationsStockModel);

}

class ErrorSearchMedicationsInStockAppState extends AppStates {

  dynamic error;
  ErrorSearchMedicationsInStockAppState(this.error);

}


// Edit Medication In Stock
class LoadingEditMedicationInStockAppState extends AppStates {}

class SuccessEditMedicationInStockAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessEditMedicationInStockAppState(this.simpleModel);

}

class ErrorEditMedicationInStockAppState extends AppStates {

  dynamic error;
  ErrorEditMedicationInStockAppState(this.error);

}

// Delete Medication From Stock
class LoadingDeleteMedicationFromStockAppState extends AppStates {}

class SuccessDeleteMedicationFromStockAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessDeleteMedicationFromStockAppState(this.simpleModel);

}

class ErrorDeleteMedicationFromStockAppState extends AppStates {

  dynamic error;
  ErrorDeleteMedicationFromStockAppState(this.error);

}


//Check Exist Medication In Stock
class LoadingCheckExitMedicationInStockAppState extends AppStates {}

class SuccessCheckExistMedicationInStockAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessCheckExistMedicationInStockAppState(this.simpleModel);

}

class ErrorCheckExistMedicationInStockAppState extends AppStates {

  dynamic error;
  ErrorCheckExistMedicationInStockAppState(this.error);

}


// Get Orders
class LoadingGetOrdersAppState extends AppStates {}

class SuccessGetOrdersAppState extends AppStates {

  final OrderModel orderModel;
  SuccessGetOrdersAppState(this.orderModel);

}



// Search Order
class LoadingSearchOrderAppState extends AppStates {}

class SuccessSearchOrderAppState extends AppStates {

  final OrderModel orderModel;
  SuccessSearchOrderAppState(this.orderModel);

}

class ErrorSearchOrderAppState extends AppStates {

  dynamic error;
  ErrorSearchOrderAppState(this.error);

}



// Change Status Order
class LoadingChangeStatusOrderAppState extends AppStates {}

class SuccessAcceptOrderAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessAcceptOrderAppState(this.simpleModel);
}

class SuccessRefuseOrderAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessRefuseOrderAppState(this.simpleModel);
}

class ErrorChangeStatusOrderAppState extends AppStates {

  dynamic error;
  ErrorChangeStatusOrderAppState(this.error);
}


// Decrement Quantity Medication
class LoadingDecrementQuantityMedicationAppState extends AppStates {}

class SuccessDecrementQuantityMedicationAppState extends AppStates {}

class ErrorDecrementQuantityMedicationAppState extends AppStates {

  dynamic error;
  ErrorDecrementQuantityMedicationAppState(this.error);
}



// Remove Order Refused
class LoadingRemoveOrderRefusedAppState extends AppStates {}

class SuccessRemoveOrderRefusedAppState extends AppStates {
  final SimpleModel simpleModel;
  SuccessRemoveOrderRefusedAppState(this.simpleModel);
}

class ErrorRemoveOrderRefusedAppState extends AppStates {

  dynamic error;
  ErrorRemoveOrderRefusedAppState(this.error);
}



//-------------------------------------------------------------------

// Map
class SuccessChangePositionTapAppState extends AppStates {}

class SuccessGetPlaceDetailsAppState extends AppStates {}

class ErrorGetPlaceDetailsAppState extends AppStates {

  dynamic error;
  ErrorGetPlaceDetailsAppState(this.error);

}

class SuccessClearAppState extends AppStates {}

class SuccessSearchPlaceAppState extends AppStates {}

class LoadingSearchPlaceDepDesAppState extends AppStates {}

class SuccessSearchPlaceDepDesAppState extends AppStates {}

class ErrorSearchPlaceAppState extends AppStates {

  dynamic error;
  ErrorSearchPlaceAppState(this.error);

}

class ErrorSearchPlaceDepDesAppState extends AppStates {

  dynamic error;
  ErrorSearchPlaceDepDesAppState(this.error);

}

class SuccessGetDirectionPlaceAppState extends AppStates {}

class ErrorGetDirectionPlaceAppState extends AppStates {
  dynamic error;
  ErrorGetDirectionPlaceAppState(this.error);
}

class SuccessGetRouteAppState extends AppStates {}

class ErrorGetRouteAppState extends AppStates {
  dynamic error;
  ErrorGetRouteAppState(this.error);
}





// **************************************   Patient   ************************************** //


// Get profile patient
class LoadingGetProfilePatientAppState extends AppStates {}

class SuccessGetProfilePatientAppState extends AppStates {

  final ProfilePatientModel patientProfile;
  SuccessGetProfilePatientAppState(this.patientProfile);

}

class ErrorGetProfilePatientAppState extends AppStates {

  dynamic error;
  ErrorGetProfilePatientAppState(this.error);

}


// Get All Cards
class LoadingGetAllCardsAppState extends AppStates {}

class SuccessGetAllCardsAppState extends AppStates {

  final CardPatientModel cardPatientModel;
  SuccessGetAllCardsAppState(this.cardPatientModel);

}



// Get All Doctors
class LoadingGetAllDoctorsAppState extends AppStates {}

class SuccessGetAllDoctorsAppState extends AppStates {

  final DoctorsModel doctorsModel;
  SuccessGetAllDoctorsAppState(this.doctorsModel);

}


//Search Doctor
class LoadingSearchDoctorAppState extends AppStates {}

class SuccessSearchDoctorAppState extends AppStates {

  final DoctorsModel doctorsModel;
  SuccessSearchDoctorAppState(this.doctorsModel);

}

class ErrorSearchDoctorAppState extends AppStates {

  dynamic error;
  ErrorSearchDoctorAppState(this.error);

}


// Add Claim To Doctor
class LoadingAddClaimToDoctorAppState extends AppStates {}

class SuccessAddClaimToDoctorAppState extends AppStates {

  final SimpleModel simpleModel;
  SuccessAddClaimToDoctorAppState(this.simpleModel);
}

class ErrorAddClaimToDoctorAppState extends AppStates {

  dynamic error;
  ErrorAddClaimToDoctorAppState(this.error);
}


//Get Orders
class LoadingGetPatientOrdersAppState extends AppStates {}

class SuccessGetPatientOrdersAppState extends AppStates {

  final OrderModel orderModel;
  SuccessGetPatientOrdersAppState(this.orderModel);
}

class ErrorGetPatientOrdersAppState extends AppStates {

  dynamic error;
  ErrorGetPatientOrdersAppState(this.error);
}


// Search cards
class LoadingSearchCardPatientAppState extends AppStates {}

class SuccessSearchCardPatientAppState extends AppStates {

  final CardPatientModel cardPatientModel;
  SuccessSearchCardPatientAppState(this.cardPatientModel);
}

class ErrorSearchCardPatientAppState extends AppStates {

  dynamic error;
  ErrorSearchCardPatientAppState(this.error);
}


// Search orders
class LoadingSearchOrderPatientAppState extends AppStates {}

class SuccessSearchOrderPatientAppState extends AppStates {

  final OrderModel orderModel;
  SuccessSearchOrderPatientAppState(this.orderModel);
}

class ErrorSearchOrderPatientAppState extends AppStates {

  dynamic error;
  ErrorSearchOrderPatientAppState(this.error);
}


// ************************************************ //

// Notifications

class SuccessSendNotificationAppState extends AppStates {}