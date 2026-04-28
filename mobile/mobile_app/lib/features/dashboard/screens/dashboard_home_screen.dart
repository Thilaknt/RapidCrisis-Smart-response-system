import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/emergency_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/tokens/colors.dart';
import '../../../theme/components/app_components.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().updateLocation();
      context.read<EmergencyProvider>().initializeSpeech();
      context.read<EmergencyProvider>().startSensorMonitoring();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rapid Response Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () =>
                Navigator.of(context).pushNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: Consumer3<DashboardProvider, EmergencyProvider, AuthProvider>(
        builder: (context, dashboardProvider, emergencyProvider, authProvider,
            _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User greeting
                  Text(
                    'Hello, ${authProvider.currentUser?.name ?? 'User'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Role: ${authProvider.currentUser?.role?.toUpperCase() ?? 'USER'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Location card
                  InfoCard(
                    title: 'Your Location',
                    subtitle: dashboardProvider.formattedLocation + 
                              (dashboardProvider.lastLocationUpdate != null ? '\nUpdated: ${dashboardProvider.lastLocationUpdate!.toString().split('.').first}' : ''),
                    icon: Icon(Icons.location_on, color: AppColors.primary, size: 32),
                    onTap: () => dashboardProvider.updateLocation(),
                  ),
                  const SizedBox(height: 32),
                  // Big SOS Button
                  _buildSOSButton(context, emergencyProvider, authProvider),
                  const SizedBox(height: 24),
                  // Emergency Context Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEmergencyContextButton(
                        icon: Icons.message,
                        label: 'Text',
                        onPressed: () => _showTextMessageDialog(context, emergencyProvider, authProvider),
                      ),
                      const SizedBox(width: 16),
                      _buildEmergencyContextButton(
                        icon: emergencyProvider.isListening ? Icons.mic_off : Icons.mic,
                        label: emergencyProvider.isListening ? 'Stop' : 'Voice',
                        color: emergencyProvider.isListening ? Colors.redAccent : Colors.orangeAccent,
                        onPressed: () => emergencyProvider.toggleListening(),
                      ),
                      const SizedBox(width: 16),
                      _buildEmergencyContextButton(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onPressed: () => _openCameraAndTrigger(context, emergencyProvider, authProvider),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Alert timer if active
                  if (emergencyProvider.currentAlert != null &&
                      emergencyProvider.currentAlert!.isActive)
                    AlertCard(
                      type: AlertType.error,
                      title: 'Emergency Alert Active',
                      message: 'Time: ${emergencyProvider.currentAlert!.formattedDuration}',
                      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancel Alert?'),
                                content: const Text(
                                  'Are you sure you want to cancel this emergency alert?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      emergencyProvider.cancelCurrentAlert();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes, Cancel', style: TextStyle(color: AppColors.error)),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Cancel Alert'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Quick actions
                  const SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          icon: Icons.call,
                          label: 'Call 911',
                          onPressed: () async {
                            final url = Uri(scheme: 'tel', path: '911');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          icon: Icons.sms,
                          label: 'Send SMS',
                          onPressed: () async {
                            final url = Uri(scheme: 'sms', path: '911');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          icon: Icons.person,
                          label: 'Profile',
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/profile'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Active alerts
                  if (emergencyProvider.activeAlerts.isNotEmpty) ...[
                    const SectionHeader(title: 'Active Alerts'),
                    const SizedBox(height: 12),
                    Column(
                      children: emergencyProvider.activeAlerts
                          .take(3)
                          .map((alert) => _buildAlertItem(alert))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSOSButton(BuildContext context, EmergencyProvider emergencyProvider,
      AuthProvider authProvider) {
    return GestureDetector(
      onTapDown: (_) async {
        // Trigger emergency
        await emergencyProvider.triggerEmergency(
          source: 'button',
          message: 'Emergency SOS button pressed',
          userId: authProvider.currentUser?.id ?? 'anonymous',
        );

        if (mounted) {
          Navigator.of(context).pushNamed('/alert-status');
        }
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.critical,
              AppColors.criticalDark.withOpacity(0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.critical.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  size: 80,
                  color: AppColors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'TAP TO ALERT',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContextButton({required IconData icon, required String label, required VoidCallback onPressed, Color color = AppColors.primary}) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Future<void> _openCameraAndTrigger(BuildContext context, EmergencyProvider provider, AuthProvider auth) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      provider.triggerEmergency(
        source: 'camera',
        message: 'Emergency photo attached',
        userId: auth.currentUser?.id ?? 'anonymous',
        imagePath: pickedFile.path,
      );
      if (mounted) Navigator.of(context).pushNamed('/alert-status');
    }
  }

  void _showTextMessageDialog(BuildContext context, EmergencyProvider provider, AuthProvider auth) {
    final TextEditingController msgController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Emergency Text'),
        content: TextField(
          controller: msgController,
          decoration: const InputDecoration(hintText: 'Enter situation...'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.triggerEmergency(
                source: 'text',
                message: msgController.text.isNotEmpty ? msgController.text : 'Emergency text',
                userId: auth.currentUser?.id ?? 'anonymous',
              );
              Navigator.pop(context);
              if (mounted) Navigator.of(context).pushNamed('/alert-status');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(dynamic alert) {
    return AlertCard(
      type: AlertType.warning,
      title: 'Alert: ${alert.triggerType}',
      message: alert.message,
      icon: const Icon(Icons.warning_amber, color: AppColors.warning),
    );
  }
}
