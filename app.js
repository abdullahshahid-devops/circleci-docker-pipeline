const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.json({
        message: 'CircleCI Docker Pipeline',
        version: '1.0.0'
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy'
    });
});

module.exports = app;
