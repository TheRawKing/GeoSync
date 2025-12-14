// Placeholder for Geolocator since we cannot run it in the sandbox
// In a real app, this would use the 'geolocator' package

class Position {
  final double latitude;
  final double longitude;

  Position({required this.latitude, required this.longitude});
}

class GeofenceService {
  Future<Position> getCurrentPosition() async {
    // Simulating a delay
    await Future.delayed(const Duration(seconds: 1));

    // Return a mock position (New Delhi Office coordinates from AI dummy data)
    return Position(latitude: 28.6139, longitude: 77.2090);
  }

  bool isWithinGeofence(Position userPosition, Position center, double radiusInMeters) {
    // Basic distance calculation placeholder
    // In real app, use Geolocator.distanceBetween()
    return true;
  }
}
