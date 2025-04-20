# Utiliser une image Ubuntu
FROM ubuntu:20.04

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa

# Installer Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$PATH"

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet
COPY . .

# Installer les dépendances Flutter
RUN flutter pub get

# Construire l'application Flutter pour le web
RUN flutter build web

# Utiliser un serveur web pour servir l'application
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]