import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for Android emulator (10.0.2.2) or local IP for real device
  // Since we are in a sandbox environment, we'll assume standard localhost
  // but for a real Flutter app this needs adjustment.
  static const String baseUrl = 'http://localhost:3000/api';

  Future<bool> checkIn(String userId, String location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance/checkin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'location': location,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Check-in error: $e');
      return false;
    }
  }

  Future<bool> checkOut(String userId, String location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'location': location,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Check-out error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getLocationSuggestion(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/location/suggestions?latitude=$lat&longitude=$lng'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Location suggestion error: $e');
      return null;
    }
  }
}
