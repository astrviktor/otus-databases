## Выполнение домашнего задания

### 1. Загрузка данных в MySQL

Для анализа данных можно сразу загрузить их в MySQL

```
CREATE TABLE IF NOT EXISTS some_customers
(
    title varchar(100),
    first_name varchar(100),
    last_name varchar(100),
    correspondence_language varchar(100),
    birth_date varchar(100),
    gender varchar(100),
    marital_status varchar(100),
    country varchar(100),
    postal_code varchar(100),
    region varchar(100),
    city varchar(100),
    street varchar(100),
    building_number varchar(100)
)
```

Загрузка данных

```
LOAD DATA INFILE '/home/root/some_customers.csv'
INTO TABLE some_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

Проверка, что данные загрузились

```
SELECT count(*) FROM some_customers;

1154 строки
```

### 2. Анализ данных

Для каждого поля нужно поделать запросы следующего вида (на примере title)

```
SELECT distinct title FROM some_customers;
SELECT count(distinct title) FROM some_customers;
SELECT max(length(title)) FROM some_customers;
SELECT title FROM some_customers ORDER BY title DESC LIMIT 1;
```

Чтобы понять вариативность данных, пропуски, максимальную длинну, возможный тип данных (загружено все в строках)

Получилось следующее

```
title varchar(20)
first_name varchar(40)
last_name varchar(40)
correspondence_language varchar(2)
birth_date date
gender varchar(7)
marital_status varchar(1)
country varchar(2)
postal_code varchar(10)
region varchar(20)
city varchar(40)
street varchar(60)
building_number varchar(10)
```

### 3. Проектирование базы данных

Можно выделить справочники и таблицы для связей

Получилось следующее:

```
CREATE TABLE IF NOT EXISTS region (
    region_id int primary key AUTO_INCREMENT NOT NULL,
    name varchar(20),
    country varchar(2)
);

CREATE TABLE IF NOT EXISTS city (
    city_id int primary key AUTO_INCREMENT NOT NULL,
    name varchar(40)
);

CREATE TABLE IF NOT EXISTS street (
    street_id int primary key AUTO_INCREMENT NOT NULL,
    name varchar(60)
);

CREATE TABLE IF NOT EXISTS address
(
    address_id int primary key AUTO_INCREMENT NOT NULL,
    postal_code varchar(10),
    region_id int NOT NULL,
    city_id int NOT NULL,
    street_id int NOT NULL,
    building_number varchar(10),

    FOREIGN KEY (region_id) REFERENCES region (region_id),
    FOREIGN KEY (city_id) REFERENCES city (city_id),
    FOREIGN KEY (street_id) REFERENCES street (street_id)
);

CREATE TABLE IF NOT EXISTS person
(
    person_id int primary key AUTO_INCREMENT NOT NULL,
    title varchar(20),
    first_name varchar(40),
    last_name varchar(40),
    gender varchar(7),
    birth_date date,
    marital_status varchar(1),
    correspondence_language varchar(2)
);

CREATE TABLE IF NOT EXISTS person_address
(
    person_id int NOT NULL,
    address_id int NOT NULL,

    FOREIGN KEY (person_id) REFERENCES person (person_id),
    FOREIGN KEY (address_id) REFERENCES address (address_id)
);

```
![Alt text](hw19-schema.jpg?raw=true "hw19-schema")

### 4. Конвертация данных в новую структуру данных

Нужны дополнительные функции и процедуры

Алгоритм следующий: функцией получаем id записи в справочнике
- если записи не было, запись добавляется и возвращается новый id 
- если запись была, новая не добавляется, возвращается старый id

Процедура `convert_some_customers` обрабатывает все записи в таблице `some_customers`, 
распределяет по справочникам и делает связи

```
CREATE FUNCTION `add_street`(
    street_name varchar(60)
)
RETURNS int DETERMINISTIC
BEGIN
    IF EXISTS (SELECT street_id FROM street WHERE name = street_name) THEN
      BEGIN
        SELECT street_id INTO @id FROM street WHERE name = street_name;
        RETURN @id;
      END;
    ELSE
      BEGIN
        INSERT INTO street(name) VALUES (street_name);
        RETURN LAST_INSERT_ID();
      END;
    END IF;
