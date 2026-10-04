FROM node:20.19-alpine
WORKDIR /app
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm ci --no-audit --no-fund --fetch-timeout=180000 --fetch-retries=2
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "start"]
