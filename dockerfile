FROM node:20 AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build

FROM node:20 AS production

WORKDIR /app

COPY --from=builder /app/package.json /app/yarn.lock ./
COPY --from=builder /app/.next ./.next

RUN yarn install --production --frozen-lockfile

ENV NODE_ENV=production

EXPOSE 3000

CMD ["yarn", "start"]