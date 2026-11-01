FROM node:18-alpine AS test

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm test

FROM node:18-alpine AS production

WORKDIR /app

# Force production build to depend on successful test stage
COPY --from=test /app/package-lock.json /tmp/package-lock.json
RUN rm /tmp/package-lock.json

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY app.js server.js ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://127.0.0.1:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["node", "server.js"]
