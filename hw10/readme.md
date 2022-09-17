## Выполнение домашнего задания

Общие изменения

1. Первичные ключи уменьшил до int
2. Добавил UNSIGNED NOT NULL UNIQUE к первичным ключам
3. Поменял varchar(255) на более подходящие размеры:
- description varchar(1000)
- company_name varchar(200)
- company_type varchar(11)
- country varchar(168) (самое длинное название может быть 168 символов)

4. Добавил в продукты JSON тип 

```
tags JSON DEFAULT NULL
``` 
Примеры работы с JSON

```
CREATE TABLE IF NOT EXISTS product (
  name varchar(100) not null,
  tags JSON DEFAULT NULL
);

INSERT INTO product(name, tags) VALUES ('Яблоки', '["Круглые", "Овощи", "Штучные"]');

SELECT * FROM product WHERE JSON_CONTAINS(tags, '["Круглые"]');
SELECT * FROM product WHERE JSON_SEARCH(tags, 'one', 'Овощ%') IS NOT NULL;
```