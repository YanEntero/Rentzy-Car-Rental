import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

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
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple.shade400,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                title: const Text(
                  "Enable Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Receive notifications for bookings and updates",
                ),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  "Change Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Update your account password"),
                leading: const Icon(Icons.lock),
                onTap: () {
                  print("Change Password Clicked");
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  "Delete Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Permanently delete your account"),
                leading: const Icon(Icons.delete, color: Colors.red),
                onTap: () {
                  print("Delete Account Clicked");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
