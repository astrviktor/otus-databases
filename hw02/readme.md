## Расширение таблиц

### Добавление данных в таблицу "Поставщики" (supplier):
- тип компании (ИП, ООО, ОАО, ...)
- название компании
- ИНН
- страна
- город
- улица
- дом
- квартира / кабинет
- телефон
- email

Возможные запросы:
- Поиск по типу (кардинальность средняя)
- Поиск по названию (кардинальность высокая)
- Поиск по ИНН (кардинальность высокая, уникальный)
- Поиск по стране (кардинальность низкая)
- Поиск по городу (кардинальность высокая)
- Поиск по телефону (кардинальность высокая, уникальный)
- Поиск по email (кардинальность высокая, уникальный)

Ограничения:
- тип компании - максимум 11, not null
- ИНН - 10 или 12, уникальный, может начинаться с 0, not null
- страна, город, улица - not null
- телефон - уникальный, not null
- email - уникальный, формат email, not null

Индексы:
- CREATE INDEX idx_supplier_company_type ON supplier(company_type);
- CREATE INDEX idx_supplier_company_name ON supplier(company_name);
- CREATE INDEX idx_supplier_inn ON supplier(inn);
- CREATE INDEX idx_supplier_country ON supplier(country);
- CREATE INDEX idx_supplier_city ON supplier(city);
- CREATE INDEX idx_supplier_phone ON supplier(phone);
- CREATE INDEX idx_supplier_email ON supplier(email);


### Добавление данных в таблицу "Производители" (manufacturer):
(Для производителей пока не нужно так много данных, как для поставщиков)
- тип компании (ИП, ООО, ОАО, ...)
- название компании
- страна

Возможные запросы и ограничения - как для поставщиков

Индексы:
- CREATE INDEX idx_manufacturer_company_type ON manufacturer(company_type);
- CREATE INDEX idx_manufacturer_company_name ON manufacturer(company_name);
- CREATE INDEX idx_manufacturer_country ON manufacturer(country);

### Добавление таблицы "Счета" (invoice)
- id счета
- id покупателя
- номер счета
- дата счета

Возможные запросы:
- Поиск по покупателю (кардинальность высокая)
- Поиск по номеру (кардинальность высокая)
- Поиск по дате (кардинальность средняя)
- По покупателю и дате

Ограничения:
- номер счета - not null
- дата счета - not null

Индексы:
- CREATE INDEX idx_invoice_buyer_id ON invoice(buyer_id);
- CREATE INDEX idx_invoice_invoice_number ON invoice(invoice_number);
- CREATE INDEX idx_invoice_invoice_date ON invoice(invoice_date);
- CREATE INDEX idx_invoice_buyer_id_invoice_date ON invoice(buyer_id,invoice_date);

### Добавление данных в таблицу "Покупки" (sale):
- счет
- количество

Возможные запросы:
- Поиск по счету (кардинальность высокая)
- Поиск по товарам (кардинальность высокая)

Ограничения:
- количество - больше 0, not null

Индексы:
- CREATE INDEX idx_sale_price_id ON sale(price_id);
- CREATE INDEX idx_sale_amount ON sale(amount);

