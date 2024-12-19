# FROM node:20-alpine
# WORKDIR /frontend/src/app

# COPY ./package.json ./
# COPY ./package-lock.json ./

# RUN npm install

# COPY . .

# EXPOSE 3000

# CMD [ "npm" ,"start" ]



# FROM node:20-alpine AS backend-build

# # Définir le répertoire de travail pour le backend
# WORKDIR /app/backend

# # Copier les fichiers package.json et package-lock.json pour installer les dépendances
# COPY ./backend/package.json ./backend/package-lock.json ./
# RUN npm install

# # Copier le reste des fichiers du backend
# COPY ./backend /app/backend

# # Étape 2 : Construction du frontend
# FROM node:20-alpine AS frontend-build

# # Définir le répertoire de travail pour le frontend
# WORKDIR /app/frontend

# # Copier les fichiers package.json et package-lock.json pour installer les dépendances
# COPY ./frontend/package.json ./frontend/package-lock.json ./
# RUN npm install

# # Copier le reste des fichiers du frontend
# COPY ./frontend /app/frontend

# # Construire l'application React
# RUN npm run build

# # Étape 3 : Image finale pour exécuter le backend et frontend
# FROM node:20-alpine

# # Définir le répertoire de travail
# WORKDIR /app

# # Copier les fichiers du backend depuis l'étape de construction backend-build
# COPY --from=backend-build /app/backend /app/backend

# # Copier les fichiers du frontend depuis l'étape de construction frontend-build
# COPY --from=frontend-build /app/frontend/build /app/frontend/build

# # Installer 'serve' pour servir l'application frontend
# RUN npm install -g serve

# # Exposer les ports nécessaires pour le backend et le frontend
# EXPOSE 5000
# EXPOSE 3000

# # Copier le fichier .env pour le backend
# COPY .env /app/backend/.env

# # Démarrer à la fois le frontend et le backend dans un seul conteneur
# CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]
# Step 1: Build the backend
FROM node:20-alpine AS backend-build

WORKDIR /app/backend
COPY ./backend/package.json ./backend/package-lock.json ./
RUN npm install
COPY ./backend /app/backend

# Step 2: Build the frontend
FROM node:20-alpine AS frontend-build

WORKDIR /app/frontend
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install
COPY ./frontend /app/frontend
RUN npm run build

# Step 3: Final image
FROM node:20-alpine

WORKDIR /app
COPY --from=backend-build /app/backend /app/backend
COPY --from=frontend-build /app/frontend/build /app/frontend/build
RUN npm install -g serve

# Expose ports
EXPOSE 5000
EXPOSE 3000

# Copy .env file for backend
COPY .env /app/backend/.env

# Add a script to wait for the backend to be ready before starting the frontend
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Start the backend and frontend
CMD ["sh", "-c", "/wait-for-it.sh localhost:5000 -- npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]
