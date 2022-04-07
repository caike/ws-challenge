FROM node:14.19.1-alpine3.15

WORKDIR /app
COPY yarn.lock ./
COPY ./ ./
COPY package.docker.json ./package.json
RUN yarn install
CMD ["npm", "run", "start"]
