# Utiliser l'image officielle OpenJDK 17
FROM openjdk:17-jdk-slim

# Argument : chemin du JAR généré par Maven
ARG JAR_FILE=target/*.jar

# Copier le jar dans l'image
COPY ${JAR_FILE} app.jar

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "/app.jar"]
