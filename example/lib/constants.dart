import 'package:flutter_hyperpay/flutter_hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String? creditcardEntityID = '8ac9a4c981425102018161ab30687a53';
  @override
  String? madaEntityID = '8ac9a4c981425102018161abca5d7a60';
  @override
  String? applePayEntityID = '';
  @override
  Uri checkoutEndpoint =
      Uri(scheme: 'https', host: 'oppwa.com', path: '/v1/checkouts');
  @override
  Uri statusEndpoint =
      Uri(scheme: 'https', host: 'oppwa.com', path: '/v1/checkouts');
  @override
  PaymentMode paymentMode = PaymentMode.live;
}
