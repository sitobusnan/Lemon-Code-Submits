# 01 - CONTENEDORES

## Ejercicio 1 - Dockerización

Creación de la red '**lemoncode-challenge**'

```
docker network create lemoncode-challenge    
````
### Mongo DB

Creación y despliegue de un contenedor con Mongo DB:
- se nombra como '**lemonmongo**'
- Autenticación user/password
- un volumen para persistencia llamado '**lemonmongovol**'
- se añade a la red '**lemoncode-challenge**'
- expone el puerto 27017 para pruebas

```
docker run 
-d --name lemon-mongo 
-v lemonmongovol:/data/db 
-e MONGO_INITDB_ROOT_USERNAME=lemon 
-e MONGO_INITDB_ROOT_PASSWORD=lemon 
--network lemoncode-challenge 
-p 27017:27017 
mongo 
````

### Backend ( Versión .NET )

Modificaciones respecto al repositorio original del Challenge:
- en el archivo '_backend.csproj_' se modifica el driver de Mongo debido a problemas de compilación.

>     <PackageReference Include="MongoDB.Driver" Version="2.10.1" />

- en el archivo '_appsettings.json_' se modifica la cadena de conexión a mongo para añadir la autentición (no lo parametrizo por cuestión de tiempo, nunca lo he hecho en .NET )
>     "ConnectionString": "mongodb://lemon:lemon@lemon-mongo:27017/?authMechanism=SCRAM-SHA-1",

Se crea el Dockerfile
````
FROM mcr.microsoft.com/dotnet/aspnet:3.1-focal AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:3.1-focal AS build
WORKDIR /src
COPY ["./backend.csproj", "./"]
RUN dotnet restore "./backend.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "backend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "backend.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "backend.dll"]
````

Desde la ruta '/backend' podemos construir su imagen y la nombramos '**backendlemon**':
````
docker build -t backendlemon:latest . 
````
Creación y despliegue de un contenedor con el proyecto Backend:
- se nombra como '**netbackend**'
- se añade a la red '**lemoncode-challenge**'
- mapea el puerto 5001 al 5000 del contenedor para pruebas ( algunos servicios de macOS usan el puerto 5000 )

````
docker run -d 
--name netbackend 
--network lemoncode-challenge 
-p 5001:5000 
backendlemon   
````

### FrontEnd 

Modificaciones respecto al repositorio original del Challenge:
- sin modificaciones.

Se crea el Dockerfile:
- Como parametro se pasa la url del backend expuesto en el puerto 5000
````
FROM node:lts-alpine
ENV NODE_ENV=production
ENV API_URI='http://netbackend:5000/api/topics'
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 3000
RUN chown -R node /usr/src/app
USER node
CMD ["node", "server.js"]
````

Desde la ruta '/frontend' podemos construir su imagen y la nombramos '**frontendlemon**':
````
docker build -t frontendlemon:latest . 
````

Creación y despliegue de un contenedor con el proyecto Frontend:
- se nombra como '**nodefrontend**'
- se añade a la red '**lemoncode-challenge**'
- mapea el puerto 3000 al 3000 del contenedor para que sea accesible 

````
docker run -d 
--name nodefrontend 
--network lemoncode-challenge 
-p 3000:3000 
frontendlemon
````

Desde la URL [http://localhost:3000](http://localhost:3000) ya será accesible y visible la lista de elementos.




