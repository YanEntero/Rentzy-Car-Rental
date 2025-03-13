import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:car_rental/transaction/payment_success_page.dart';

class ConfirmationPage extends StatefulWidget {
  final String? carName;
  final double? price;
  final double? driverFee;
  final double? total;
  final String? paymentMethod;

  const ConfirmationPage({
    super.key,
    required this.carName,
    required this.price,
    required this.driverFee,
    required this.total,
    required this.paymentMethod,
  });

  @override
  ConfirmationPageState createState() => ConfirmationPageState(); // <-- Also update here
}

class ConfirmationPageState extends State<ConfirmationPage> {
  // <-- Remove underscore here

  bool isLoading = false; // Track button state

  Future<void> saveBookingToDatabase() async {
    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase.from('transactions').insert({
            'car_name': widget.carName,
            'price': widget.price,
            'driver_fee': widget.driverFee,
            'total': widget.total,
            'payment_method': widget.paymentMethod,
            'created_at': DateTime.now().toIso8601String(),
          }).select(); // <-- Ensures we get back the inserted data

      if (response.isEmpty) {
        throw Exception("Transaction saved, but no response received.");
      }

      debugPrint("✅ Transaction saved successfully: $response");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction saved successfully!")),
      );

      // Navigate to success page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PaymentSuccessPage(totalAmount: widget.total ?? 0),
        ),
      );
    } catch (error) {
      debugPrint("❌ Error: $error");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save transaction. Error: $error")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double finalTotal =
        widget.total ?? ((widget.price ?? 0) + (widget.driverFee ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Confirmation"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text("You're about to pay for the rental of"),
            Text(
              widget.carName ?? "Car not specified ❌",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildPriceRow(
              "Rental Price:",
              "₱${(widget.price ?? 0).toStringAsFixed(2)}",
            ),
            _buildPriceRow(
              "Driver's Fee:",
              "₱${(widget.driverFee ?? 0).toStringAsFixed(2)}",
            ),
            const Divider(),
            _buildPriceRow(
              "TOTAL",
              "₱${finalTotal.toStringAsFixed(2)}",
              isTotal: true,
            ),
            const SizedBox(height: 20),
            _buildPriceRow(
              "Payment Method:",
              widget.paymentMethod ?? "Not Selected",
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveBookingToDatabase,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text("Confirm Payment"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
