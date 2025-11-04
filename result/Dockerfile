FROM node:lts-alpine3.21
WORKDIR /user/app
COPY ./package.json ./
RUN npm install
COPY ./ ./
EXPOSE 3000
USER node
CMD ["node", "main.js"]
