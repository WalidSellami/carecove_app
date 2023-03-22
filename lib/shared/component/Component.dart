
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:project_final/model/pageViewModel/PageViewModel.dart';
import 'package:project_final/modules/startup/onBoarding/PageViewScreen.dart';

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
  IconData? suffix,
  Function? onPress,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    label: Text(
      text,
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: (suffix!=null) ? ((controller.text.isNotEmpty) ? IconButton(
        onPressed: () {
          onPress!();
        } ,
        icon: Icon(suffix)) : null): null,
  ),
  validator: validate,
);


Widget defaultSimpleFormField({
  required String text,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  // String? helperText,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    label: Text(
      text,
    ),
    // helperText: helperText,
    // helperStyle: const TextStyle(
    //   color: Colors.red,
    // ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  validator: validate,
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
        color: HexColor('0571d5'),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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