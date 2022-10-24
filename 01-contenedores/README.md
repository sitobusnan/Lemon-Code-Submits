# 01 - CONTENEDORES

## Ejercicio 1 - Dockerización

Creación de la red '**lemoncode-challenge**'

```bash
docker network create lemoncode-challenge    
```
### Mongo DB

Creación y despliegue de un contenedor con Mongo DB:
- se nombra como '**lemonmongo**'
- Autenticación user/password
- un volumen para persistencia llamado '**lemonmongovol**'
- se añade a la red '**lemoncode-challenge**'
- expone el puerto 27017 para pruebas

```
docker run -d --name lemon-mongo -v lemonmongovol:/data/db -e MONGO_INITDB_ROOT_USERNAME=lemon -e MONGO_INITDB_ROOT_PASSWORD=lemon --network lemoncode-challenge -p 27017:27017 mongo 
```

Iniciliza una BBDD llamada '**TopicstoreDb**' y una colección denominada '**Topics**' con un par de documentos desde el archivo `backend/seeds.json`:

![](./images/mongo.png)

### Backend ( Versión .NET )

Modificaciones respecto al repositorio original del Challenge:
- en el archivo `backend/backend.csproj` se modifica el driver de Mongo debido a problemas propios del entorno de compilación.

```xml
 <PackageReference Include="MongoDB.Driver" Version="2.10.1" />
```

- en el archivo `backend/appsettings.json` se modifica la cadena de conexión a mongo para añadir la autentición (no lo parametrizo por cuestión de tiempo, nunca lo he hecho en .NET )
```json
"ConnectionString": "mongodb://lemon:lemon@lemon-mongo:27017/?authMechanism=SCRAM-SHA-1"
```

Se crea el Dockerfile en `backend/Dockerfile`
```Dockerfile
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
```

Desde la ruta `/backend` podemos construir su imagen y la nombramos '**backendlemon**':
```bash
docker build -t backendlemon:latest . 
```
Creación y despliegue de un contenedor con el proyecto Backend:
- se nombra como '**netbackend**'
- se añade a la red '**lemoncode-challenge**'
- mapea el puerto 5001 al 5000 del contenedor para pruebas ( algunos servicios de macOS usan el puerto 5000 )

```bash
docker run -d --name netbackend --network lemoncode-challenge -p 5001:5000 backendlemon   
```

### FrontEnd 

Modificaciones respecto al repositorio original del Challenge:
- sin modificaciones.

Se crea el Dockerfile en `frontend/Dockerfile`
- Como parametro se pasa la url del backend expuesto en el puerto 5000
```Dockerfile
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
```

Desde la ruta `/frontend` podemos construir su imagen y la nombramos '**frontendlemon**':
```bash
docker build -t frontendlemon:latest . 
```

Creación y despliegue de un contenedor con el proyecto Frontend:
- se nombra como '**nodefrontend**'
- se añade a la red '**lemoncode-challenge**'
- mapea el puerto 3000 al 3000 del contenedor para que sea accesible 

```bash
docker run -d 
--name nodefrontend 
--network lemoncode-challenge 
-p 3000:3000 
frontendlemon
```

### Resultado 

Desde la URL [http://localhost:3000](http://localhost:3000) ya será accesible y visible la lista de elementos.

![](./images/front.png)


## Ejercicio 2 - Docker Compose

Se crea el docker-compose.yml en la raiz del proyecto con la estructura:
- Servicios:
    - MongoDB
    - Backend
    - Frontend
- Volumenes:
    - lemonmongovol
- Redes:
    - lemoncode-challenge

```yaml
version: '3.4'
services:
  lemon-mongo:
    image: mongo
    volumes:
      - lemonmongovol:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=lemon 
      - MONGO_INITDB_ROOT_PASSWORD=lemon
    networks:
      - lemoncode-challenge
    ports:
      - 27017:27017

  netbackend:
    image: backendlemon
    build: ./backend
    depends_on:
      - lemon-mongo
    networks:
      - lemoncode-challenge
    ports:
      - 5001:5000


  nodefrontend:
    image: frontendlemon
    build: ./frontend
    depends_on:
      - netbackend
    environment:
      - API_URI=http://netbackend:5000/api/topics
    networks:
      - lemoncode-challenge
    ports:
      - 3000:3000


volumes:
  lemonmongovol:
    name: lemonmongovol

networks:
  lemoncode-challenge:
    driver: bridge
    name: lemoncode-challenge
    
```

Para ejecutarlo habrá que indicar que además construya las imagenes que necesite desde los Dockerfile de cada proyecto:

```bash
docker-compose up -d --build
```

Hecho con ❤️ y ☕️ por @sitobusnan








