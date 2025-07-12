# ----------- Builder Stage ------------
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make sure mvnw is executable
RUN chmod +x mvnw

# Preload dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source and build
COPY src src
RUN ./mvnw package -DskipTests && ls -lh target && cp target/*.jar app.jar

# ----------- Runtime Stage ------------
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Create non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

# Copy built jar
COPY --from=builder /app/app.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

