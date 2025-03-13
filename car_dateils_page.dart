import 'package:car_rental/car_model_class/car.dart';
import 'package:car_rental/transaction/booking_page.dart';
import 'package:flutter/material.dart';

class CarDetailsPage extends StatelessWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    (car.imageName?.isNotEmpty ?? false)
                        ? Image.asset(
                          'assets/images/${car.imageName}', // Ensure correct asset path
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.car_rental, size: 50),
                              ),
                        )
                        : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.car_rental, size: 50),
                        ),
              ),
            ),
            SizedBox(height: 20),

            // Car Name
            Text(
              car.carName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Price
            Text(
              "Price: ₱${car.amount}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Car Specifications
            Text(
              "Specifications:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("• Type: ${car.type}"),
            Text("• Transmission: ${car.transmission}"),
            Text("• Speed: ${car.speed} km/h"),

            SizedBox(height: 20),

            // Book Now Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(car: car),
                    ),
                  );
                },
                child: Text(
                  "Book Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
