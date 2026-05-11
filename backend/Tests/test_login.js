const axios = require('axios');

async function test() {
  try {
    const res = await axios.post('http://localhost:3000/api/ums/login', {
      loginName: '30410030100903',
      password: 'wrong_password' // just to see if it reaches UMS
    });
    console.log('Success:', res.data);
  } catch (err) {
    console.error('Error:', err.response?.data || err.message);
  }
}

test();
