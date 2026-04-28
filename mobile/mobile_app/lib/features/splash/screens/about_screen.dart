import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  void _continue(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    
    // Resume original startup flow checking from here
    if (authProvider.isAuthenticated) {
      final role = authProvider.currentUser?.role;
      if (role == null) {
        Navigator.of(context).pushNamed('/onboarding');
      } else if (role == 'user') {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        // Volunteer or Responder
        Navigator.of(context).pushReplacementNamed('/nearby-alerts');
      }
    } else {
      Navigator.of(context).pushNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.map,
                  size: 60,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Rapid Response',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'AI-Powered Crisis Management',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'This application connects people in emergencies with professional and crowdsourced volunteer responders instantly. \n\nPowered by Google Maps for precise routing, Twilio for communication, and Gemini AI for intelligent crisis triage.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _continue(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
