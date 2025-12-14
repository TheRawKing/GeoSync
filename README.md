# GeoSync Attendance Companion

GeoSync is an innovative mobile application designed to revolutionize attendance management for distributed workforces. It replaces outdated manual and biometric systems with an intelligent, location-based solution using geofencing and AI.

## Project Structure

*   **`geosync-frontend`**: Flutter mobile application.
*   **`geosync-backend`**: Node.js/Express REST API.
*   **`geosync-ai`**: Python Flask service for AI/ML operations (Location Suggestions).

## Prerequisites

*   Node.js (v14 or higher)
*   Python (3.8 or higher)
*   Flutter SDK (for mobile app development)

## Setup & Running

### 1. AI Engine (Python)

Navigate to the `geosync-ai` directory:

```bash
cd geosync-ai
```

Create a virtual environment and install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

Start the Flask server:

```bash
python app.py
```
The AI service will run on `http://localhost:5000`.

### 2. Backend (Node.js)

Navigate to the `geosync-backend` directory:

```bash
cd geosync-backend
```

Install dependencies:

```bash
npm install
```

Start the server:

```bash
npm start
```
The Backend API will run on `http://localhost:3000`.

### 3. Frontend (Flutter)

Navigate to the `geosync-frontend` directory:

```bash
cd geosync-frontend
```

Get dependencies:

```bash
flutter pub get
```

Run the app (ensure you have an emulator running or device connected):

```bash
flutter run
```

## API Endpoints

### Backend

*   `POST /api/attendance/checkin`: Check in a user.
    *   Body: `{ "userId": "string", "location": "string" }`
*   `POST /api/attendance/checkout`: Check out a user.
    *   Body: `{ "userId": "string", "location": "string" }`
*   `GET /api/location/suggestions`: Get location suggestions based on coordinates.
    *   Query Params: `latitude`, `longitude`

## Features Implemented

*   **Geofencing Mock**: The frontend has a service structure ready for Geolocator integration.
*   **AI Suggestions**: A k-NN model runs in Python to suggest "New Delhi Office", "Noida Site", etc., based on coordinates.
*   **Attendance Logging**: Node.js backend logs check-ins/outs (currently to memory).
