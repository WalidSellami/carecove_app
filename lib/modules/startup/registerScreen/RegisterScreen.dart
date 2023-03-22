import 'package:flutter/material.dart';
import 'package:project_final/shared/component/Component.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var jobController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPassword = true;

  String? firstItem;
  List<String> items = ['Doctor' , 'Pharmacist'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
               Navigator.pop(context);
            },
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            )),
      ),
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
                    'Register',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Text(
                    'Register now to join!',
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                      text: 'Full Name',
                      controller: nameController,
                      type: TextInputType.text,
                      prefix: Icons.person,
                      validate: (value){
                        if(value == null || value.isEmpty){
                          return 'Full Name must not be empty';
                        }
                        if(value.length < 2){
                          return 'Full Name must be at least 2 characters';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 25.0,
                  ),
                  DropdownButtonFormField(
                      value: firstItem,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'You must select a job';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          'Select your job',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            width: 2.0,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                      ),
                      items: items.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          firstItem = value.toString();
                        });
                      }),
                  const SizedBox(
                    height: 25.0,
                  ),
                  defaultFormField(
                      text: 'Phone',
                      controller: phoneController,
                      type: TextInputType.phone,
                      prefix: Icons.phone,
                      validate: (value){
                        if(value == null || value.isEmpty){
                          return 'Phone must not be empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 25.0,
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
                    height: 35.0,
                  ),
                 defaultButton(
                     function: (){

                     },
                     text: 'register'.toUpperCase(),
                     context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
