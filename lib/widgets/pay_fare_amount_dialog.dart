import 'package:bus_client_app/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PayFareAmountDialog extends StatefulWidget {
  double? fareAmount;

  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialog();
}

class _PayFareAmountDialog extends State<PayFareAmountDialog> {
  Razorpay _razorpay = Razorpay();
  late Function _handlePaymentSucess;
  late Function _handlePaymentError;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _handlePaymentSucess = (PaymentSuccessResponse response) {
      print("Payment Sucess, Payment ID: ${response.paymentId}");
      Navigator.pop(context, "CashPayed");
    };

    _handlePaymentError = (PaymentFailureResponse response) {
      print(
          "Payment Error, Code: ${response.code.toString()} Message: ${response.message}");
      Navigator.pop(context, "Payment Error");
    };
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet, Response: ${response.walletName}");
    //Navigator.pop(context, "External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Pay Amount".toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Rs${widget.fareAmount.toString()}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total Pay amount, please Pay it to the Driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.pop(context, "CashPayed");
                    //_openRazorpay();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Pay Amount",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "\Rs" + widget.fareAmount!.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      _openRazorpay();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Razorpay",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _openRazorpay() async {
    _razorpay = Razorpay();
    // Create a options object for the payment
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': Env.keyId,
      'amount': (widget.fareAmount! * 100).toInt(),
      'name': 'Bus Tracking App',
      'description': 'Payment for Bus Driver',
      'timeout': 300, // in seconds
      'prefill': {
        'contact': '0382240708',
        'email': 'BusInfo@info.com',
      },
    };

    // Call the payment method
    _razorpay.open(options);
  }
}
