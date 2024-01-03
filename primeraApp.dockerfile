FROM node
WORKDIR /app
COPY primeraApp ./
RUN npm install
EXPOSE 3000
CMD ["node","app.js"]