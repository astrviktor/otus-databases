## Выполнение домашнего задания

##### 1. Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти. 

Выбрать все товары, у которых производитель из России

```
SELECT * FROM shop.product p
WHERE p.manufacturer_id IN 
  (SELECT m.manufacturer_id FROM shop.manufacturer m WHERE m.country = 'Россия');
```

##### 2. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?

Добавить к товару страну производителя 

```
SELECT
  p.description as "Описание товара",
  m.country as "Страна производителя"
FROM shop.product p
LEFT JOIN shop.manufacturer m ON p.manufacturer_id = m.manufacturer_id

SELECT
  p.description as "Описание товара",
  m.country as "Страна производителя"
FROM  shop.product p
INNER JOIN shop.manufacturer m ON p.manufacturer_id = m.manufacturer_id
```

- В случае LEFT JOIN если в таблице shop.manufacturer нет производителя, товар все равно будет выведен с NULL в стране производителя
- В случае INNER JOIN если в таблице shop.manufacturer нет производителя, товар не будет выведен

##### 3. Напишите запрос на добавление данных с выводом информации о добавленных строках.

Добавить новые категории товаров

```
INSERT INTO shop.category(description)
VALUES ('Товары для дома'), ('Товары для животных')
RETURNING *;
```

##### 4. Напишите запрос с обновлением данные используя UPDATE FROM.

Обновить цену с использованием таблицы поставщиков

```
UPDATE shop.price AS p
SET price = s.price
FROM shop.supplier AS s
WHERE p.supplier_id = s.supplier_id;
```

##### 5. Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.

Удалить все товары для которых есть категория товара в таблице категорий

```
DELETE FROM shop.product p
USING shop.category c
WHERE p.category_id = c.category_id
RETURNING *;
```

##### * 6. Приведите пример использования утилиты COPY (по желанию)

Выгрузить данные по товарам в файл

```
COPY shop.product TO '/tmp/product.copy';
```
