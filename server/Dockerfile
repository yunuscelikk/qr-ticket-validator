FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install sequelize-cli

COPY . .

CMD ["npm", "start"]
