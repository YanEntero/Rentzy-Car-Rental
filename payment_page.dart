import 'package:car_rental/car_model_class/car.dart';
import 'package:car_rental/transaction/confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final Car car;
  final int selectedCars;
  final int selectedDays;
  final bool needsDriver;
  final String pickupLocation;

  const PaymentPage({
    super.key,
    required this.car,
    required this.selectedCars,
    required this.selectedDays,
    required this.needsDriver,
    required this.pickupLocation,
  });

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  String selectedPayment = "";
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController paypalEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                paymentOption("Cash", Icons.money, "Cash"),
                paymentOption("Mastercard", Icons.credit_card, "Card"),
                paymentOption("PayPal", Icons.account_balance_wallet, "PayPal"),
              ],
            ),
            const SizedBox(height: 20),
            _getPaymentDescription(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPaymentValid() ? Colors.purple : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: isPaymentValid() ? _proceedToConfirmation : null,
                child: const Text(
                  "Proceed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentOption(String title, IconData icon, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: selectedPayment == method ? Colors.purple : Colors.grey,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: selectedPayment == method ? Colors.purple : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPaymentDescription() {
    if (selectedPayment == "Cash") {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "You have selected Cash Payment. Please pay the exact amount to the driver upon delivery.",
          style: TextStyle(fontSize: 16),
        ),
      );
    } else if (selectedPayment == "Card") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Card Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: cardNumberController,
            decoration: const InputDecoration(labelText: "Card Number"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: expiryDateController,
            decoration: const InputDecoration(labelText: "Expiry Date (MM/YY)"),
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}/?\d{0,2}$')),
            ],
          ),
          TextField(
            controller: cvvController,
            decoration: const InputDecoration(labelText: "CVV"),
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 3,
          ),
        ],
      );
    } else if (selectedPayment == "PayPal") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter PayPal Email",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: paypalEmailController,
            decoration: const InputDecoration(labelText: "PayPal Email"),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  bool isPaymentValid() {
    if (selectedPayment == "Card") {
      return cardNumberController.text.isNotEmpty &&
          expiryDateController.text.isNotEmpty &&
          cvvController.text.isNotEmpty;
    } else if (selectedPayment == "PayPal") {
      return paypalEmailController.text.isNotEmpty;
    }
    return selectedPayment.isNotEmpty;
  }

  void _proceedToConfirmation() {
    double price = widget.car.amount; // Directly use the double value
    price *= widget.selectedCars * widget.selectedDays;

    double driverFee = widget.needsDriver ? 350.0 * widget.selectedDays : 0.0;
    double total = price + driverFee;

    // Debug print to check the car name before proceeding
    print("🚗 Passing Car Name from PaymentPage: '${widget.car.carName}'");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ConfirmationPage(
              carName: widget.car.carName, // ✅ Fixed car name reference
              price: price,
              driverFee: driverFee,
              total: total,
              paymentMethod: selectedPayment,
            ),
      ),
    );
  }
}
