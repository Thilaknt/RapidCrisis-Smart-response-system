import 'package:flutter/material.dart';

class AlertInputScreen extends StatefulWidget {
  const AlertInputScreen({Key? key}) : super(key: key);

  @override
  State<AlertInputScreen> createState() => _AlertInputScreenState();
}

class _AlertInputScreenState extends State<AlertInputScreen> {
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Manual Alert'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please describe the emergency explicitly so responders know how to help.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe details...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Connect to EmergencyProvider when needed
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('SUBMIT ALERT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
