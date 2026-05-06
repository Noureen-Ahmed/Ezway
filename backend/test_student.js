const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const axios = require('axios');

const prisma = new PrismaClient();

async function test() {
  const email = '30409260104446@sci.asu.edu.eg';
  const user = await prisma.user.findUnique({ where: { email } });
  if (!user) return console.log('User not found in DB');
  
  const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET || 'college-guide-super-secret-key-change-in-production');
  
  try {
    const res = await axios.get(`http://localhost:3000/api/users/${encodeURIComponent(email)}/enrollments`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log(JSON.stringify(res.data, null, 2).substring(0, 500));
  } catch (e) {
    console.log('Error:');
    console.log(e.response ? e.response.data : e.message);
  }
}

test();
