const axios = require('axios');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';
const token = jwt.sign({ id: 'cmn7hsijq000x69k2vrhzc1v9', email: 'doctor@college.edu', role: 'professor' }, JWT_SECRET);

async function test() {
  try {
    console.log('Sending request to http://localhost:3000/api/notes');
    const res = await axios.post('http://localhost:3000/api/notes', {
      title: 'Test Note',
      content: 'Hello World'
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    console.log('Success:', res.data);
  } catch (err) {
    console.error('Error:', err.response ? err.response.data : err.message);
  }
}
test();
