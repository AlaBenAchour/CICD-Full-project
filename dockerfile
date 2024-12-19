# FROM node:20-alpine
# WORKDIR /frontend/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 3000

# CMD [ "npm" ,"start" ]

FROM node:20-alpine

# Définir les répertoires de travail pour le frontend et le backend
WORKDIR /app

# Copier et installer les dépendances du backend
COPY ./backend/package.json ./backend/package-lock.json ./backend/
WORKDIR /app/backend
RUN npm install

# Copier le code source du backend
COPY ./backend /app/backend

# Copier et installer les dépendances du frontend
WORKDIR /app/frontend
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install

# Copier le code source du frontend
COPY ./frontend /app/frontend

# Copier le fichier .env contenant les variables d'environnement
COPY .env /app/backend/.env


# Exposer les ports pour le frontend (3000) et le backend (5000)
EXPOSE 3000 5000

# Construire le frontend
WORKDIR /app/frontend
RUN npm run build

# Définir le script d'entrée qui va démarrer le frontend et le backend
CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]

