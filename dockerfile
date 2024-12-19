# FROM node:20-alpine
# WORKDIR /frontend/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 3000

# CMD [ "npm" ,"start" ]

# Base image
# Use Node.js base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Backend setup
COPY ./backend/package.json ./backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN npm install
COPY ./backend /app/backend
COPY .env /app/backend/.env

# Frontend setup
WORKDIR /app/frontend
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install
COPY ./frontend /app/frontend
RUN npm run build

# Expose backend and frontend ports
EXPOSE 5000
EXPOSE 3000

# Install serve globally
RUN npm install -g serve

# Start both frontend and backend
WORKDIR /app
CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]


