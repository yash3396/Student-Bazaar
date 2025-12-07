# Use OpenJDK 8 as base image
FROM openjdk:8-jdk-slim

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src
COPY web ./web

# Build the WAR file
RUN mvn clean package -DskipTests

# Expose port (Railway will set PORT environment variable)
EXPOSE 8080

# Use embedded Tomcat to run the WAR file
# Railway will provide PORT environment variable
CMD java -jar -Dserver.port=${PORT:-8080} target/Student_Bazar.war || \
    java -cp "target/Student_Bazar/WEB-INF/lib/*:target/classes" org.apache.catalina.startup.Bootstrap || \
    mvn jetty:run -Djetty.port=${PORT:-8080}

