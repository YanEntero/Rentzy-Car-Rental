import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade200, Colors.purple.shade500],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "About Us",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple.shade400,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About This App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Rentzy is your go-to car rental app, designed for convenience, flexibility, and affordability. "
                "Whether you need a car for a weekend getaway, business trip, or daily commute, Rentzy connects you with a wide range of vehicles to suit your needs.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 7, 3, 3),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 1, 1),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Email: support@Rentzy.com",
                style: TextStyle(color: Color.fromARGB(255, 8, 5, 5)),
              ),
              const Text(
                "Phone: +63 912 345 6789",
                style: TextStyle(color: Color.fromARGB(255, 10, 6, 6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