END;


CREATE FUNCTION `add_city`(
    city_name varchar(40)
)
RETURNS int DETERMINISTIC
BEGIN
    IF EXISTS (SELECT city_id FROM city WHERE name = city_name) THEN
      BEGIN
        SELECT city_id INTO @id FROM city WHERE name = city_name;
        RETURN @id;
      END;
    ELSE
      BEGIN
        INSERT INTO city(name) VALUES (city_name);
        RETURN LAST_INSERT_ID();
      END;
    END IF;
END;


CREATE FUNCTION `add_region`(
    region_name varchar(20),
    country_name varchar(2)
)
RETURNS int DETERMINISTIC
BEGIN
    IF EXISTS (SELECT region_id FROM region WHERE name = region_name AND country = country_name) THEN
      BEGIN
        SELECT region_id INTO @id FROM region WHERE name = region_name AND country = country_name;
        RETURN @id;
      END;
    ELSE
      BEGIN
        INSERT INTO region(name, country) VALUES (region_name, country_name);
        RETURN LAST_INSERT_ID();
      END;
    END IF;
END;


CREATE FUNCTION `add_address`(
    postal varchar(10),
    region varchar(20),
    country varchar(2),
    city varchar(40),
    street varchar(60),
    building varchar(10)
)
RETURNS int DETERMINISTIC
BEGIN
    SET @rid = add_region(region, country);
    SET @cid = add_city(city);
    SET @sid = add_street(street);

    IF EXISTS (
      SELECT address_id FROM address
      WHERE postal_code = postal AND region_id = @rid AND city_id = @cid
        AND street_id = @sid AND building_number = building
    )
    THEN
      BEGIN
        SELECT address_id INTO @id
        FROM address
        WHERE postal_code = postal AND region_id = @rid AND city_id = @cid
          AND street_id = @sid AND building_number = building;

        RETURN @id;
      END;
    ELSE
      BEGIN
        INSERT INTO address(postal_code, region_id, city_id, street_id, building_number)
        VALUES (postal, @rid, @cid, @sid, building);

        RETURN LAST_INSERT_ID();
      END;
    END IF;
END;


CREATE FUNCTION `add_person`(
    in_title varchar(20),
    in_first_name varchar(40),
    in_last_name varchar(40),
    in_gender varchar(7),
    in_birth_date date,
    in_marital_status varchar(1),
    in_correspondence_language varchar(2)
)
RETURNS int DETERMINISTIC
BEGIN
    IF EXISTS (
      SELECT person_id FROM person
      WHERE title = in_title AND first_name = in_first_name AND last_name = in_last_name AND
        gender = in_gender AND birth_date = in_birth_date AND marital_status = in_marital_status AND
        correspondence_language = in_correspondence_language
    )
    THEN
      BEGIN
        SELECT person_id INTO @id
        FROM person
        WHERE title = in_title AND first_name = in_first_name AND last_name = in_last_name AND
          gender = in_gender AND birth_date = in_birth_date AND marital_status = in_marital_status AND
          correspondence_language = in_correspondence_language;

        RETURN @id;
      END;
    ELSE
      BEGIN
        INSERT INTO person(title, first_name, last_name, gender, birth_date, marital_status, correspondence_language)
        VALUES (in_title, in_first_name, in_last_name, in_gender, in_birth_date, in_marital_status, in_correspondence_language);

        RETURN LAST_INSERT_ID();
      END;
    END IF;
END;


