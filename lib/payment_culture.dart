import 'package:flutter/material.dart';
import 'payment.dart';

class CultureVoucherPaymentStrategy implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('문화상품권 결제: $amount 원');
  }
}

class CultureVoucherPaymentDialog extends StatefulWidget {
  final Function(bool success) onPaymentResult;

  CultureVoucherPaymentDialog({required this.onPaymentResult});

  @override
  _CultureVoucherPaymentDialogState createState() =>
      _CultureVoucherPaymentDialogState();
}

class _CultureVoucherPaymentDialogState
    extends State<CultureVoucherPaymentDialog> {
  TextEditingController _pinController = TextEditingController();
  String _selectedVoucherType = '파이썬 머니';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('문화상품권 결제'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedVoucherType,
              decoration: InputDecoration(
                labelText: '문화상품권 종류',
              ),
              items: ['파이썬 머니', '자바 머니', '플러터 머니']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVoucherType = value!;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'PIN 번호 입력 (18자리)',
              ),
              keyboardType: TextInputType.number,
              maxLength: 18,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _processPayment();
          },
          child: Text('결제하기'),
        ),
      ],
    );
  }

  void _processPayment() {
    String pin = _pinController.text;
    bool success = true;

    if (pin.length == 18) {
      widget.onPaymentResult(true);
      Navigator.pop(context, true);
    } else {
      _showAlertDialog('PIN 번호를 정확히 입력해주세요.');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}
