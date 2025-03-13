import 'package:car_rental/car_model_class/car.dart';
import 'package:flutter/material.dart';
import 'payment_page.dart';

class BookingPage extends StatefulWidget {
  final Car car;

  const BookingPage({super.key, required this.car});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  int selectedCars = 1;
  int selectedDays = 1;
  bool needsDriver = false;
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Calculate rental price and driver fee
    double price = widget.car.amount * selectedCars * selectedDays;
    double driverFee = needsDriver ? 350.0 * selectedDays : 0.0;
    double total = price + driverFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
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
              "Selected Car",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pickup Location:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: "Enter pickup location",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Needs a driver"),
              value: needsDriver,
              onChanged: (bool value) {
                setState(() {
                  needsDriver = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Selected Cars:"),
                DropdownButton<int>(
                  value: selectedCars,
                  items:
                      List.generate(5, (index) => index + 1)
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCars = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Days:"),
                DropdownButton<int>(
                  value: selectedDays,
                  items:
                      List.generate(10, (index) => index + 1)
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Price: ₱${price.toStringAsFixed(2)}"),
            if (needsDriver)
              Text("Driver Fee: ₱${driverFee.toStringAsFixed(2)}"),
            Text(
              "Total: ₱${total.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  String location = locationController.text.trim();
                  if (location.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a pickup location"),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PaymentPage(
                              car: widget.car,
                              selectedCars: selectedCars,
                              selectedDays: selectedDays,
                              needsDriver: needsDriver,
                              pickupLocation: location,
                            ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
