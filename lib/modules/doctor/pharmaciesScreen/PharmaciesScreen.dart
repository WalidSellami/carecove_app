import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/model/DataModels/cardModel/CardModel.dart';
import 'package:project_final/model/DataModels/pharmaciesModel/PharmaciesModel.dart';
import 'package:project_final/model/DataModels/prescriptionModel/PrescriptionsModel.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class PharmaciesScreen extends StatelessWidget {
  final PrescriptionData prescription;
  final CardData? card;
  const PharmaciesScreen(
      {super.key, required this.prescription, required this.card});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SuccessSendOrderToPharmacyAppState) {
              if (state.simpleModel.status == true) {
                showFlutterToast(
                    message: '${state.simpleModel.message}',
                    state: ToastStates.success,
                    context: context);
                AppCubit.get(context).getAllPatientPrescriptions(idCard: card?.cardId);
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              } else {
                showFlutterToast(
                    message: '${state.simpleModel.message}',
                    state: ToastStates.error,
                    context: context);
              }
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var pharmacies = cubit.pharmaciesModel;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    cubit.clearPharmacies();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Send Order Prescription',
                ),
              ),
              body: ConditionalBuilder(
                condition: ((pharmacies?.pharmacies.length ?? 0) > 0),
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        '* Here is the pharmacies who have this medications.',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        '* Select the one who you want to send this order prescription.',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => buildItemPharmacy(
                              pharmacies!.pharmacies[index], context),
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: pharmacies?.pharmacies.length ?? 0),
                    ),
                  ],
                ),
                fallback: (context) =>
                (state is LoadingGetPharmaciesWithMedicationsPrescriptionAppState ||
                    pharmacies == null)
                    ? Center(child: IndicatorScreen(os: getOs()))
                    : Center(
                  child: (prescription.prescriptionMedications.length > 1) ? const Text(
                    'There is no pharmacies have this medications',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : const Text(
                    'There is no pharmacies have this medication',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildItemPharmacy(PharmacyDataModel model, context) => InkWell(
        onTap: () {
          if(CheckCubit.get(context).hasInternet) {
            showLoading(context);
            AppCubit.get(context).sendOrderToPharmacy(
              orderDate:
              DateFormat('yyyy-MM-dd \'at\' HH:mm').format(DateTime.now()),
              idPrescription: prescription.prescriptionId,
              idPharmacy: model.pharmacyId,
              body: card?.doctor?.user?.name ?? 'A doctor',
              idUserPharmacist:
              model.pharmacists.map((e) => e.user?.userId).toList(),
            );
          }else {
            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ThemeCubit.get(context).isDark
                      ? HexColor('1599a6')
                      : HexColor('b3d8ff'),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Icon(
                  Icons.medication_rounded,
                  color: ThemeCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.pharmacyName}',
                      maxLines: 1,
                      // textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '${model.localAddress}',
                      maxLines: 1,
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: ThemeCubit.get(context).isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  dynamic showLoading(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                padding: const EdgeInsets.all(26.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: ThemeCubit.get(context).isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
                child: IndicatorScreen(os: getOs())),
          );
        });
  }
}
