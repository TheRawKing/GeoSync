from flask import Flask, request, jsonify
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
import pandas as pd

app = Flask(__name__)

# Dummy data for locations (Latitude, Longitude, Location Name)
# In a real app, this would be trained on historical check-in data
data = {
    'latitude': [28.6139, 28.5355, 19.0760, 12.9716],
    'longitude': [77.2090, 77.3910, 72.8777, 77.5946],
    'location_name': ['New Delhi Office', 'Noida Site', 'Mumbai Branch', 'Bangalore Hub']
}

df = pd.DataFrame(data)

# Features and Labels
X = df[['latitude', 'longitude']]
y = df['location_name']

# Train k-NN model
knn = KNeighborsClassifier(n_neighbors=1)
knn.fit(X, y)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        lat = data.get('latitude')
        lng = data.get('longitude')

        if lat is None or lng is None:
            return jsonify({'error': 'Missing latitude or longitude'}), 400

        # Predict the nearest location
        prediction = knn.predict([[lat, lng]])

        # Calculate distances to all known points to check if it's within a reasonable range?
        # For now, just return the nearest neighbor.

        return jsonify({
            'suggested_location': prediction[0],
            'latitude': lat,
            'longitude': lng
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
