CREATE DATABASE IF NOT EXISTS otus;

USE otus;

-- Категории продуктов
CREATE TABLE IF NOT EXISTS category (
    category_id int primary key AUTO_INCREMENT,
    description varchar(255) not null
);

-- Производители
CREATE TABLE IF NOT EXISTS manufacturer (
    manufacturer_id int primary key AUTO_INCREMENT,
    company_type varchar(11) not null,
    company_name varchar(255),
    country varchar(255) not null
);

-- Продукты
CREATE TABLE IF NOT EXISTS product (
    product_id int primary key AUTO_INCREMENT,
    category_id bigint not null REFERENCES category (category_id),
    manufacturer_id bigint not null REFERENCES manufacturer (manufacturer_id),
    description varchar(255) not null
);

-- Поставщики
CREATE TABLE IF NOT EXISTS supplier (
    supplier_id int primary key AUTO_INCREMENT,
    company_type varchar(11) not null,
    company_name varchar(255) not null,
    inn varchar(12) UNIQUE not null CHECK (char_length(inn) = 10 or char_length(inn) = 12),
    postcode varchar(255),
    country varchar(255) not null,
    city varchar(255) not null,
    street varchar(255) not null,
    house varchar(255),
    apartment varchar(255),
    phone varchar(255) UNIQUE not null,
    email varchar(255) not null
);

-- Цены
CREATE TABLE IF NOT EXISTS price (
    price_id int primary key AUTO_INCREMENT,
    product_id bigint not null REFERENCES product (product_id),
    supplier_id bigint not null REFERENCES supplier (supplier_id),
    price numeric not null CHECK (price >= 0)
);

-- Покупатели
CREATE TABLE IF NOT EXISTS buyer (
    buyer_id int primary key AUTO_INCREMENT,
    name varchar(255) not null
);

-- Счета
CREATE TABLE IF NOT EXISTS invoice (
    invoice_id int primary key AUTO_INCREMENT,
    buyer_id bigint not null REFERENCES buyer (buyer_id),
    invoice_number varchar(255) not null,
    invoice_date timestamp not null
);

-- Покупки
CREATE TABLE IF NOT EXISTS sale (
    sale_id int primary key AUTO_INCREMENT,
    invoice_id bigint not null REFERENCES invoice (invoice_id),
    price_id bigint not null REFERENCES price (price_id),
    amount integer not null CHECK (amount > 0)
);
