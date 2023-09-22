import 'package:flutter/material.dart';
import 'package:playandearnmoney/Screens/withdrawscreen.dart';

class PaymentGridView extends StatelessWidget {
  final num balance;
  PaymentGridView({Key? key, required this.balance}) : super(key: key);
  final List<Map<String, dynamic>> paymentOptions = [
    {
      'name': 'EasyPaisa',
      'image':
          'https://www.phoneworld.com.pk/wp-content/uploads/2022/05/IMG_2796-1.jpg',
    },
    {
      'name': 'JazzCash',
      'image':
          'https://www.nadeem-computers.com/wp-content/uploads/2020/08/jazzcashlogo.jpg',
    },
    {
      'name': 'CashMall',
      'image':
          'https://play-lh.googleusercontent.com/hMmp5RaoRU56wSYXRiSgsT8uaHhNFZwkxVUbS9gyyGolq0wOUUYimJD1ztEX9CBGPFU=w240-h480-rw'
    },
    {
      'name': 'Payeer',
      'image':
          'https://i.pinimg.com/736x/f6/46/30/f646307ee26d1a714e1cae84fb58aa49.jpg',
    },
    {
      'name': 'CoinBase',
      'image': 'https://logowik.com/content/uploads/images/coinbase-new4201.jpg'
    },
    {
      'name': 'Perfect Money',
      'image':
          'https://howtotechnaija.com/wp-content/uploads/2019/03/perfect_money.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: paymentOptions.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final payment = paymentOptions[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WithdrawScreen(
                            paymentOption: payment,
                            balance: balance,
                          )));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  payment['image'],
                  height: 60.0,
                  width: 60.0,
                ),
                Text(
                  payment['name'],
                  style: TextStyle(
                      fontSize: (screenWidth + screenHeight) / 60,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
