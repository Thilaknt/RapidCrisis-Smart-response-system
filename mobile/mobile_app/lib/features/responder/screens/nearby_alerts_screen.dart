import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/responder_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/map_service.dart';

class NearbyAlertsScreen extends StatefulWidget {
  const NearbyAlertsScreen({Key? key}) : super(key: key);

  @override
  State<NearbyAlertsScreen> createState() => _NearbyAlertsScreenState();
}

class _NearbyAlertsScreenState extends State<NearbyAlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = context.read<DashboardProvider>();
      final responderProvider = context.read<ResponderProvider>();
      
      responderProvider.fetchNearbyAlerts(
        latitude: dashboardProvider.userLatitude,
        longitude: dashboardProvider.userLongitude,
        radiusKm: 10,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final role = auth.currentUser?.role.toLowerCase() ?? 'volunteer';
            if (role == 'responder' || role == 'emergency_service' || role == 'emergency') {
               return const Text('Emergency Dispatch');
             }
             return const Text('Volunteer Dispatch');
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final dashboardProvider = context.read<DashboardProvider>();
              final responderProvider = context.read<ResponderProvider>();
              
              responderProvider.fetchNearbyAlerts(
                latitude: dashboardProvider.userLatitude,
                longitude: dashboardProvider.userLongitude,
                radiusKm: 10,
              );
            },
          ),
        ],
      ),
      body: Consumer3<ResponderProvider, DashboardProvider, AuthProvider>(
        builder: (context, responderProvider, dashboardProvider, authProvider, _) {
          if (responderProvider.isLoadingAlerts) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (responderProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      responderProvider.error ?? 'Unknown error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          final role = authProvider.currentUser?.role.toLowerCase() ?? 'volunteer';
          final filteredAlerts = responderProvider.nearbyAlerts.where((alert) {
             if (role == 'volunteer') {
                 return alert.severity <= 3;
             } else if (role == 'responder' || role == 'emergency_service' || role == 'emergency') {
                 return alert.severity >= 4;
             }
             return true; // fallback for admins/users testing
          }).toList();

          if (filteredAlerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text('No nearby dispatch alerts match your role'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredAlerts.length,
            itemBuilder: (context, index) {
              final alert = filteredAlerts[index];
              final distance = responderProvider.getDistanceToAlert(
                dashboardProvider.userLatitude,
                dashboardProvider.userLongitude,
                alert,
              );

              return _buildAlertCard(
                context,
                alert,
                distance,
                responderProvider,
                dashboardProvider,
                authProvider,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    dynamic alert,
    double distance,
    ResponderProvider responderProvider,
    DashboardProvider dashboardProvider,
    AuthProvider authProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alert ${alert.triggerType.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Severity: ${alert.severity}/5',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${distance.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Message
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert.message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '📍 ${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      alert.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: alert.status == 'active'
                            ? Colors.greenAccent
                            : Colors.yellowAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final accepted = await responderProvider.acceptAlert(
                      alert: alert,
                      responderId: authProvider.currentUser?.id ?? 'responder',
                    );
                    
                    if (accepted && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Alert accepted!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calculating route via OSRM...')),
                    );
                    
                    final route = await MapService.getRouteInfo(
                      startLat: dashboardProvider.userLatitude,
                      startLng: dashboardProvider.userLongitude,
                      endLat: alert.latitude,
                      endLng: alert.longitude,
                    );
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if (route != null) {
                        final distanceKm = (route.distance / 1000).toStringAsFixed(1);
                        final durationMin = (route.duration / 60).toStringAsFixed(0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🚗 Drive: $distanceKm km, ~$durationMin mins away'),
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to calculate route.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Route',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    responderProvider.declineAlert(alert: alert);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alert declined'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
