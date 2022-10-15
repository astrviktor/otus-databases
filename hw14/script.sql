CREATE DATABASE IF NOT EXISTS otus;

USE otus;

-- Категории продуктов
CREATE TABLE IF NOT EXISTS category (
    category_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    description varchar(1000) not null
);

-- Производители
CREATE TABLE IF NOT EXISTS manufacturer (
    manufacturer_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    company_type varchar(11) not null,
    company_name varchar(200) not null,
    country varchar(168) not null
);

CREATE INDEX idx_manufacturer_company_type ON manufacturer(company_type);
CREATE INDEX idx_manufacturer_company_name ON manufacturer(company_name);
CREATE INDEX idx_manufacturer_country ON manufacturer(country);

-- Продукты
CREATE TABLE IF NOT EXISTS product (
    product_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    category_id int not null REFERENCES category (category_id),
    manufacturer_id int not null REFERENCES manufacturer (manufacturer_id),
    description varchar(1000) not null,
    tags JSON DEFAULT NULL
);

-- Поставщики
CREATE TABLE IF NOT EXISTS supplier (
    supplier_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    company_type varchar(11) not null,
    company_name varchar(200) not null,
    inn varchar(12) UNIQUE not null CHECK (char_length(inn) = 10 or char_length(inn) = 12),
    postcode varchar(10),
    country varchar(168) not null,
    city varchar(168) not null,
    street varchar(100) not null,
    house varchar(10),
    apartment varchar(10),
    phone varchar(15) UNIQUE not null,
    email varchar(100) not null
);

CREATE INDEX idx_supplier_company_type ON supplier(company_type);
CREATE INDEX idx_supplier_company_name ON supplier(company_name);
CREATE INDEX idx_supplier_inn ON supplier(inn);
CREATE INDEX idx_supplier_country ON supplier(country);
CREATE INDEX idx_supplier_city ON supplier(city);
CREATE INDEX idx_supplier_phone ON supplier(phone);
CREATE INDEX idx_supplier_email ON supplier(email);

-- Цены
CREATE TABLE IF NOT EXISTS price (
    price_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    product_id int not null REFERENCES product (product_id),
    supplier_id int not null REFERENCES supplier (supplier_id),
    price numeric not null CHECK (price >= 0)
);

-- Покупатели
CREATE TABLE IF NOT EXISTS buyer (
    buyer_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    name varchar(200) not null
);

-- Счета
CREATE TABLE IF NOT EXISTS invoice (
    invoice_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    buyer_id bigint not null REFERENCES buyer (buyer_id),
    invoice_number varchar(20) not null,
    invoice_date timestamp not null
);

CREATE INDEX idx_invoice_buyer_id ON invoice(buyer_id);
CREATE INDEX idx_invoice_invoice_number ON invoice(invoice_number);
CREATE INDEX idx_invoice_invoice_date ON invoice(invoice_date);
CREATE INDEX idx_invoice_buyer_id_invoice_date ON invoice(buyer_id,invoice_date);

-- Покупки
CREATE TABLE IF NOT EXISTS sale (
    sale_id int UNSIGNED primary key AUTO_INCREMENT NOT NULL UNIQUE,
    invoice_id int not null REFERENCES invoice (invoice_id),
    price_id int not null REFERENCES price (price_id),
    amount int not null CHECK (amount > 0)
);

CREATE INDEX idx_sale_price_id ON sale(price_id);
CREATE INDEX idx_sale_amount ON sale(amount);