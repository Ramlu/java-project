# ------------ Stage 1: Build using Maven ------------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy the pom.xml and download dependencies (layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the application source code
COPY src ./src

# Build the Spring Boot app (jar file)
RUN mvn clean package -DskipTests

# ------------ Stage 2: Create minimal runtime image ------------
FROM eclipse-temurin:17-jre-alpine

# Create a non-root user for running the app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

WORKDIR /home/spring

# Copy the built jar file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
