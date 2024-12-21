# Étape 1 : Construction du backend
FROM node:20-alpine AS backend-build

# Définir le répertoire de travail pour le backend
WORKDIR /app/backend

# Copier package.json et package-lock.json pour installer les dépendances
COPY ./backend/package.json ./backend/package-lock.json ./
RUN npm install

# Copier le reste des fichiers du backend
COPY ./backend ./

# Étape 2 : Construction du frontend
FROM node:20-alpine AS frontend-build

# Définir le répertoire de travail pour le frontend
WORKDIR /app/frontend

# Copier package.json et package-lock.json pour installer les dépendances
COPY ./frontend/package.json ./frontend/package-lock.json ./
RUN npm install

# Copier le reste des fichiers du frontend
COPY ./frontend ./

# Construire l'application React
RUN npm run build

# Étape 3 : Image finale
FROM node:20-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier le backend depuis l'étape de construction backend-build
COPY --from=backend-build /app/backend /app/backend

# Copier le frontend construit depuis l'étape de construction frontend-build
COPY --from=frontend-build /app/frontend/build /app/frontend/build

# Installer 'serve' pour servir le frontend
RUN npm install -g serve

# Copier les variables d'environnement pour le backend
COPY .env /app/backend/.env

# Exposer les ports pour le backend et le frontend
EXPOSE 5000
EXPOSE 3000

# Démarrer le backend et le frontend
CMD ["sh", "-c", "npm start --prefix /app/backend & serve -s /app/frontend/build -l 3000"]
