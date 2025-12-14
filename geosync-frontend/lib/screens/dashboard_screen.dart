import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/geofence_service.dart';
import '../widgets/pulsing_marker.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  final GeofenceService _geofenceService = GeofenceService();

  String _currentLocationName = "Locating...";
  bool _isActionLoading = false;
  bool _isCheckedIn = false;

  // Dummy History Data
  final List<Map<String, String>> _history = [
    {"type": "Check Out", "time": "Yesterday, 18:00", "loc": "New Delhi Office"},
    {"type": "Check In", "time": "Yesterday, 09:30", "loc": "New Delhi Office"},
    {"type": "Check Out", "time": "12 Dec, 17:45", "loc": "Remote"},
  ];

  @override
  void initState() {
    super.initState();
    _refreshLocation();
  }

  Future<void> _refreshLocation() async {
    setState(() => _currentLocationName = "Locating...");
    try {
      final position = await _geofenceService.getCurrentPosition();

      // Get AI suggestion
      final suggestion = await _apiService.getLocationSuggestion(
        position.latitude,
        position.longitude
      );

      setState(() {
        if (suggestion != null) {
          _currentLocationName = suggestion['suggested_location'] ?? "Unknown Area";
        } else {
          _currentLocationName = "${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}";
        }
      });

    } catch (e) {
      setState(() => _currentLocationName = "Location Error");
    }
  }

  Future<void> _handleAttendanceAction() async {
    setState(() => _isActionLoading = true);

    // Simulate API call delay + fun factor
    await Future.delayed(const Duration(seconds: 1));

    try {
      bool success;
      if (_isCheckedIn) {
        success = await _apiService.checkOut("user123", _currentLocationName);
      } else {
        success = await _apiService.checkIn("user123", _currentLocationName);
      }

      if (success) {
        // Add to history
        setState(() {
          _history.insert(0, {
            "type": _isCheckedIn ? "Check Out" : "Check In",
            "time": DateFormat('HH:mm').format(DateTime.now()),
            "loc": _currentLocationName,
          });
          _isCheckedIn = !_isCheckedIn;
        });

        _showSuccessDialog(_isCheckedIn);
      }
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  void _showSuccessDialog(bool checkedIn) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                checkedIn ? "You're In!" : "See you later!",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Attendance logged at $_currentLocationName",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Awesome"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, User",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            _currentLocationName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Area
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PulsingLocationMarker(
                    onTap: _handleAttendanceAction,
                    isCheckingIn: _isActionLoading,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _isCheckedIn ? "Tap to Check Out" : "Tap to Check In",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  StatCard(
                    title: "Present",
                    value: "22",
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  StatCard(
                    title: "Avg Hours",
                    value: "8.5",
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Activity",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          final isCheckIn = item['type'] == 'Check In';
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCheckIn
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCheckIn ? Icons.login : Icons.logout,
                                color: isCheckIn ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            title: Text(item['type']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(item['loc']!),
                            trailing: Text(
                              item['time']!,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
