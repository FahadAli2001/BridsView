import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


class PaymentController extends ChangeNotifier {
  String? _userId;
  String? _token;
  String? get userId => _userId;
  String? get token => _token;
  Map<String, dynamic>? paymentIntent;

  Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    _token = sp.getString("token")!;
    log("user id : $userId");
    log("user token : $token");
    notifyListeners();
  }

  Future<void> makePayment(context) async {
    try {
      paymentIntent = await createPaymentIntent("15", "USD");

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret:
                      'sk_test_51PYYmlFwqpbZ1f3dP8ynMZECE1JMdKba2C2xz1ZCeSRnemKZ80pDxU5FNW7Nq1B4NfiVVH5Um3oSMgOH7pzWLUaf00b5kAmxj2',
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // googlePay:
                  //     const PaymentSheetGooglePay(merchantCountryCode: "US"),
                  applePay: const PaymentSheetApplePay(
                    merchantCountryCode: "US",
                  ),
                  customFlow: true,
                  appearance: const PaymentSheetAppearance(
                      primaryButton: PaymentSheetPrimaryButtonAppearance()),
                  style: ThemeMode.light,
                  merchantDisplayName: 'BirdsView'))
          .then((value) {});
      displayPaymentSheet(context);
    } catch (e) {
      log("makePayment : $e");
    }
  }

  displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        log('payment intent${paymentIntent!['id']}');
        log('payment intent${paymentIntent!['client_secret']}');
        log('payment intent${paymentIntent!['amount']}');
        log('payment intent$paymentIntent');

        showCustomSuccessToast(message: "Paid Successfully");
        log("paaaaaaaaiiiiiiiid");
        updateUserStatus(context);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        log('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      log('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      log('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51PYYmlFwqpbZ1f3dP8ynMZECE1JMdKba2C2xz1ZCeSRnemKZ80pDxU5FNW7Nq1B4NfiVVH5Um3oSMgOH7pzWLUaf00b5kAmxj2',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      log('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (e) {
      log("create payment intent : $e");
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<void> updateUserStatus(context) async {
    try {
      var response =
          await http.post(Uri.parse(subscribeApi), body: {"user_id": userId});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
      } else {
        log("updateUserStatus ${response.body}");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
