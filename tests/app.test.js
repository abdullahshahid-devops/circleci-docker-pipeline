const request = require('supertest');
const app = require('../app');

describe('Application endpoints', () => {
    test('GET / returns application metadata', async () => {
        const response = await request(app).get('/');

        expect(response.statusCode).toBe(200);
        expect(response.body.version).toBe('1.0.0');
    });

    test('GET /health returns healthy status', async () => {
        const response = await request(app).get('/health');

        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({ status: 'healthy' });
    });
});
