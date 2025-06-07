FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B
COPY src src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
