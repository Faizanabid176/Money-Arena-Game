import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playandearnmoney/config.dart';
import 'package:playandearnmoney/widgets/paymentgridview.dart';
import 'package:playandearnmoney/widgets/userlistrewarded.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletScreen extends StatelessWidget {
  final num coinss;
  const WalletScreen({Key? key, required this.coinss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    num coins = coinss;
    num balance = 0.01;
    double usd = coins / 300000;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: schemecolor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
        color: schemecolor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.05,
                screenWidth * 0.05,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coins',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (screenWidth + screenHeight) / 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.money_dollar_circle_fill,
                        size: 24,
                        color: goldencolor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$coins',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth + screenHeight) / 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                height: 1,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                0,
                screenWidth * 0.05,
                screenHeight * 0.02,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Balance',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth + screenHeight) / 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'USD ${usd.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth + screenHeight) / 50,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: FittedBox(
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.money_dollar_circle_fill,
                              color: goldencolor,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '3,000',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (screenWidth + screenHeight) / 70,
                              ),
                            ),
                            Text(
                              '  =  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (screenWidth + screenHeight) / 70,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.money_dollar,
                              color: goldencolor,
                              size: 18,
                            ),
                            Text(
                              '0.01 USD',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: (screenWidth + screenHeight) / 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.055,
                0,
                screenWidth * 0.1,
                screenHeight * 0.025,
              ),
              child: Text(
                'Minimum Withdraw 1 USD',
                style: TextStyle(
                    fontSize: (screenWidth + screenHeight) / 60,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.05,
                          screenHeight * 0.02,
                          screenWidth * 0.05,
                          0,
                        ),
                        child: Text(
                          'Withdraw Proof',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth + screenHeight) / 60,
                          ),
                        ),
                      ),
                      RandomAvatarList(itemCount: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.05,
                          screenHeight * 0.02,
                          screenWidth * 0.05,
                          0,
                        ),
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth + screenHeight) / 60,
                          ),
                        ),
                      ),
                      PaymentGridView(
                        balance: usd,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
