FROM node:18-alpine

WORKDIR /web_nei

COPY package.json yarn.lock ./

RUN yarn install --silent

COPY . .

EXPOSE 3000
CMD yarn start --port 3000
