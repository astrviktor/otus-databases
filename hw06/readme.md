## Выполнение домашнего задания

##### 1. Создать индекс к какой-либо из таблиц вашей БД

Таблица

```
-- Таблица производители

CREATE TABLE shop.manufacturer (
    manufacturer_id bigserial primary key,
    company_type varchar(11) not null,
    company_name text,
    country text not null
);
```

Индекс

```
-- Индекс на тип компаний

CREATE INDEX idx_manufacturer_company_type ON shop.manufacturer(company_type);
```

##### 2. Прислать текстом результат команды explain, в которой используется данный индекс

Без индекса

```
EXPLAIN (SELECT * FROM shop.manufacturer WHERE company_type = 'ООО');

Seq Scan on manufacturer  (cost=0.00..17.25 rows=3 width=112)
  Filter: ((company_type)::text = 'ООО'::text)

```

С индексом

```
EXPLAIN (SELECT * FROM shop.manufacturer WHERE company_type = 'ООО');

Seq Scan on manufacturer  (cost=0.00..1.04 rows=1 width=32)
  Filter: ((company_type)::text = 'ООО'::text)
```

Оценка стоимости уменьшилась в 16 раз

##### 3. Реализовать индекс для полнотекстового поиска

Индекс для поиска по названиям компаний

```
CREATE INDEX idx_search_manufacturer_company_name ON shop.manufacturer USING gin(to_tsvector('russian', company_name));
```

Использование

```
SELECT company_name 
FROM shop.manufacturer 
WHERE company_name @@ 'регион'
```

##### 4. Реализовать индекс на часть таблицы или индекс на поле с функцией

Индекс для части таблицы - только для типов компаний 'ООО' 

```
CREATE INDEX idx_manufacturer_company_type_ooo ON shop.manufacturer(company_type) WHERE company_type = 'ООО';
```

##### 5. Создать индекс на несколько полей

Индекс по типу компании и по названию компании

```
CREATE INDEX idx_manufacturer_company_type_company_name ON shop.manufacturer(company_type, company_name);
```

##### 6. Написать комментарии к каждому из индексов

Сделано

##### 7. Описать что и как делали и с какими проблемами столкнулись

Проблем не было


