import 'dart:io';

import 'package:car_rental/auth/auth_service.dart';
import 'package:car_rental/car_model_class/car.dart';
import 'package:car_rental/car_model_class/car_list.dart';
import 'package:car_rental/login_and_signup/login.dart';
import 'package:car_rental/pages/about_us_page.dart';
import 'package:car_rental/pages/car_dateils_page.dart';
import 'package:car_rental/pages/personal_information_page.dart';
import 'package:car_rental/pages/settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashpage extends StatefulWidget {
  const Dashpage({super.key});

  @override
  State<Dashpage> createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    SearchPage(),
    Bookingpage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade100, // Light purple at the top
            Colors.purple.shade300, // Medium purple
            Colors.purple.shade700, // Darker purple blending into nav bar
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Allows gradient to be seen
        body: _pages[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent, // Blend with gradient
          color: Colors.purple.shade700,
          buttonBackgroundColor: Colors.purple.shade700,
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          index: _currentIndex,
          items: [
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.search, size: 30, color: Colors.white),
            Icon(Icons.book_online, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final List<Car> cars = CarList().carList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rentzy',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPromotionBanner(),
            SizedBox(height: 20),
            _buildSectionTitle('Popular Cars'),
            _buildHorizontalList(context, cars),
            SizedBox(height: 20),
            _buildSectionTitle('Recommended for You'),
            _buildHorizontalList(context, cars.reversed.toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHorizontalList(BuildContext context, List<Car> carList) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: carList.length,
        itemBuilder: (context, index) => _buildCarCard(context, carList[index]),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Car car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child:
                    (car.imageName?.isNotEmpty ?? false)
                        ? Image.asset(
                          'assets/images/${car.imageName}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                        : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.car_rental, size: 50),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: Column(
                children: [
                  Text(
                    car.carName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₱${car.amount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚗 30% Off',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'This July',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Travel in style and save big this month.',
            style: TextStyle(color: Colors.white60),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text('Try Now'),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  String selectedCarType = "All";
  String selectedTransmission = "All";
  String selectedBrand = "All";

  final List<Car> carList = CarList().carList;

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
          title: Text(
            'Search Cars',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple.shade400,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  labelText: 'Search for a car',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 10),

              // Filters Row
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      "Type",
                      selectedCarType,
                      ['All', 'Sedan', 'SUV', 'Sportscar', 'Pickup'],
                      (value) {
                        setState(() => selectedCarType = value!);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      "Transmission",
                      selectedTransmission,
                      ['All', 'Automatic', 'Manual'],
                      (value) {
                        setState(() => selectedTransmission = value!);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      "Brand",
                      selectedBrand,
                      _getUniqueBrands(),
                      (value) {
                        setState(() => selectedBrand = value!);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Car List
              Expanded(
                child: ListView(
                  children:
                      carList
                          .where(
                            (car) =>
                                (searchQuery.isEmpty ||
                                    car.carName.toLowerCase().contains(
                                      searchQuery.trim().toLowerCase(),
                                    )) &&
                                (selectedCarType == 'All' ||
                                    car.type == selectedCarType) &&
                                (selectedTransmission == 'All' ||
                                    car.transmission == selectedTransmission) &&
                                (selectedBrand == 'All' ||
                                    car.carName.startsWith(selectedBrand)),
                          )
                          .map((car) => _buildCarCard(car, context))
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown Builder
  Widget _buildDropdown(
    String label,
    String selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          onChanged: onChanged,
          items:
              options
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
        ),
      ],
    );
  }

  // Get Unique Brands
  List<String> _getUniqueBrands() {
    Set<String> uniqueBrands = {'All'};
    uniqueBrands.addAll(carList.map((car) => car.carName.split(" ").first));
    return uniqueBrands.toList();
  }

  // Car List Tile Builder
  Widget _buildCarCard(Car car, BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            (car.imageName?.isNotEmpty ?? false)
                ? Image.asset(
                  'assets/images/${car.imageName}', // Fixed image path
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                )
                : Icon(Icons.car_rental, size: 50),
        title: Text(car.carName),
        subtitle: Text('${car.amount} - ${car.transmission}'),
        trailing: Icon(Icons.directions_car),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
            ),
      ),
    );
  }
}

class Bookingpage extends StatefulWidget {
  const Bookingpage({super.key});

  @override
  State<Bookingpage> createState() => _BookingpageState();
}

class _BookingpageState extends State<Bookingpage> {
  List<Map<String, dynamic>> bookedCars = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final supabase = Supabase.instance.client;
    try {
      final List<Map<String, dynamic>> response =
          await supabase.from('transactions').select();

      setState(() {
        bookedCars = response;
      });
    } catch (error) {
      print("❌ Error fetching bookings: $error");
    }
  }

  Future<void> deleteBooking(int index) async {
    final supabase = Supabase.instance.client;
    final bookingId = bookedCars[index]['id'];

    try {
      await supabase.from('transactions').delete().match({'id': bookingId});

      setState(() {
        bookedCars.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking canceled successfully.")),
      );
    } catch (error) {
      print("❌ Error deleting booking: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel booking: $error")),
      );
    }
  }

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
            "My Bookings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple.shade400,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child:
              bookedCars.isEmpty
                  ? const Center(
                    child: Text(
                      "No bookings available.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                  : ListView.builder(
                    itemCount: bookedCars.length,
                    itemBuilder: (context, index) {
                      final car = bookedCars[index];
                      return buildCarCard(car, index);
                    },
                  ),
        ),
      ),
    );
  }

  Widget buildCarCard(Map<String, dynamic> car, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car['car_name'] ?? "Unknown Car",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            buildDetailRow("Price:", "₱${(car['price'] ?? 0).toString()}"),
            buildDetailRow(
              "Driver Fee:",
              "₱${(car['driver_fee'] ?? 0).toString()}",
            ),
            buildDetailRow("Total:", "₱${(car['total'] ?? 0).toString()}"),
            buildDetailRow("Payment Method:", car['payment_method'] ?? "N/A"),
            buildDetailRow(
              "Date:",
              car['created_at']?.toString().split('T')[0] ?? "Unknown",
            ), // Added date
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => showCancelDialog(context, index),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cancel, size: 18),
                  SizedBox(width: 5),
                  Text("Cancel Booking"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void showCancelDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteBooking(index);
              },
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  File? imageFile;
  String? imageUrl;

  // Pick image from gallery
  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  // Upload image to Supabase
  Future uploadImage() async {
    if (imageFile == null) return;

    try {
      final BuildContext currentContext =
          context; // Store context before async gaps

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'avatars/$fileName.jpg';

      // Upload image to Supabase
      await Supabase.instance.client.storage
          .from('avatars')
          .upload(path, imageFile!);

      // Get public URL
      final publicUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(path);

      setState(() {
        imageUrl = publicUrl;
      });

      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text('Upload successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.shade700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          imageUrl != null
                              ? NetworkImage(imageUrl!)
                              : (imageFile != null
                                  ? FileImage(imageFile!) as ImageProvider
                                  : null),
                      child:
                          imageFile == null && imageUrl == null
                              ? Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.purple.shade700,
                              )
                              : null,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: Icon(Icons.image),
                        label: Text('Pick Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: uploadImage,
                        icon: Icon(Icons.cloud_upload),
                        label: Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Personal Information
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.purple),
                title: Text("Personal Information"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInformationPage(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // Settings
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.green),
                title: Text("Settings"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // About Us
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text("About Us"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(Icons.logout),
                label: Text("Logout", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  AuthService().signOut().then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
