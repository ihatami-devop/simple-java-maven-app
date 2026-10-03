# Stage 1: Build stage using Maven and OpenJDK 21
FROM maven:3.9-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the JAR using the dynamic revision argument set to 0 for fallback value
ARG REVISION=0
RUN mvn clean package -Drevision=${REVISION} -DskipTests

# Stage 2: Lightweight runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port (if applicable) and define entrypoint
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
