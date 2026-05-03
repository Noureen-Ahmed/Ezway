const axios = require('axios');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function test() {
  try {
    const users = await prisma.user.findMany({
      where: { role: 'PROFESSOR' }
    });
    if (users.length === 0) {
      console.log('No professors found');
      return;
    }
    const prof = users[0];

    // Read JWT_SECRET from .env
    require('dotenv').config();
    const token = jwt.sign({ userId: prof.id, email: prof.email, role: prof.role }, process.env.JWT_SECRET || 'your-secret-key');

    // 2. Create a note
    console.log('Creating note...');
    const createRes = await axios.post('http://localhost:3000/api/notes', {
      title: 'Migration Test Note',
      content: 'This is a test note'
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('Created:', createRes.data);

    // 3. Fetch notes
    console.log('Fetching notes...');
    const fetchRes = await axios.get('http://localhost:3000/api/notes', {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('Fetched:', fetchRes.data);

  } catch (err) {
    console.error('Error:', err.response ? err.response.data : err.message);
  } finally {
    await prisma.$disconnect();
  }
}
test();
