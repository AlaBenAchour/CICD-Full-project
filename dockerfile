# FROM node:20-alpine
# WORKDIR /frontend/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 3000

# CMD [ "npm" ,"start" ]

# Base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy and install backend dependencies
COPY ./backend/package.json ./backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN npm install

# Copy backend source code
COPY ./backend /app/backend

# Copy and install frontend dependencies
WORKDIR /app/frontend
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install

# Copy frontend source code
COPY ./frontend /app/frontend

# Copy environment variables
WORKDIR /app/backend
COPY .env /app/backend/.env

# Build the frontend
WORKDIR /app/frontend
RUN npm run build

# Expose backend and frontend ports
EXPOSE 5000
EXPOSE 3000

# Install serve globally (if not already included in the dependencies)
RUN npm install -g serve

# Start both frontend and backend
WORKDIR /app
CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]

