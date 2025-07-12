# ----------- Builder Stage ------------
FROM maven:3.8.4-openjdk-17-slim AS builder

# Set the working directory in the container
WORKDIR /app

# Copy pom.xml and mvnw (Maven wrapper) to leverage Docker cache
COPY mvnw . 
COPY .mvn .mvn
COPY pom.xml . 

# Make sure mvnw is executable (if you're using it)
RUN chmod +x mvnw

# Download dependencies and pre-build (go offline)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Build the application and package it
RUN ./mvnw package -DskipTests

# ----------- Runtime Stage (Distroless) ------------
FROM gcr.io/distroless/java17

# Set the working directory for the runtime image
WORKDIR /app

# Create non-root user for security
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port 8080 for the application
EXPOSE 8080

# Start the application using the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]

