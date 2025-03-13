class Car {
  final String id;
  final String carName;
  final DateTime? datePurchased;
  final double amount;
  final String transmission;
  final String type;
  final String? imageName; // Use imageName instead of imageUrl
  final double speed;

  Car({
    required this.id,
    required this.carName,
    this.datePurchased,
    required this.amount,
    required this.transmission,
    required this.type,
    this.imageName, // Nullable to handle missing images
    required this.speed,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      carName: json['carName'],
      datePurchased:
          json['datePurchased'] != null
              ? DateTime.parse(json['datePurchased'])
              : null,
      amount: double.parse(json['amount'].toString()),
      transmission: json['transmission'],
      type: json['type'] ?? "Unknown",
      imageName: json['imageName'],
      speed: double.parse(json['speed'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carName': carName,
      'datePurchased': datePurchased?.toIso8601String(),
      'amount': amount,
      'transmission': transmission,
      'type': type,
      'imageName': imageName,
      'speed': speed,
    };
  }
}
