import 'package:employee_timesheet/provider/login_provider.dart';
import 'package:employee_timesheet/screens/employee_profile.dart';
import 'package:employee_timesheet/screens/forgot_password.dart';
import 'package:employee_timesheet/screens/home_page.dart';
import 'package:employee_timesheet/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../utilis/fire_auth.dart';
import '../utilis/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _formkey = GlobalKey<FormState>();

  // final _emailTextController = TextEditingController();
  // final _passwordTextController = TextEditingController();
  // final _focusEmail = FocusNode();
  // final _focusPassword = FocusNode();
  // bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
     User? user = FirebaseAuth.instance.currentUser;
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>ProviderState(),
    builder:(context, child) {
      var provider = context.watch<ProviderState>();
    
    return GestureDetector(
      onTap: () {
        provider.focusEmail.unfocus();
        provider.focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Timesheet'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/employee image.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: provider.formkey,
                        child: Column(children: <Widget>[
                          TextFormField(
                            controller: provider.emailTextController,
                            focusNode: provider.focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              icon: const Icon(Icons.email),
                              hintText: 'Enter Your Email',
                              labelText: 'Email',
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: provider.passwordTextController,
                            focusNode: provider.focusPassword,
                            obscureText: true,
                            validator: (value) =>
                                Validator.validatePassword(Password: value),
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter Your Password',
                              labelText: 'Password',
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextButton(
                            child: const Text(
                              'Forgot Password?',
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()),
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                          provider.isProcessing
                              ? CircularProgressIndicator()
                              : TextButton.icon(
                                  onPressed: (() async {
                                    provider.focusEmail.unfocus();
                                    provider.focusPassword.unfocus();
                                    if (provider.formkey.currentState!.validate()) {
                                      
                                     var user = await provider.loginwithFirebase();
                                    
                                      if (user != null) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EmployeeProfile(
                                                    user: user,
                                                  )),
                                        );
                                      }
                                    }
                                  }),
                                  icon: const Icon(Icons.login),
                                  label: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 15.0),
                          TextButton(
                            onPressed: (() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            }),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
});
  
  }
}
