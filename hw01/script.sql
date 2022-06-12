--CREATE DATABASE shop;
--CREATE USER "user" WITH ENCRYPTED PASSWORD 'password';
--GRANT ALL PRIVILEGES ON DATABASE shop TO "user";

CREATE SCHEMA shop;

-- Категории продуктов
CREATE TABLE shop.category (
    category_id bigserial primary key,
    description text not null
);

-- Производители
CREATE TABLE shop.manufacturer (
    manufacturer_id bigserial primary key,
    address text not null
);

-- Продукты
CREATE TABLE shop.product (
    product_id bigserial primary key,
    category_id bigint not null REFERENCES shop.category (category_id),
    manufacturer_id bigint not null REFERENCES shop.manufacturer (manufacturer_id),
    description text not null
);


-- Поставщики
CREATE TABLE shop.supplier (
    supplier_id bigserial primary key,
    address text not null
);

-- Цены
CREATE TABLE shop.price (
    price_id bigserial primary key,
    product_id bigint not null REFERENCES shop.product (product_id),
    supplier_id bigint not null REFERENCES shop.supplier (supplier_id),
    price numeric default 0
);

-- Покупатели
CREATE TABLE shop.buyer (
    buyer_id bigserial primary key,
    name text not null
);

-- Покупки
CREATE TABLE shop.sale (
    sale_id bigserial primary key,
    buyer_id bigint not null REFERENCES shop.buyer (buyer_id),
    price_id bigint not null REFERENCES shop.price (price_id),
    date timestamp not null
);