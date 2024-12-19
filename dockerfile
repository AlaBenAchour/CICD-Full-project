# FROM node:20-alpine
# WORKDIR /frontend/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 3000

# CMD [ "npm" ,"start" ]





FROM node:20-alpine

# Définir le répertoire de travail
WORKDIR /app

# Configuration du backend
COPY ./backend/package.json ./backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN npm install
COPY ./backend /app/backend
COPY .env /app/backend/.env

# Configuration du frontend
WORKDIR /app/frontend
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install
COPY ./frontend /app/frontend
RUN npm run build

# Installer serve globalement pour servir l'application frontend
RUN npm install -g serve

# Exposer les ports nécessaires
EXPOSE 5000  
EXPOSE 3000  

# Démarrer à la fois le frontend et le backend sur le même conteneur
WORKDIR /app
CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]
