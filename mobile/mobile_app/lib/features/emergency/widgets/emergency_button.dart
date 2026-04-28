import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isAlertActive;
  final Animation<double> pulseAnimation;

  const EmergencyButton({
    Key? key,
    required this.onTap,
    required this.isAlertActive,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isAlertActive ? pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade700,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                spreadRadius: 20,
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
              if (isAlertActive)
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.4),
                  spreadRadius: 35,
                  blurRadius: 60,
                ),
            ],
            gradient: RadialGradient(
              colors: [
                Colors.red.shade400,
                Colors.red.shade800,
              ],
              center: const Alignment(-0.2, -0.2),
              radius: 0.9,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAlertActive ? Icons.warning_rounded : Icons.sos_rounded,
                  size: 85,
                  color: Colors.black87,
                ),
                const SizedBox(height: 12),
                Text(
                  isAlertActive ? 'TRIGGERED!' : 'TAP FOR HELP',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
