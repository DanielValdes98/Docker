# BUILD:
# Start with the base .NET SDK Image. Have all tools needed to build the app inside the container
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory inside the container. All following commands will be run in this directory
WORKDIR /app

# Copy the projects files and restore the dependencies 
# Copy the content of the "webApp" folder into the working directory app inside the container
COPY webApp ./ 
# NOTE: (COPY *.csproj - Si el dockerfile está dentro de la carpeta del proyecto, se usa este COPY)
# Download and install the dependencies declared in the .csproj file needed to build the application
RUN dotnet restore

# Copy the remaining files and build the application...
# Compile the application en Relase mode and generate the output files in the folder "out" inside the container
RUN dotnet publish -c Release -o out

# Build and runtime image
# Select the base image optimized for running .NET Core applications in production
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime-env

# Set the working directory inside the container. All following commands will be run in this directory
WORKDIR /app

# Copy the output files from the build-env (build stage, "out" folder) into the working directory of the runtime-env image
COPY --from=build-env /app/out .

# Set the entry point
# Indicate that container will listen on port 8080
EXPOSE 8080

# Set the command to run when the container starts. In this case, run the .NET Core application contained in the file "webApp.dll"
ENTRYPOINT ["dotnet", "webApp.dll"]

# Resume:
# The dockerfile divides th process into two stages: build (building the application ) and runtime (focused on execution).
# The working directory is set to organize files within the container.
# The application files are copied, dependencies are restored and the application is built
# A lightweight execution image is created thay contains only the files necessary to run the application
# Port 8080 is exposed to receive request an the entry point is set to start the application when the container starts