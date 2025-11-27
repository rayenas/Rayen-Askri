# Utiliser l'image officielle Java 17 de Eclipse Temurin
FROM eclipse-temurin:17-jdk

# Argument : chemin du JAR généré par Maven
ARG JAR_FILE=target/*.jar

# Copier le jar dans l'image
COPY ${JAR_FILE} app.jar

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "/app.jar"]
