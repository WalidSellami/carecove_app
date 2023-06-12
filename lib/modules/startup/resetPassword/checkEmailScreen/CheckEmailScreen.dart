import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorScreen.dart';
import 'package:project_final/modules/startup/resetPassword/newPasswordScreen/NewPasswordScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/resetPassCubit/Cubit.dart';
import 'package:project_final/shared/cubit/resetPassCubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class CheckEmailScreen extends StatelessWidget {

  CheckEmailScreen({super.key});

  final checkEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ResetPassCubit , ResetPassStates>(
          listener: (context , state) {

            if(state is SuccessCheckEmailState){
              if(state.checkModel.status == true){

                showFlutterToast(message: '${state.checkModel.message}', state: ToastStates.success ,  context: context);
                emailChecker = state.checkModel.email;
                navigatorTo(context: context, screen: const NewPasswordScreen());

              } else {

                showFlutterToast(message: '${state.checkModel.message}', state: ToastStates.error ,  context: context);

              }
            }
          },
          builder: (context , state) {

            var cubit = ResetPassCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                  tooltip: 'Back',
                ),
                title: const Text(
                  'Search Email',
                  style: TextStyle(
                    fontFamily: 'Varela',
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter your email :',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          defaultFormField(
                              text: 'Email',
                              controller: checkEmailController,
                              focusNode: focusNode,
                              type: TextInputType.emailAddress,
                              prefix: Icons.email_outlined,
                              submit: (value) {
                                if(formKey.currentState!.validate()){
                                  cubit.searchEmail(email: checkEmailController.text);
                                }
                                return null;
                              },
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email must not be empty';
                                }
                                bool emailValid = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 70.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoadingCheckEmailState,
                        builder: (context) => defaultButton(
                            function: () {
                              if(checkCubit.hasInternet) {
                                if(formKey.currentState!.validate()){
                                  cubit.searchEmail(email: checkEmailController.text);
                                  focusNode.unfocus();
                                }
                                focusNode.unfocus();
                              } else {
                                focusNode.unfocus();
                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                              }
                            },
                            text: 'Search'.toUpperCase(),
                            context: context),
                        fallback: (context) => Center(child: IndicatorScreen(os: getOs())),


                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
