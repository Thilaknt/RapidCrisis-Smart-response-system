import 'package:flutter/material.dart';

class VoiceListener extends StatelessWidget {
  final bool isListening;

  const VoiceListener({
    Key? key,
    required this.isListening,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isListening 
            ? Colors.red.withOpacity(0.15) 
            : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isListening ? Colors.redAccent.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: isListening ? Colors.redAccent : Colors.black54,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isListening 
                  ? 'Listening... say "help" or "save me"' 
                  : 'Tap microphone button to start voice trigger monitor',
              style: TextStyle(
                color: isListening ? Colors.redAccent.shade100 : Colors.black54,
                fontSize: 15,
                fontWeight: isListening ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
