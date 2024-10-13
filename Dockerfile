# Use the official Tomcat base image
FROM tomcat:latest

# Maintainer information
LABEL maintainer="Nivisha"

# Set the working directory
WORKDIR /usr/local/tomcat/webapps/

# Copy the WAR file into the Tomcat webapps directory
COPY target/LoginWebApp.war LoginWebApp.war  # Adjusted for final WAR name

# Expose the Tomcat port
EXPOSE 8080

# Command to run Tomcat
CMD ["catalina.sh", "run"]
