FROM node:18-alpine

WORKDIR /web_gala

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

EXPOSE 3002
CMD yarn dev --port 3002 --host
