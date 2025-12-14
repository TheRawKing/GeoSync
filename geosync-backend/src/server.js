const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
const attendanceRoutes = require('./routes/attendance');
const locationRoutes = require('./routes/location');

app.use('/api/attendance', attendanceRoutes);
app.use('/api/location', locationRoutes);

// Health check
app.get('/', (req, res) => {
  res.send('GeoSync Backend is running');
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
