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
    company_type varchar(11) not null,
    company_name text,
    country text not null
);

CREATE INDEX idx_manufacturer_company_type ON shop.manufacturer(company_type);
CREATE INDEX idx_manufacturer_company_name ON shop.manufacturer(company_name);
CREATE INDEX idx_manufacturer_country ON shop.manufacturer(country);

-- Продукты
CREATE TABLE shop.product (
    product_id bigserial primary key,
    category_id bigint not null REFERENCES shop.category (category_id),
    manufacturer_id bigint not null REFERENCES shop.manufacturer (manufacturer_id),
    description text not null
);

-- Проверка для email
CREATE DOMAIN email AS TEXT CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

-- Поставщики
CREATE TABLE shop.supplier (
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
    phone text UNIQUE not null,
    email email not null
);

CREATE INDEX idx_supplier_company_type ON shop.supplier(company_type);
CREATE INDEX idx_supplier_company_name ON shop.supplier(company_name);
CREATE INDEX idx_supplier_inn ON shop.supplier(inn);
CREATE INDEX idx_supplier_country ON shop.supplier(country);
CREATE INDEX idx_supplier_city ON shop.supplier(city);
CREATE INDEX idx_supplier_phone ON shop.supplier(phone);
CREATE INDEX idx_supplier_email ON shop.supplier(email);

-- Цены
CREATE TABLE shop.price (
    price_id bigserial primary key,
    product_id bigint not null REFERENCES shop.product (product_id),
    supplier_id bigint not null REFERENCES shop.supplier (supplier_id),
    price numeric not null CHECK (price >= 0)
);

-- Покупатели
CREATE TABLE shop.buyer (
    buyer_id bigserial primary key,
    name text not null
);


-- Счета
CREATE TABLE shop.invoice (
    invoice_id bigserial primary key,
    buyer_id bigint not null REFERENCES shop.buyer (buyer_id),
    invoice_number text not null,
    invoice_date timestamp not null
)

CREATE INDEX idx_invoice_buyer_id ON shop.invoice(buyer_id);
CREATE INDEX idx_invoice_invoice_number ON shop.invoice(invoice_number);
CREATE INDEX idx_invoice_invoice_date ON shop.invoice(invoice_date);
CREATE INDEX idx_invoice_buyer_id_invoice_date ON shop.invoice(buyer_id,invoice_date);

-- Покупки
CREATE TABLE shop.sale (
    sale_id bigserial primary key,
    invoice_id bigint not null REFERENCES shop.invoice (invoice_id),
    price_id bigint not null REFERENCES shop.price (price_id),
    amount integer not null CHECK (amount > 0)
);

CREATE INDEX idx_sale_price_id ON shop.sale(price_id);
CREATE INDEX idx_sale_amount ON shop.sale(amount);