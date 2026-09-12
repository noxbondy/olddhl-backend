# ---- Build stage ----
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app

# Copy Maven wrapper and pom.xml first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make Maven wrapper executable
RUN chmod +x mvnw

# Copy source code
COPY src ./src

# Build the project
RUN ./mvnw clean package -DskipTests

# ---- Run stage ----
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy the JAR created by Maven
COPY --from=build /app/target/olddhl-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["sh", "-c", "java -Dserver.port=$PORT -jar app.jar"]
