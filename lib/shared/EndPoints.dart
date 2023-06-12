
// All Users
const REGISTER = '/api/user/register';

const LOGIN = '/api/user/login';

const PROFILE = '/api/user/profile';

const CHECK_EMAIL = '/api/user/check-email';

const LOG_OUT = '/api/user/logout';

const CHECK_ACCOUNT = '/api/user/check-account';



// Only Doctor and Pharmacist
const ADD_CLAIM_TO_ADMIN = '/api/user/add-claim';


// Admin
const ALL_USERS = '/api/admin/all-users';
const ALL_ADMINS_DATA = '/api/admin/all-admins';
const ALL_DOCTORS_DATA = '/api/admin/all-doctors';
const ALL_PATIENTS_DATA = '/api/admin/all-patients';
const ALL_PHARMACISTS_DATA = '/api/admin/all-pharmacists';
const ADD_ACCOUNT_USER = '/api/admin/add-account';
const SEARCH_USER = '/api/admin/search-user';
const SEARCH_USER_ADMIN = '/api/admin/search-admin';
const SEARCH_USER_DOCTOR = '/api/admin/search-doctor';
const SEARCH_USER_PATIENT = '/api/admin/search-patient';
const SEARCH_USER_PHARMACIST = '/api/admin/search-pharmacist';
const GET_USER_CLAIMS = '/api/admin/get-user-claims';
const CHANGE_STATUS_USER_CLAIM = '/api/admin/change-status-user-claim';
const DELETE_USER_CLAIM = '/api/admin//delete-user-claim';



// Doctor
const DOCTOR_REGISTER = '/api/doctor/complete-register';

const ADD_PATIENT = '/api/doctor/add-patient';

const ALL_PATIENTS = '/api/doctor/all-patients';

const SEARCH_PATIENT = '/api/doctor/search-patient';

const ADD_CARD_PATIENT = '/api/doctor/add-card';

const UPDATE_CARD_PATIENT = '/api/doctor/update-card';

const DELETE_CARD_PATIENT = '/api/doctor/delete-card';

const ALL_PHARMACIES = '/api/doctor/all-pharmacies';

const SEARCH_PHARMACY = '/api/doctor/search-pharmacy';

const GET_ALL_MEDICATION_FROM_STOCK_PHARMACY = '/api/doctor/stock/all-medications';

const SEARCH_MEDICATION_IN_STOCK_PHARMACY = '/api/doctor/stock/search-medication';

const ADD_PRESCRIPTION = '/api/doctor/add-prescription';

const ADD_PRESCRIPTION_MEDICATION = '/api/doctor/add-prescription-medication';

const CHECK_EXIST_MEDICATION_PRESCRIPTION = '/api/doctor/check-exist-medication-prescription';

const CHANGE_STATUS_CLAIM = '/api/doctor/change-status-claim';

const SEND_ORDER_TO_PHARMACY = '/api/doctor/send-order-to-pharmacy';

const CHECK_SEND_ORDER_TO_PHARMACY = '/api/doctor/check-send-order-to-pharmacy';

const REMOVE_PATIENT_CLAIM = '/api/doctor/remove-claim';










// Pharmacist
const PHARMACIST_REGISTER = '/api/pharmacist/complete-register';

const PHARMACIST_REGISTER_SIMPLE = '/api/pharmacist/complete-register-simple';

const CHECK_EXIST_PHARMACY = '/api/pharmacist/check-exist-pharmacy';

const CHECK_PHARMACY_NAME = '/api/pharmacist/check-pharmacy-name';

const GET_ALL_MEDICATIONS = '/api/pharmacist/all-medications';

const SEARCH_MEDICATION = '/api/pharmacist/search-medication';

const CHECK_EXIST_MEDICATION = '/api/pharmacist/check-exist-medication';

const ADD_MEDICATION_IN_DB = '/api/pharmacist/add-medication';

const EDIT_MEDICATION_IN_DB = '/api/pharmacist/edit-medication';

const ADD_MEDICATION_IN_STOCK = '/api/pharmacist/stock/add-medication';

const EDIT_MEDICATION_IN_STOCK = '/api/pharmacist/stock/edit-medication';

const EDIT_MEDICATION_IN_STOCK_WITH_IMAGE = '/api/pharmacist/stock/edit-medication-with-image';

const SEARCH_MEDICATION_STOCK = '/api/pharmacist/stock/search-medication';

const DELETE_MEDICATION_IN_STOCK = '/api/pharmacist/stock/remove-medication';

const CHECK_EXIST_MEDICATION_IN_STOCK = '/api/pharmacist/stock/check-exist-medication';

const ACCEPT_ORDER = '/api/pharmacist/accept-order';

const REFUSE_ORDER = '/api/pharmacist/refuse-order';




//Patient
const ALL_DOCTORS = '/api/patient/all-doctors';

const ADD_CLAIM_TO_DOCTOR = '/api/patient/add-claim-to-doctor';

const SEARCH_DOCTOR = '/api/patient/search-doctor';



const DELETE_ACCOUNT = '/api/user/delete-account';