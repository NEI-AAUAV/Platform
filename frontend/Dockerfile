FROM node:16-alpine as build-stage

WORKDIR /web_app

COPY ./package.json ./

COPY ./yarn.lock ./

RUN yarn install

COPY . .

RUN yarn build

FROM nginx

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /web_app/build /usr/share/nginx/html

EXPOSE 3000
