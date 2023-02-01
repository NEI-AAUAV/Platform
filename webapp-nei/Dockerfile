FROM node:16-alpine

WORKDIR /webapp_nei

COPY package.json yarn.lock ./

RUN yarn install --silent

COPY . .

EXPOSE 3000
CMD yarn start
