const axios = require('axios');

// URL of the Python AI Service
const AI_SERVICE_URL = process.env.AI_SERVICE_URL || 'http://localhost:5000';

exports.getSuggestions = async (req, res) => {
  const { latitude, longitude } = req.query;

  if (!latitude || !longitude) {
    return res.status(400).json({ error: 'Missing latitude or longitude' });
  }

  try {
    // Call the Python AI engine
    const response = await axios.post(`${AI_SERVICE_URL}/predict`, {
      latitude: parseFloat(latitude),
      longitude: parseFloat(longitude)
    });

    res.status(200).json(response.data);
  } catch (error) {
    console.error('Error fetching suggestions from AI engine:', error.message);
    // Fallback or error response
    res.status(500).json({ error: 'Failed to get location suggestions', details: error.message });
  }
};
