import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:project_final/model/pageViewModel/PageViewModel.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

Widget buildPageItem(PageViewModel model) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
   children: [
     Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8.0),
       ),
       clipBehavior: Clip.antiAliasWithSaveLayer,
       child: SvgPicture.asset(model.image,
        width: double.infinity,
        height: 250.0,
        fit: BoxFit.cover,
       ),
     ),
     const SizedBox(
       height: 50.0,
     ),
     TextHighlight(
       text: model.text,
       words: words,
       textAlign: TextAlign.center,
       matchCase: true,
       textStyle: const TextStyle(
         fontSize: 20.0,
         letterSpacing: 0.3,
         color: Colors.black,
         fontFamily: 'Varela',
         height: 1.8,
         fontWeight: FontWeight.bold,
       ),
     ),
   ],
);


Map<String, HighlightedWord> words = {
  "CareCove": HighlightedWord(
    // onTap: () {
    //
    // },
    textStyle: TextStyle(
      fontSize: 20.0,
      color: HexColor('0571d5'),
      fontWeight: FontWeight.bold,
    ),
  ),
  "!": HighlightedWord(
    // onTap: () {
    //
    // },
    textStyle: TextStyle(
      fontSize: 20.0,
      color: HexColor('0571d5'),
      fontWeight: FontWeight.bold,
    ),
  ),
  "Get Started": HighlightedWord(
    // onTap: () {
    //
    // },
    textStyle: TextStyle(
      fontSize: 20.0,
      color: HexColor('0571d5'),
      fontWeight: FontWeight.bold,
    ),
  ),
};


Widget defaultTextButton({
   required Function onPress,
   required String text,
}) => TextButton(
  onPressed: () => onPress(),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 16.5,
      fontWeight: FontWeight.bold,
    ),
),
);


Widget defaultFormField({
  required String text,
  required TextEditingController controller,
  required TextInputType type,
  required IconData prefix,
  required String? Function(String?)? validate,
  bool isPassword = false,
  FocusNode? focusNode,
  IconData? suffix,
  Function? onPress,
  String? Function(String?)? submit,
  // Function? onTap,
  String? helperText,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  focusNode: focusNode,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    label: Text(
      text,
    ),
    errorMaxLines: 3,
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    prefixIcon: Icon(
      prefix,
    ),
    helperText: (helperText != null) ? helperText : null,
    helperStyle: (helperText != null) ? const TextStyle(
      color: Colors.grey,
    ) : null,
    suffixIcon: (suffix!=null) ? ((controller.text.isNotEmpty) ? IconButton(
        onPressed: () {
          onPress!();
        } ,
        icon: Icon(suffix)) : null): null,
  ),
  validator: validate,
  onFieldSubmitted: (value) {
    submit!(value);
  },
);


Widget defaultSimpleFormField({
  required String text,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  String? helperText,
  FocusNode? focusNode,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  focusNode: focusNode,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    label: Text(
      text,
    ),
    helperText: (helperText != null) ? helperText : null,
    helperStyle: (helperText != null) ? const TextStyle(
      color: Colors.grey,
    ) : null,
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  validator: validate,
);


Widget defaultFormVerification({
  required TextEditingController controller,
  required String? Function(String?) ? onChange,
  required String? Function(String?) ? validate,
  String? Function(String?) ? submit,
  FocusNode? focusNode,
}) => SizedBox(
     width: 55.0,
  child: TextFormField(
    controller: controller,
    inputFormatters: [
      LengthLimitingTextInputFormatter(1),
      FilteringTextInputFormatter.digitsOnly,
    ],
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    focusNode: focusNode,
    style: const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.bold,
    ),
    onChanged: onChange,
    validator: validate,
    onFieldSubmitted: (value) {
      submit!(value);
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0,),
      ),
    ),
  ),
);



Widget defaultButton({
  double width = double.infinity,
  double height = 48.0,
  required Function function,
  required String text,
  required BuildContext context,
}) =>
    SizedBox(
      width: width,
      child: MaterialButton(
        height: height,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          function();
        },
        color: ThemeCubit.get(context).isDark ? HexColor('158b96') : HexColor('0571d5'),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );


Widget defaultButton2({
  double width = double.infinity,
  double height = 48.0,
  required Function function,
  required String text,
  required BuildContext context,
}) =>
    SizedBox(
      width: width,
      child: MaterialButton(
        height: height,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          function();
        },
        color: ThemeCubit.get(context).isDark ? HexColor('15909d') : HexColor('b3d8ff'),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              color: ThemeCubit.get(context).isDark ?  Colors.white : HexColor('011d35'),
              fontSize: 19.5,
              fontWeight: FontWeight.bold),
        ),
      ),
    );


Future navigatorTo({required BuildContext context, required Widget screen}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

Future navigatorToNotBack(
    {required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
          (route) => false,
    );


defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  titleSpacing: 10.0,
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: const Icon(
      Icons.arrow_back_ios_new_rounded,
    ),
    tooltip: 'Back',
    enableFeedback: true,
  ),
  title: Text(
    title ?? '',
    maxLines: 1,
    style: const TextStyle(
      overflow: TextOverflow.ellipsis,
    ),
  ),
  actions: actions,
);


defaultNewButton({
  required String toolTip,
  required double padding,
  required IconData icon,
  required Function onPress,
  required Color color,
  Color colorIcon = Colors.black
}) => Tooltip(
  message: toolTip,
  enableFeedback: true,
  child: Material(
    color: color,
    elevation: 3.0,
    borderRadius: BorderRadius.circular(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(8.0),
      // splashColor: Colors.grey.shade200,
      onTap: () {
        onPress();
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(
            icon,
            color: colorIcon,
        ),
      ),
    ),
  ),
);


// States of notification
enum ToastStates {success , error , warning}

void showFlutterToast({
  required String message,
  required ToastStates state,
  required BuildContext context,
}) =>
    showToast(
      message,
      context: context,
      backgroundColor: chooseToastColor(s: state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 1500),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticInOut,
      reverseCurve: Curves.linear,
    );


Color chooseToastColor({
  required ToastStates s,
  context,
}) {
  Color? color;
  switch (s) {
    case ToastStates.success:
      color = HexColor('009b9b');
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}
