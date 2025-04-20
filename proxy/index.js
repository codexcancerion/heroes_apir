// Importing required modules
const express = require('express');
const axios = require('axios');

// Create an Express app
const app = express();
const port = 3000;

// SuperHero API credentials
const baseUrl = 'https://superheroapi.com/api/eae25af25d8ef0fbf045fd97217bd209/';

// CORS Middleware (Allow requests from all origins)
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] Incoming request: ${req.method} ${req.url}`);
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// Endpoint to fetch superhero data by ID
app.get('/api/:id', async (req, res) => {
  const heroId = req.params.id;
  const url = `${baseUrl}${heroId}`;

  console.log(`[${new Date().toISOString()}] Fetching superhero with ID: ${heroId}`);

  try {
    const response = await axios.get(url);
    console.log(`[${new Date().toISOString()}] Successfully fetched superhero with ID: ${heroId}`);
    res.json(response.data); // Send the data back to the client
  } catch (error) {
    console.error(`[${new Date().toISOString()}] Error fetching superhero with ID: ${heroId} - ${error.message}`);
    res.status(500).send('Error fetching data from the SuperHero API');
  }
});

// Endpoint to fetch all heroes by range of IDs
app.get('/api/range/:startId/:endId', async (req, res) => {
  const { startId, endId } = req.params;
  let heroes = [];

  console.log(`[${new Date().toISOString()}] Fetching superheroes in range: ${startId} to ${endId}`);

  for (let id = parseInt(startId); id <= parseInt(endId); id++) {
    const url = `${baseUrl}${id}`;

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

// Start the server
app.listen(port, () => {
  console.log(`[${new Date().toISOString()}] Proxy server is running on http://localhost:${port}`);
});
