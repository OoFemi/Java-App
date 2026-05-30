# --- Stage 1: Build Environment ---
FROM gradle:8.7-jdk21-alpine AS builder
WORKDIR /home/gradle/project

# Copy project files with proper Gradle permissions
COPY --chown=gradle:gradle . .

# Compile code and generate the production JAR file
RUN gradle build -x test --no-daemon

# --- Stage 2: Optimized Production Runtime ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Safely copy the compiled jar file out of the builder workspace
COPY --from=builder /home/gradle/project/build/libs/my-app-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
