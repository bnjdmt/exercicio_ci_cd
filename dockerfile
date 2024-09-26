# Multi-staging
# Build de l'application avec maven
# Utilisation de l'image Maven officielle comme image de base pour la phase de construction
FROM maven:3.8.1-openjdk-17 AS builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier pom.xml dans le répertoire de travail
# Cela permet de télécharger les dépendances
COPY pom.xml .

# Télécharger les dépendances nécessaires à la compilation en mode hors-ligne
RUN mvn dependency:go-offline

# Copier les fichier sources de l'application dans notre espace de travail
COPY src ./src

# Compiler le projet, en omettant les tests pour accélérer le processus de build
RUN mvn package -DskipTests

# Utilisation d'une image de base contenant OpenJDK pour l'exécution de l'application
FROM openjdk

# Copier le fichier JAR construit dans la phase précédente depuis l'image "builder"
COPY --from=builder /app/target/spring_demo_base-0.0.1-SNAPSHOT.jar .

# Exposer le port 8080 pour permettre l'accès à l'application
EXPOSE 8083

# Définit le point d'entrée du conteneur pour exécuter l'application Java
# L'application sera lancée avec la commande "java -jar 01_spring_demo_base-0.0.1-SNAPSHOT.jar"
ENTRYPOINT ["java", "-jar", "spring_demo_base-0.0.1-SNAPSHOT.jar"]

# Construire l'image 
# docker build -t demorest .