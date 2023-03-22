import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_final/modules/startup/registerScreen/RegisterScreen.dart';
import 'package:project_final/shared/component/Component.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPassword = true;


  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                      text: 'Email',
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      prefix: Icons.email_outlined,
                      validate:  (value) {
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
                  const SizedBox(
                    height: 25.0,
                  ),
                 defaultFormField(
                     text: 'Password',
                     controller: passwordController,
                     type: TextInputType.visiblePassword,
                     prefix: Icons.lock_outline_rounded,
                     isPassword: isPassword,
                     suffix: isPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                     onPress: () {
                       setState(() {
                         isPassword = !isPassword;
                       });
                     },
                     validate: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Password must not be empty';
                       }else if (value.length < 8) {
                         return 'Password must be at least 8 characters';
                       }
                       return null;
                     }),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                 defaultButton(
                     function: (){

                     },
                     text: 'login'.toUpperCase(),
                     context: context),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     defaultTextButton(
                         onPress: () {
                           navigatorTo(context: context, screen: RegisterScreen());
                         },
                         text: 'register'.toUpperCase()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