CREATE PROCEDURE `convert_some_customers`()
BEGIN
  DECLARE v_title varchar(20);
  DECLARE v_first_name varchar(40);
  DECLARE v_last_name varchar(40);
  DECLARE v_correspondence_language varchar(2);
  DECLARE v_birth_date date;
  DECLARE v_gender varchar(7);
  DECLARE v_marital_status varchar(1);
  DECLARE v_country varchar(2);
  DECLARE v_postal_code varchar(10);
  DECLARE v_region varchar(20);
  DECLARE v_city varchar(40);
  DECLARE v_street varchar(60);
  DECLARE v_building_number varchar(10);

  DECLARE done INT DEFAULT FALSE;

  DECLARE cursor_some_customers CURSOR FOR
      SELECT
        title, first_name, last_name, correspondence_language, IFNULL(date(birth_date),'1000-01-01'), gender, marital_status,
        country, postal_code, region, city, street, building_number
      FROM some_customers;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cursor_some_customers;

  loop_through_rows: LOOP
    FETCH cursor_some_customers INTO
        v_title, v_first_name, v_last_name, v_correspondence_language, v_birth_date, v_gender, v_marital_status,
        v_country, v_postal_code, v_region, v_city, v_street, v_building_number;

    IF done THEN
      LEAVE loop_through_rows;
    END IF;

    SET @pid = add_person(v_title, v_first_name, v_last_name, v_gender, v_birth_date, v_marital_status, v_correspondence_language);
    SET @aid = add_address(v_postal_code, v_region,v_country,v_city, v_street, v_building_number);

    INSERT INTO person_address(person_id, address_id) VALUES (@pid, @aid);

  END LOOP;

  CLOSE cursor_some_customers;
END;
```

Для запуска конвертации нужно выполнить
```
CALL `convert_some_customers`();
```

Проверка конвертации

```
SELECT count(*) FROM some_customers;
1154 шт.

SELECT count(*) FROM person_address;
1154 шт.
```

### 5. Кластер innodb

Запускается в docker

Нужно перейти в папку `innodb-cluster` и выполнить

```
docker-compose up
```

По логам будет видна готовность кластера:

```
mysql-router      | [Entrypoint] Starting mysql-router.
mysql-router      | 2022-10-27 07:03:27 io INFO [7fed24937780] starting 3 io-threads, using backend 'linux_epoll'
mysql-router      | 2022-10-27 07:03:27 http_server INFO [7fed24937780] listening on 0.0.0.0:8443
mysql-router      | 2022-10-27 07:03:27 metadata_cache_plugin INFO [7fed1e31d700] Starting Metadata Cache
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1e31d700] Connections using ssl_mode 'PREFERRED'
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700] Starting metadata cache refresh thread
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed077fe700] [routing:bootstrap_ro] started: routing strategy = round-robin-with-fallback
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed077fe700] Start accepting connections for routing routing:bootstrap_ro listening on 6447
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed06ffd700] [routing:bootstrap_rw] started: routing strategy = first-available
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed06ffd700] Start accepting connections for routing routing:bootstrap_rw listening on 6446
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed05ffb700] [routing:bootstrap_x_ro] started: routing strategy = round-robin-with-fallback
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed05ffb700] Start accepting connections for routing routing:bootstrap_x_ro listening on 6449
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed057fa700] [routing:bootstrap_x_rw] started: routing strategy = first-available
mysql-router      | 2022-10-27 07:03:27 routing INFO [7fed057fa700] Start accepting connections for routing routing:bootstrap_x_rw listening on 6448
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700] Connected with metadata server running on mysql-server-1:3306
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700] Potential changes detected in cluster 'devCluster' after metadata refresh
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700] Metadata for cluster 'devCluster' has 3 member(s), single-primary: (view_id=0)
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700]     mysql-server-1:3306 / 33060 - mode=RW 
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700]     mysql-server-2:3306 / 33060 - mode=RO 
mysql-router      | 2022-10-27 07:03:27 metadata_cache INFO [7fed1c319700]     mysql-server-3:3306 / 33060 - mode=RO 
```

В docker-compose добавлен phpmyadmin, можно зайти через http://127.0.0.1:8081 root / mysql 