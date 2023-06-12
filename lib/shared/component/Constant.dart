import 'dart:io';

import 'package:flutter/material.dart';


String getOs() {
  return Platform.operatingSystem;
}

dynamic token;

dynamic userId;

dynamic doctorId;

dynamic pharmacistId;

dynamic pharmacyId;

dynamic patientId;

String? emailChecker;

int? prescriptionId;

var prescriptionDateController = TextEditingController();


// int? cardId;