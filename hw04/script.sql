-- создание базы данных
CREATE DATABASE shop;

-- создание схем
CREATE SCHEMA shop;
CREATE SCHEMA storage;

-- Создание пользователя user и reader
CREATE USER "user" WITH ENCRYPTED PASSWORD 'password';
CREATE USER "reader" WITH ENCRYPTED PASSWORD 'password';

-- Назначению пользователю user всех привилегий
GRANT ALL PRIVILEGES ON DATABASE shop TO "user";

-- Создание роли только для чтения
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE shop TO readonly;
GRANT USAGE ON SCHEMA shop TO readonly;
GRANT USAGE ON SCHEMA storage TO readonly;

-- Выдача прав только на select
GRANT SELECT ON ALL TABLES IN SCHEMA shop TO readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA shop TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA storage TO readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA storage TO readonly;

-- Назначение роли только для чтения пользователю reader
GRANT readonly TO "reader";

-----------------------------------------------
-- Для примера несколько таблиц в разных схемах
-----------------------------------------------

-- Категории продуктов - в схеме shop
CREATE TABLE shop.category (
    category_id bigserial primary key,
    description text not null
);

-- Поставщики - в схеме storage
CREATE TABLE storage.supplier (
    supplier_id bigserial primary key,
    company_type varchar(11) not null,
    company_name text not null,
    inn varchar(12) UNIQUE not null CHECK (char_length(inn) = 10 or char_length(inn) = 12),
    postcode text,
    country text not null,
    city text not null,
    street text not null,
    house text,
    apartment text,
    phone text UNIQUE not null
);

-- Проверка под пользователем reader - можно только читать данные