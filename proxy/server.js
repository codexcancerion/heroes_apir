// Importing required modules
const express = require('express');
const axios = require('axios');

// Create an Express app
const app = express();
const port = 3000;

// CORS Middleware (Allow requests from all origins)
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] Incoming request: ${req.method} ${req.url}`);
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// Endpoint to fetch superhero data by ID
app.get('/api/:token/:id', async (req, res) => {
  const { token, id } = req.params;
  const url = `https://superheroapi.com/api/${token}/${id}`;

  console.log(`[${new Date().toISOString()}] Fetching superhero with ID: ${id} using token: ${token}`);

  try {
    const response = await axios.get(url);
    if (!response.data || !response.data.id) {
      console.error(`[${new Date().toISOString()}] Invalid response for ID: ${id}`);
      return res.status(404).send('Superhero not found');
    }
    console.log(`[${new Date().toISOString()}] Successfully fetched superhero with ID: ${id}`);
    res.json(response.data); // Send the superhero data back to the client
    // Add any additional logic here if needed
  } catch (error) {
    console.error(`[${new Date().toISOString()}] Error fetching superhero with ID: ${id} - ${error.message}`);
    res.status(500).send('Error fetching data from the SuperHero API');
  }
});

// Endpoint to fetch all heroes by range of IDs
app.get('/api/:token/range/:startId/:endId', async (req, res) => {
  const { token, startId, endId } = req.params;
  let heroes = [];

  console.log(`[${new Date().toISOString()}] Fetching superheroes in range: ${startId} to ${endId} using token: ${token}`);

  for (let id = parseInt(startId); id <= parseInt(endId); id++) {
    const url = `https://superheroapi.com/api/${token}/${id}`;

    try {
      const response = await axios.get(url);
      console.log(`[${new Date().toISOString()}] Successfully fetched superhero with ID: ${id}`);
      heroes.push(response.data);
    } catch (error) {
      console.error(`[${new Date().toISOString()}] Error fetching superhero with ID: ${id} - ${error.message}`);
    }
  }

  console.log(`[${new Date().toISOString()}] Successfully fetched ${heroes.length} superheroes in range: ${startId} to ${endId}`);
  res.json(heroes); // Send the array of heroes back to the client
});

// Endpoint to search for a hero by name
app.get('/api/:token/search/:name', async (req, res) => {
  const { token, name } = req.params;
  const url = `https://superheroapi.com/api/${token}/search/${name}`;

  console.log(`[${new Date().toISOString()}] Searching for superhero with name: ${name} using token: ${token}`);

  try {
    const response = await axios.get(url);
    console.log(`[${new Date().toISOString()}] Successfully fetched search results for name: ${name}`);
    res.json(response.data); // Send the search results back to the client
  } catch (error) {
    console.error(`[${new Date().toISOString()}] Error searching for superhero with name: ${name} - ${error.message}`);
    res.status(500).send('Error searching for superhero.');
  }
});

// 🔥 NEW: Image Proxy Route
app.get('/proxy-image', async (req, res) => {
  const imageUrl = req.query.url;

  if (!imageUrl) {
    return res.status(400).send('Missing "url" query parameter.');
  }

  try {
    const response = await axios.get(imageUrl, {
      responseType: 'stream',
    });

    // Set appropriate content type for the image
    res.setHeader('Content-Type', response.headers['content-type']);
    res.setHeader('Access-Control-Allow-Origin', '*'); // Allow CORS for image

    // Pipe the image stream directly to the client
    response.data.pipe(res);
  } catch (error) {
    console.error('Error proxying image:', error.message);
    res.status(500).send('Failed to fetch image.');
  }
});

// Endpoint to test if a token works
app.get('/api/:token/test', async (req, res) => {
  const { token } = req.params;
  console.log(`[${new Date().toISOString()}] Testing token: ${token}`);
  const testUrl = `https://superheroapi.com/api/${token}/1`; // Test with a known valid ID (e.g., 1)

  console.log(`[${new Date().toISOString()}] Testing token: ${token}`);

  try {
    const response = await axios.get(testUrl);

    // Check if the response contains valid data
    if (response.data && response.data.id) {
      console.log(`[${new Date().toISOString()}] Token is valid.`);
      return res.json({ success: true, message: 'Token is valid.' });
    } else {
      console.error(`[${new Date().toISOString()}] Token is invalid.`);
      return res.status(400).json({ success: false, message: 'Token is invalid or does not work.' });
    }
  } catch (error) {
    console.error(`[${new Date().toISOString()}] Error testing token: ${error.message}`);
    return res.status(500).json({ success: false, message: 'Error testing token.', error: error.message });
  }
});

// Endpoint to test if a token works
app.get('/api/test', async (req, res) => {
  const { token } = req.query; // Use query parameter for the token
  const testUrl = `https://superheroapi.com/api/${token}/1`; // Test with a known valid ID (e.g., 1)

  console.log(`[${new Date().toISOString()}] Testing token: ${token}`);

  if (!token) {
    return res.status(400).json({ success: false, message: 'Missing token query parameter.' });
  }

  try {
    const response = await axios.get(testUrl);

    // Check if the response contains valid data
    if (response.data && response.data.id) {
      console.log(`[${new Date().toISOString()}] Token is valid.`);
      return res.json({ success: true, message: 'Token is valid.' });
    } else {
      console.error(`[${new Date().toISOString()}] Token is invalid.`);
      return res.status(400).json({ success: false, message: 'Token is invalid or does not work.' });
    }
  } catch (error) {
    console.error(`[${new Date().toISOString()}] Error testing token: ${error.message}`);
    return res.status(500).json({ success: false, message: 'Error testing token.', error: error.message });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`[${new Date().toISOString()}] Proxy server is running on http://localhost:${port}`);
});
