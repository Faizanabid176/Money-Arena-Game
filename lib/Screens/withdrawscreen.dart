import 'package:flutter/material.dart';
import 'package:playandearnmoney/config.dart';
import 'package:velocity_x/velocity_x.dart';

class WithdrawScreen extends StatefulWidget {
  WithdrawScreen({Key? key, required this.paymentOption, required this.balance})
      : super(key: key);
  final Map<String, dynamic> paymentOption;
  num balance;
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _accountNameFocusNode = FocusNode();
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _emailfocusnode = FocusNode();

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _accountNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _emailfocusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymethod = widget.paymentOption['name'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Withdraw Amount',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: schemecolor, // Set the app bar color to blue
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              widget.paymentOption['image'],
              height: 160,
              width: double.infinity,
            ).p12(),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    focusNode: _amountFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'Balance : ${widget.balance} USD',
                    style: TextStyle(
                        color: Color.fromARGB(
                          255,
                          255,
                          17,
                          0,
                        ),
                        fontWeight: FontWeight.bold),
                  ).pOnly(left: 12, top: 4),
                  const SizedBox(height: 16),
                  if (paymethod == 'JazzCash' || paymethod == 'EasyPaisa')
                    TextFormField(
                      focusNode: _accountNameFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter account holder name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account holder name';
                        }
                        return null;
                      },
                    ),
                  if (paymethod != 'CashMall' && paymethod != 'CoinBase')
                    SizedBox(height: 16),
                  if (paymethod != 'CashMall' && paymethod != 'CoinBase')
                    TextFormField(
                      focusNode: _accountNumberFocusNode,
                      decoration: InputDecoration(
                        hintText:
                            paymethod == 'JazzCash' || paymethod == 'EasyPaisa'
                                ? 'e.g +92304XXXXXXX'
                                : paymethod == 'Payeer'
                                    ? 'e.g P123456789'
                                    : 'e.g U895321XX',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        return null;
                      },
                    ),
                  if (paymethod == 'CashMall' || paymethod == 'CoinBase')
                    SizedBox(height: 16),
                  if (paymethod == 'CashMall' || paymethod == 'CoinBase')
                    TextFormField(
                      focusNode: _emailfocusnode,
                      decoration: InputDecoration(
                        hintText: 'e.g Example@gmail.com',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: schemecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: Text(
                      'Withdraw',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
// Add functionality to navigate to the transactions history screen
                    },
                    child: Text(
                      'View Transaction History',
                      style: TextStyle(
                        color: schemecolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
