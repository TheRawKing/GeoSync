import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/geofence_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  final GeofenceService _geofenceService = GeofenceService();

  String _status = "Not Checked In";
  String _currentLocation = "Unknown";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await _geofenceService.getCurrentPosition();
      setState(() {
        _currentLocation = "${position.latitude}, ${position.longitude}";
      });

      // Get suggestion from AI
      final suggestion = await _apiService.getLocationSuggestion(
        position.latitude,
        position.longitude
      );

      if (suggestion != null) {
        setState(() {
          _currentLocation += "\n(${suggestion['suggested_location']})";
        });
      }

    } catch (e) {
      setState(() {
        _currentLocation = "Error getting location: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCheckIn() async {
    setState(() => _isLoading = true);
    try {
      final success = await _apiService.checkIn("user123", _currentLocation);
      if (success) {
        setState(() => _status = "Checked In");
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check-in Successful')));
        }
      }
    } catch (e) {
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCheckOut() async {
    setState(() => _isLoading = true);
    try {
      final success = await _apiService.checkOut("user123", _currentLocation);
      if (success) {
        setState(() => _status = "Checked Out");
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check-out Successful')));
        }
      }
    } catch (e) {
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: _isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Status: $_status', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Text('Location: $_currentLocation', textAlign: TextAlign.center),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _handleCheckIn,
                  child: const Text('Check In'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleCheckOut,
                  child: const Text('Check Out'),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _getCurrentLocation,
                  child: const Text('Refresh Location'),
                ),
              ],
            ),
      ),
    );
  }
}
