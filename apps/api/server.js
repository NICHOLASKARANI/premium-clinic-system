const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 4000;

// Enable CORS for frontend
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'API is running!',
    timestamp: new Date().toISOString()
  });
});

// Simple GraphQL-like endpoint
app.post('/graphql', (req, res) => {
  const { query } = req.body;
  
  if (query && query.includes('health')) {
    res.json({
      data: {
        health: 'API is running!'
      }
    });
  } else {
    res.json({
      data: {
        message: 'Welcome to Clinic Management API'
      }
    });
  }
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    name: 'Premium Clinic Management System API',
    version: '1.0.0',
    status: 'operational',
    endpoints: {
      health: '/health',
      graphql: '/graphql (POST)'
    }
  });
});

app.listen(port, () => {
  console.log(Backend running on port );
  console.log(Health check: http://localhost:/health);
  console.log(GraphQL endpoint: http://localhost:/graphql);
});
