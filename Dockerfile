# ---- Étape 1: Build ----
# Utiliser une image Node.js pour construire l'application React
FROM node:18-alpine AS build

WORKDIR /app

# Copier package.json et installer les dépendances
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copier le reste des fichiers sources
COPY . ./

# Construire l'application pour la production
RUN npm run build

# ---- Étape 2: Serve ----
# Utiliser une image Nginx légère pour servir les fichiers statiques
FROM nginx:stable-alpine

# Copier les fichiers construits de l'étape de build vers le dossier web de Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Supprimer la configuration par défaut de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copier notre propre configuration Nginx
# Nous créerons ce fichier juste après
COPY nginx.conf /etc/nginx/conf.d/

# Exposer le port 80
EXPOSE 80

# La commande par défaut de Nginx se chargera de démarrer le serveur
CMD ["nginx", "-g", "daemon off;"]