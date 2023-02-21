import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';
import 'constants.dart';
import 'formatters.dart';

class CheckoutView2 extends StatefulWidget {
  const CheckoutView2({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutView2> createState() => _CheckoutView2State();
}

class _CheckoutView2State extends State<CheckoutView2> {
  late HyperpayPlugin hyperpay;
  bool isLoading = false;
  String sessionCheckoutID = '';

  @override
  void initState() {
    setup();
    super.initState();
  }

  setup() async {
    hyperpay = await HyperpayPlugin.setup(config: TestConfig());
  }

  void initPaymentSession(BrandType brandType, double amount) {
    hyperpay.initSession(
      checkoutSetting: CheckoutSettings(
        brand: brandType,
        amount: amount,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer OGFjOWE0Yzk4MTQyNTEwMjAxODE2MWFhNzQzYzdhNDR8eHdrVzNEakJ5aA==',
        },
      ),
    );
    sessionCheckoutID = '21ECCD5C5123680FDB3A1D48D5B9FE66.prod01-vm-tx06';
    hyperpay.checkoutID = sessionCheckoutID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });

            // Make a CardInfo from the controllers
            CardInfo card = CardInfo(
              holder: 'Yahya Alfaqih',
              cardNumber: '4893198149849345',
              cvv: '585',
              expiryMonth: '05',
              expiryYear: '2023',
            );

            try {
              initPaymentSession(BrandType.mada, 1);

              final result = await hyperpay.pay(card);

              switch (result) {
                case PaymentStatus.init:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment session is still in progress'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                  break;
                // For the sake of the example, the 2 cases are shown explicitly
                // but in real world it's better to merge pending with successful
                // and delegate the job from there to the server, using webhooks
                // to get notified about the final status and do some action.
                case PaymentStatus.pending:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment pending ⏳'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                  break;
                case PaymentStatus.successful:
                  sessionCheckoutID = '';
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment approved 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  break;

                default:
              }
            } on HyperpayException catch (exception) {
              sessionCheckoutID = '';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exception.details ?? exception.message),
                  backgroundColor: Colors.red,
                ),
              );
            } catch (exception) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$exception'),
                ),
              );
            }

            setState(() {
              isLoading = false;
            });
          },
          child: Text(
            isLoading ? 'Processing your request, please wait...' : 'PAY',
          ),
        ),
      ),
    );
  }
}
