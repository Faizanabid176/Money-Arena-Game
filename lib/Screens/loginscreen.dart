import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:playandearnmoney/Screens/Homepage.dart';
import 'package:playandearnmoney/Screens/SignupScreen.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/main.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';
  bool isloading = false;

  Future<void> _submitForm(BuildContext context) async {
    final String password = _passwordController.text.trim();

    // Make API call
    final response = await http.get(Uri.parse(
        'https://faizanabid007.000webhostapp.com/Api/api.php?number=$_phoneNumber&password=$password'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        final userData = jsonResponse[0];

        // Check if the response contains the user and password match
        if (userData['Userid'] == _phoneNumber &&
            userData['Password'] == password) {
          await prefs.setBool('login', true);
          await prefs.setString('username', userData['Username']);
          await prefs.setString('phoneno', _phoneNumber);
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
          );
        } else {
          setState(() {
            isloading = false;
          });
          VxToast.show(context, msg: 'Invalid Username or Password');
        }
      } else {
        setState(() {
          isloading = false;
        });
        isloading = false;
        VxToast.show(context,
            msg: 'Invalid Username or Password',
            bgColor: Colors.red,
            textColor: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: schemecolor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.asset('assets/images/login.jpg'),
                    ),
                  ),
                  const Text(
                    'Login To Continue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ).pOnly(top: 10, bottom: 10),
                  IntlPhoneField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    initialCountryCode: 'US',
                    onChanged: (PhoneNumber? value) {
                      setState(() {
                        _phoneNumber = value!.completeNumber;
                      });
                    },
                    validator: (PhoneNumber? value) {
                      if (value == null || value.number.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  isloading
                      ? CircularProgressIndicator(
                          color: schemecolor,
                          strokeWidth: 2,
                        ).p12()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                _submitForm(context);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
