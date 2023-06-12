import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class SelectPlaceScreen extends StatefulWidget {
  const SelectPlaceScreen({super.key});

  @override
  State<SelectPlaceScreen> createState() => _SelectPlaceScreenState();
}

class _SelectPlaceScreenState extends State<SelectPlaceScreen> {
  var departureController = TextEditingController();
  var destinationController = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessGetRouteAppState) {
          if (AppCubit.get(context).isGetDirection == true) {
            showFlutterToast(
                message: 'Done with success',
                state: ToastStates.success,
                context: context);
            Navigator.pop(context);
          }
        } else if (state is ErrorGetDirectionPlaceAppState) {
          showToast(
            'You should enter districts of cities not cities or countries to get direction (Only places inside cities)',
            context: context,
            backgroundColor: Colors.red,
            animation: StyledToastAnimation.scale,
            reverseAnimation: StyledToastAnimation.fade,
            position: StyledToastPosition.bottom,
            animDuration: const Duration(milliseconds: 1500),
            duration: const Duration(seconds: 4),
            curve: Curves.elasticInOut,
            reverseCurve: Curves.linear,
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: defaultAppBar(context: context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                        text: 'Departure',
                        controller: departureController,
                        type: TextInputType.streetAddress,
                        prefix: Icons.location_on_outlined,
                        helperText: 'Enter District Name',
                        focusNode: focusNode1,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Departure must not be empty';
                          }
                          if (state is ErrorGetRouteAppState) {
                            return 'Enter districts (Only places inside the city)';
                          }
                          bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s]+$').hasMatch(value);
                          if(!nameValid) {
                            return 'Enter a valid address without numbers and without (,.-_)';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Column(
                          children: [
                            Container(
                              width: 1,
                              height: 5,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade700,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                            ),
                            (index == 4)
                                ? Icon(
                                    Icons.keyboard_arrow_down,
                                    color: ThemeCubit.get(context).isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade700,
                                  )
                                : Container(),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    defaultFormField(
                        text: 'Destination',
                        controller: destinationController,
                        type: TextInputType.streetAddress,
                        prefix: Icons.location_on_outlined,
                        helperText: 'Enter District Name',
                        focusNode: focusNode2,
                        submit: (value) {
                          if (CheckCubit.get(context).hasInternet) {
                            if (formKey.currentState!.validate()) {
                              cubit.searchPlaceDepDes(
                                departureController.text,
                                destinationController.text,
                                context,
                              );
                            }
                            return null;
                          } else {
                            showFlutterToast(
                                message: 'No Internet Connection',
                                state: ToastStates.error,
                                context: context);
                          }
                          return null;
                        },
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Departure must not be empty';
                          }
                          if (value == departureController.text) {
                            return 'Don\'t enter the same place';
                          }
                          if (state is ErrorGetRouteAppState) {
                            return 'Enter districts (Only places inside the city)';
                          }
                          bool nameValid = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s]+$').hasMatch(value);
                          if(!nameValid) {
                            return 'Enter a valid address without numbers and without (,.-_)';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 35.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingSearchPlaceDepDesAppState,
                      builder: (context) => Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (CheckCubit.get(context).hasInternet) {
                              if (formKey.currentState!.validate()) {
                                cubit.searchPlaceDepDes(
                                  departureController.text,
                                  destinationController.text,
                                  context,
                                );
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                              }
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                            } else {
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                              showFlutterToast(
                                  message: 'No Internet Connection',
                                  state: ToastStates.error,
                                  context: context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              ThemeCubit.get(context).isDark
                                  ? HexColor('158b96')
                                  : HexColor('c1dfff'),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                            ),
                            minimumSize: const MaterialStatePropertyAll(
                              Size(200, 50),
                            ),
                          ),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      fallback: (context) =>
                          Center(child: IndicatorScreen(os: getOs())),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
