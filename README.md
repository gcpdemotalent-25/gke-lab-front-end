# Projet Frontend React - Lab de déploiement sur GKE

Ce projet est l'interface utilisateur de notre application de laboratoire. C'est une application React simple (`create-react-app`) qui appelle le service backend pour afficher un message. Elle est conçue pour être servie par un serveur Nginx, le tout empaqueté dans une image Docker prête pour GKE.

## Prérequis

*   Node.js 18+
*   npm (généralement inclus avec Node.js)
*   Docker Desktop (pour les tests d'image en local)

## Lancement en local

Pour développer et tester l'interface sur votre machine locale :

1.  **Installez les dépendances** :
    ```bash
    npm install
    ```

2.  **Lancez le serveur de développement** :
    > **Important** : Assurez-vous que le service backend est en cours d'exécution sur `http://localhost:8080` avant de lancer le frontend.
    ```bash
    npm start
    ```
    Votre navigateur devrait s'ouvrir automatiquement sur `http://localhost:3000`.

3.  **Proxy de développement** :
    Le fichier `package.json` contient la ligne `"proxy": "http://localhost:8080"`. Cela indique au serveur de développement de React de rediriger toutes les requêtes API inconnues (comme `/api/hello`) vers notre backend local. Cela évite les problèmes de CORS pendant le développement.

## Dockerisation et le rôle de Nginx

Notre `Dockerfile` utilise une approche de **"multi-stage build"**, une pratique recommandée pour les applications frontend :
1.  **Étape `build`** : Une image Node.js est utilisée pour installer les dépendances et exécuter `npm run build`, ce qui génère les fichiers statiques (HTML, CSS, JS) optimisés pour la production.
2.  **Étape `serve`** : Une image Nginx très légère est utilisée. Les fichiers statiques de l'étape précédente y sont copiés.

Le fichier `nginx.conf` est crucial. Il configure Nginx pour :
*   **Servir les fichiers React** : Toutes les requêtes standards (`/`, `/static`, etc.) servent les fichiers de l'application.
*   **Agir comme un proxy inverse** : Toute requête dont l'URL commence par `/api` est redirigée vers le service backend de Kubernetes (`proxy_pass http://backend-service:8080;`). C'est ainsi que le frontend et le backend communiquent en production, sans aucun problème de CORS.

Pour construire l'image :
```bash
# Assurez-vous que la variable d'environnement PROJECT_ID est définie
# export PROJECT_ID=$(gcloud config get-value project)
docker build -t europe-west1-docker.pkg.dev/${PROJECT_ID}/gke-lab-repo/frontend:v1 .