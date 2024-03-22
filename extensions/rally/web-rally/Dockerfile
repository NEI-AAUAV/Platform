FROM node:18-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN npm install -g pnpm

WORKDIR /web_rally

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --silent

COPY . .

EXPOSE 3003
CMD  pnpm dev --port 3003 --host
