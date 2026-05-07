FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    python3 \
    python3-pip \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --break-system-packages pdfplumber==0.11.4

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/
RUN npm install --ignore-scripts
RUN npx prisma generate

COPY src ./src/
COPY python ./python/

ENV CHROMIUM_PATH=/usr/bin/chromium
ENV NODE_ENV=production
ENV PYTHON_BIN=python3

EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy 2>/dev/null || npx prisma db push --accept-data-loss || true && node src/index.js"]
