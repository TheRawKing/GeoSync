// Mock Database Store (In-memory)
// In a real application, this would use Firebase Admin SDK
const attendanceRecords = [];

exports.checkIn = (req, res) => {
  const { userId, location, timestamp } = req.body;

  // Validation (basic)
  if (!userId || !location) {
    return res.status(400).json({ error: 'Missing userId or location' });
  }

  const record = {
    id: attendanceRecords.length + 1,
    userId,
    type: 'CHECK_IN',
    location,
    timestamp: timestamp || new Date().toISOString(),
    synced: true // Simulating immediate sync
  };

  attendanceRecords.push(record);
  console.log('Check-in recorded:', record);

  res.status(200).json({ message: 'Check-in successful', record });
};

exports.checkOut = (req, res) => {
  const { userId, location, timestamp } = req.body;

  if (!userId || !location) {
    return res.status(400).json({ error: 'Missing userId or location' });
  }

  const record = {
    id: attendanceRecords.length + 1,
    userId,
    type: 'CHECK_OUT',
    location,
    timestamp: timestamp || new Date().toISOString(),
    synced: true
  };

  attendanceRecords.push(record);
  console.log('Check-out recorded:', record);

  res.status(200).json({ message: 'Check-out successful', record });
};
