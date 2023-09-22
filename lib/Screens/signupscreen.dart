// ignore_for_file: prefer_function_declarations_over_variables, use_build_context_synchronously
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:playandearnmoney/Screens/Homepage.dart';
import 'package:playandearnmoney/Screens/loginscreen.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/main.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String enteredOTP = '';
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';

  Future<void> _signUpWithPhoneNumber() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Phone number verification is complete, you can proceed with user registration.
        // Implement the registration logic here
        VxToast.show(
          context,
          msg: 'Phone No Verified!',
        );
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException exception) {
        // Handle verification failed scenarios
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int? forceResendingToken]) async {
        // Open ModelBottomSheet
        showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                void verifyOTP() async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: enteredOTP);
                  await _auth
                      .signInWithCredential(credential)
                      .then((value) async {
                    enteredOTP = '';
                    await prefs.setBool('login', true);
                    await prefs.setString('username', _username.text);
                    await prefs.setString('phoneno', _phoneNumber);
                    await postData();
                    await insertCoins();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }).catchError((e) {
                    if (e.code == "invalid-verification-code") {
                      VxToast.show(context,
                          msg: 'Invalid OTP',
                          bgColor: Colors.red,
                          textColor: Colors.white);
                      enteredOTP = '';
                    }
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter the OTP sent to your phone',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      PinCodeTextField(
                        pinBoxWidth: 48,
                        pinBoxHeight: 64,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 24),
                        maxLength: 6,
                        onTextChanged: (text) {
                          setState(() {
                            enteredOTP = text;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: verifyOTP,
                        child: Text('Verify OTP'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        // Auto-verification timeout, you can implement custom logic here if needed
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(
            seconds: 60), // Set verification timeout to 60 seconds
        forceResendingToken:
            null, // Set forceResendingToken to null if not using it
      );
    } catch (e) {
      print('Error: $e');
      VxToast.show(context, msg: 'An error occurred');
    }
  }

  postData() async {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date in 'YYYY-MM-DD' format
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String creationTime = dateFormat.format(now);
    String lastOnline = dateFormat.format(now);
    String url =
        'https://faizanabid007.000webhostapp.com/Api/insertuser.php?Userid=${_phoneNumber.toString()}&Username=${_username.text}&Password=$_password&Creationtime=$creationTime&Lastonline=$lastOnline';
    // Prepare the request parameters

    try {
      // Send the POST request
      final response = await http.post(Uri.parse(url));

      // Check the response status code
      if (response.statusCode == 200) {
        print('POST request successful');
        print('Response: ${response.body}');
      } else {
        print('POST request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending POST request: $error');
    }
  }

  insertCoins() async {
    final url = Uri.parse(
        'https://faizanabid007.000webhostapp.com/Api/insertcoins.php?Userid=$_phoneNumber&Coins=0');

    final response = await http.get(url);

    // Check the status code of the response
    if (response.statusCode == 200) {
      print('Coins inserted successfully.');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: LoaderOverlay(
        overlayColor: Colors.transparent,
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Card(
              elevation: 3,
              child: Center(
                child: CircularProgressIndicator(
                  color: schemecolor,
                  strokeWidth: 1,
                ),
              ),
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: schemecolor,
            title: const Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Image.asset('assets/images/signup.jpg'),
                      ),
                    ),
                    TextFormField(
                      controller: _username,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6 || value.length > 20) {
                          return 'Password should be between 6 and 20 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password again';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _confirmPassword = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.loaderOverlay.show();
                            _signUpWithPhoneNumber();
                          }
                        },
                        color: schemecolor,
                        textColor: Colors.white,
                        child: const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
