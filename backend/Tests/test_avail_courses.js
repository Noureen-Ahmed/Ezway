const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const axios = require('axios');

const prisma = new PrismaClient();

async function test() {
  const doctor = await prisma.user.findFirst({ where: { role: 'PROFESSOR' } });
  if (!doctor) return console.log('Doctor not found');
  
  const token = jwt.sign({ userId: doctor.id }, process.env.JWT_SECRET || 'college-guide-super-secret-key-change-in-production');
  
  try {
    const res = await axios.get('http://localhost:3000/api/ums/available-courses', {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log(JSON.stringify(res.data, null, 2).substring(0, 500));
  } catch (e) {
    console.log(e.response ? e.response.data : e.message);
  }
}

test();
