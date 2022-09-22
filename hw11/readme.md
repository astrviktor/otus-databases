## Выполнение домашнего задания

##### 1. Напишите запрос по своей базе с inner join

Добавить к товару страну производителя

```
SELECT
  p.description as "Описание товара",
  m.country as "Страна производителя"
FROM product p
INNER JOIN manufacturer m ON p.manufacturer_id = m.manufacturer_id;
```
В случае INNER JOIN если в таблице manufacturer нет производителя для товара, товар не будет выведен

##### 2. Напишите запрос по своей базе с left join

```
SELECT
  p.description as "Описание товара",
  m.country as "Страна производителя"
FROM product p
LEFT JOIN manufacturer m ON p.manufacturer_id = m.manufacturer_id;
```
В случае LEFT JOIN если в таблице manufacturer нет производителя, товар все равно будет выведен с NULL в стране производителя

##### 3. Напишите 5 запросов с WHERE с использованием разных операторов, опишите для чего вам в проекте нужна такая выборка данных

Возможные запросы в проекте

- Поиск по конкретной цене
- Поиск по диапазону цен (между минимальной и максимальной)
- Поиск по наименованию или описанию
- Поиск по датам
- Выбор по производителю из конкретной страны


Выбрать идентификаторы товаров у которых цена = 100

```
SELECT
  product_id, price
FROM price
WHERE price = 100;
```

Выбрать идентификаторы товаров у которых цена от 100 до 300
```
SELECT
  product_id, price
FROM price
WHERE price BETWEEN 100 AND 300;
```

Выбрать все товары которые начинаются со слова "Яблоки"

```
SELECT * FROM product
WHERE name like 'Яблоки%';
```

Выбрать все счета за 2022 год

```
SELECT * FROM invoice
WHERE invoice_date >= '2022-01-01';
```

Выбрать все товары, у которых производитель из России

```
SELECT * FROM product p
WHERE p.manufacturer_id IN
  (SELECT m.manufacturer_id FROM manufacturer m WHERE m.country = 'Россия');
```


