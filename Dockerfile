# build ts to js
FROM node:22-slim AS builder 
 
WORKDIR /app

COPY package*.json ./

# remove husky inside docker 
RUN npm ci --ignore-scripts

COPY . .

RUN npm run build

RUN npm prune --omit-dev 
  
# as runtime files
FROM node:22-slim AS runner

WORKDIR /app
 
# install wget for wait-for-it script
# wget is used to wait for the database to be ready before starting the app
# this is necessary to ensure that the app does not start before the database is ready

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/dist ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/wait-for-it.sh /usr/local/bin/wait-for-it.sh

RUN chmod +x /usr/local/bin/wait-for-it.sh

EXPOSE 3001

RUN useradd -m appuser
USER appuser

ENTRYPOINT ["wait-for-it.sh", "blog-db:3306", "--"]
CMD ["node", "index.js"]