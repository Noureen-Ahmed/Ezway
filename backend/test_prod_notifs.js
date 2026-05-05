const axios = require('axios');
const { PrismaClient } = require('@prisma/client');

(async () => {
  const p = new PrismaClient();
  const user = await p.user.findUnique({where: {id: 'cmoou7270000o4boa1vfw2mo8'}});
  
  if (!user) {
    console.log('User not found in DB');
    return;
  }
  
  console.log(`Found user: ${user.email}`);

  const jwt = require('jsonwebtoken');
  const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET || 'college-guide-super-secret-key-change-in-production');
  
  console.log(`Testing production API with token...`);
  try {
    const res = await axios.get('https://ezway-production.up.railway.app/api/notifications', {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('Production Notifications API Response:');
    console.log(JSON.stringify(res.data, null, 2));
  } catch (e) {
    console.error('Error hitting production API:', e.response?.data || e.message);
  }
  
  try {
    const res2 = await axios.get('http://127.0.0.1:3000/api/notifications', {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('Local Notifications API Response:');
    console.log(JSON.stringify(res2.data, null, 2));
  } catch (e) {
    console.error('Error hitting local API:', e.response?.data || e.message);
  }

  await p.$disconnect();
})();
