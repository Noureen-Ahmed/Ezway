const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const axios = require('axios');
const fs = require('fs');

const prisma = new PrismaClient();

async function test() {
  const doctor = await prisma.user.findUnique({ where: { email: 'doctor@college.edu' } });
  if (!doctor) return console.log('Doctor not found');
  
  const token = jwt.sign({ userId: doctor.id }, process.env.JWT_SECRET || 'college-guide-super-secret-key-change-in-production');
  
  try {
    const res = await axios.get('http://localhost:3000/api/courses/professor/doctor@college.edu', {
      headers: { Authorization: `Bearer ${token}` }
    });
    fs.writeFileSync('test_out.json', JSON.stringify(res.data, null, 2), 'utf8');
    console.log('Saved');
  } catch (e) {
    console.log(e.response ? e.response.data : e.message);
  }
}

test();
