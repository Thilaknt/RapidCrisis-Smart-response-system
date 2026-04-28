import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/emergency_provider.dart';
import '../widgets/emergency_button.dart';
import '../widgets/voice_listener.dart';
class EmergencyTriggerScreen extends StatefulWidget {
  const EmergencyTriggerScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyTriggerScreen> createState() => _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState extends State<EmergencyTriggerScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize speech services when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyProvider>().initializeSpeech();
    });

    // Setup pulsing animation for the emergency button when triggered
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Deep dark theme background
      appBar: AppBar(
        title: const Text(
          'Emergency Alert', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<EmergencyProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // Voice Trigger Status Banner
                  VoiceListener(isListening: provider.isListening),
                  
                  const SizedBox(height: 12),
                  
                  // Recognized Voice Text Output
                  if (provider.recognizedText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Heard: "${provider.recognizedText}"',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 50),
                  
                  // The Large Red Emergency Button
                  EmergencyButton(
                    onTap: () {
                      provider.triggerEmergency(
                        source: 'manual_button', 
                        message: _messageController.text,
                        userId: 'current_user_id', // Note: Needs valid user ID in real usage, handled in provider gracefully.
                      );
                    },
                    isAlertActive: provider.isAlertActive,
                    pulseAnimation: _pulseAnimation,
                  ),

                  const SizedBox(height: 60),

                  // Optional Text input for manual context
                  TextField(
                    controller: _messageController,
                    onChanged: provider.updateManualMessage,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Enter emergency context (optional)',
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.edit_note_rounded, color: Colors.black54),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 32),
                  
                  // Toggle Voice Monitoring Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => provider.toggleListening(),
                      icon: Icon(
                        provider.isListening ? Icons.mic_off : Icons.mic, 
                        color: provider.isListening ? Colors.redAccent : Colors.black87,
                      ),
                      label: Text(
                        provider.isListening ? 'Stop Voice Trigger' : 'Start Voice Trigger',
                        style: TextStyle(
                           color: provider.isListening ? Colors.redAccent : Colors.black87,
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: provider.isListening ? Colors.redAccent.withOpacity(0.5) : Colors.black26,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
