import 'package:avatar_glow/avatar_glow.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:project_final/adaptive/circularIndicator/IndicatorRingScreen.dart';
import 'package:project_final/shared/component/Component.dart';
import 'package:project_final/shared/component/Constant.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AddClaimToAdminScreen extends StatefulWidget {
  const AddClaimToAdminScreen({super.key});

  @override
  State<AddClaimToAdminScreen> createState() => _AddClaimToAdminScreenState();
}

class _AddClaimToAdminScreenState extends State<AddClaimToAdminScreen> {

  bool isVisible = false;
  bool isListening = false;
  SpeechToText speechToText = SpeechToText();

  var msgController = TextEditingController();

  final FocusNode focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    bool isFab = MediaQuery.of(context).viewInsets.bottom == 0;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is SuccessAddClaimToAdminAppState) {
          if(state.simpleModel.status == true){

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.success, context: context);
            Navigator.pop(context);

          }else {

            showFlutterToast(message: '${state.simpleModel.message}', state: ToastStates.error, context: context);

          }

        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var userProfile = cubit.profile;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Add Message',
            actions: [
              Visibility(
                visible: isVisible,
                child: ConditionalBuilder(
                  condition: state is! LoadingAddClaimToAdminAppState,
                  builder: (context) =>  IconButton(
                    onPressed: () {
                      if(CheckCubit.get(context).hasInternet) {
                        cubit.addClaimToAdmin(
                            message: msgController.text,
                            claimDate: DateFormat('yyyy-MM-dd \'at\' HH:mm').format(DateTime.now()),
                            body: userProfile?.user?.name ?? '',
                            idUser: userId);
                        focusNode.unfocus();
                        setState(() {
                          isListening = false;
                        });
                      } else {
                        focusNode.unfocus();
                        setState(() {
                          isListening = false;
                        });
                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                    ),
                  ),
                  fallback: (context) => Padding(
                    padding: const EdgeInsets.only(
                      right: 6.0,
                    ),
                    child: IndicatorRingScreen(os: getOs()),
                  ),
                ),
              ),
              const SizedBox(
                width: 6.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.5,
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('2eb7c9')
                          : HexColor('b3d8ff'),
                      child: CircleAvatar(
                        radius: 27.0,
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                            radius: 26.0,
                            backgroundColor: ThemeCubit.get(context).isDark
                                ? HexColor('2eb7c9')
                                : HexColor('b3d8ff'),
                            backgroundImage: NetworkImage(
                                '${userProfile?.user?.profileImage}')),
                      ),
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    Text(
                      '${userProfile?.user?.name}',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 150.0,
                    ),
                    child: TextFormField(
                      controller: msgController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        height: 1.4,
                        // color: isListening ? Colors.black : Colors.grey.shade500,
                      ),
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type to write something ...\n\nOr hold the button and speak',
                        border: InputBorder.none,
                        suffixIcon: msgController.text.isNotEmpty ?
                        CircleAvatar(
                          radius: 14.0,
                          backgroundColor: ThemeCubit.get(context).isDark ? HexColor('15909d')
                              : HexColor('b3d8ff'),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                msgController.text = '';
                                isVisible = false;
                                if(isListening){
                                  isListening = false;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: ThemeCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ) : null,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isVisible = true;
                          });
                        } else {
                          setState(() {
                            isVisible = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: isFab,
            child: AvatarGlow(
                glowColor: ThemeCubit.get(context).isDark
                    ? HexColor('15909d')
                    : HexColor('b6d9ff'),
                endRadius: 85.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                animate: isListening,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: GestureDetector(
                  onTapDown: (details) async {
                    if (!isListening) {
                      var available = await speechToText.initialize();
                      if (available) {
                        setState(() {
                          isListening = true;
                        });
                        speechToText.listen(onResult: (result) {
                          setState(() {
                            msgController.text = result.recognizedWords;
                            isVisible = true;
                          });
                        });
                      }
                    }
                  },
                  onTapUp: (details) {
                    if(isListening) {
                      setState(() {
                        isListening = false;
                      });
                      speechToText.stop();
                    }
                  },
                  child: CircleAvatar(
                    radius: 42.0,
                    backgroundColor: ThemeCubit.get(context).isDark
                        ? ((isListening) ? Colors.white : Theme.of(context).scaffoldBackgroundColor)
                        : ((isListening) ? Colors.black : Theme.of(context).scaffoldBackgroundColor),
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: ThemeCubit.get(context).isDark
                          ? HexColor('15909d')
                          : HexColor('b3d8ff'),
                      child: isListening
                          ? Icon(
                        Icons.mic_rounded,
                        color: ThemeCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                      )
                          : Icon(
                        Icons.mic_none_rounded,
                        color: ThemeCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                )),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
        );
      },
    );

  }
}
