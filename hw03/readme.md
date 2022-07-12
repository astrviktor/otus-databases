### 1. Развернуть контейнер с PostgreSQL
Запуск через Docker в Linux
```
docker run --detach \
  --publish 5432:5432 \
  --name postgres \
  --restart always \
  --env POSTGRES_DB="shop" \
  --env POSTGRES_USER="user" \
  --env POSTGRES_PASSWORD="password" \
postgres:14.4
```
### 2. Запустить сервер
Для проверки, что контейнер запустился, ввести команду: 
```
docker ps
```
Результат:
```
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                       NAMES
710f1d26d660   postgres:14.4   "docker-entrypoint.s…"   35 seconds ago   Up 30 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
```

### 3. Создать клиента с подключением к базе данных postgres через командную строку
Выполнить команду:
```
docker exec -it postgres bash
psql --username=user --dbname=shop
```
Результат:
```
psql (14.4 (Debian 14.4-1.pgdg110+1))
Type "help" for help.

shop=#
```
### 4. Подключиться к серверу используя pgAdmin или другое аналогичное приложение
Сделал подключение через IntelliJ DataGrip

![Alt text](datagrip.jpg?raw=true "DataGrip")