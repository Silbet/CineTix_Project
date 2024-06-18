import 'package:flutter/material.dart';

import 'payment_card.dart';
import 'payment_phone.dart';
import 'payment_culture.dart';

abstract class PaymentStrategy {
  void pay(double amount);
}

class PaymentMethodSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalAmount = 12000.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('결제 방법 선택'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _showCardPaymentDialog(context, totalAmount);
              },
              child: Text('카드 결제'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _showPhonePaymentDialog(context, totalAmount);
              },
              child: Text('휴대폰 결제'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _showCultureVoucherPaymentDialog(context, totalAmount);
              },
              child: Text('문화상품권 결제'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardPaymentDialog(BuildContext context, double amount) async {
    bool paymentSuccess = await showDialog(
      context: context,
      builder: (context) => CardPaymentDialog(
        onPaymentResult: (success) => success,
      ),
    );

    if (paymentSuccess) {
      _showCompletionDialog(context);
    }
  }

  void _showPhonePaymentDialog(BuildContext context, double amount) async {
    bool paymentSuccess = await showDialog(
      context: context,
      builder: (context) => PhonePaymentDialog(
        onPaymentResult: (success) => success,
      ),
    );

    if (paymentSuccess) {
      _showCompletionDialog(context);
    }
  }

  void _showCultureVoucherPaymentDialog(
      BuildContext context, double amount) async {
    bool paymentSuccess = await showDialog(
      context: context,
      builder: (context) => CultureVoucherPaymentDialog(
        onPaymentResult: (success) => success,
      ),
    );

    if (paymentSuccess) {
      _showCompletionDialog(context);
    }
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('결제 완료'),
          content: Text('예매가 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
