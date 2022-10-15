## Выполнение домашнего задания

### 1. Добавление индексов

В файле scripе.sql добавил индексы для БД

Пока нет реальных данных, сложно оценить улучшения / ухудшения от использования индексов.
Нужно будет анализировать в процессе работы, смотреть slow запросы и explain

- Для примера, проверил индексы на тестовой базе AdventureWorks 

Таблица Address, 19614 записей, индексов нет

```
SELECT count(*) FROM address
WHERE city = 'Renton';

115 записей, 504 ms

EXPLAIN SELECT count(*) FROM address
WHERE city = 'Renton';

1,SIMPLE,address,,ALL,,,,,19639,10,Using where

-- добавление индекса 
CREATE INDEX idx_address_city ON address(city);

SELECT count(*) FROM address
WHERE city = 'Renton';

115 записей, 178 ms

EXPLAIN SELECT count(*) FROM address
WHERE city = 'Renton';

1,SIMPLE,address,,ref,idx_address_city,idx_address_city,92,const,115,100,Using index
```

### 2. Полнотекстовый поиск

- На тестовой базе AdventureWorks для примера полнотекстового поиска подходит 
таблица с описанием товаров productdescription

```
SELECT count(Description) FROM productdescription;
762

SELECT Description FROM productdescription LIMIT 10;

Chromoly steel.
Aluminum alloy cups; large diameter spindle.
Aluminum alloy cups and a hollow axle.
"Suitable for any type of riding, on or off-road. Fits any budget. Smooth-shifting with a comfortable ride."
"This bike delivers a high-level of performance on a budget. It is responsive and maneuverable, and offers peace-of-mind when you decide to go off-road."
For true trail addicts.  An extremely durable bike that will go anywhere and keep you in control on challenging terrain - without breaking your budget.
Serious back-country riding. Perfect for all levels of competition. Uses the same HL Frame as the Mountain-100.
"Top-of-the-line competition mountain bike. Performance-enhancing options include the innovative HL Frame, super-smooth front suspension, and traction for all terrain."
Suitable for any type of off-road trip. Fits any budget.
Entry level adult bike; offers a comfortable ride cross-country or down the block. Quick-release hubs and rims.

-- добавление индекса для полнотектового поиска
CREATE FULLTEXT INDEX idx_productdescription_fulltext ON productdescription(Description);

-- использование полнотектового поиска
SELECT Description FROM productdescription WHERE MATCH (Description) AGAINST ('HIGH');

"This bike delivers a high-level of performance on a budget. It is responsive and maneuverable, and offers peace-of-mind when you decide to go off-road."
Travel in style and comfort. Designed for maximum comfort and safety. Wide gear range takes on all hills. High-tech aluminum alloy construction provides durability without added weight.
High-strength crank arm.
High-performance carbon road fork with curved legs.
High-performance mountain replacement wheel.
Designed for racers; high-end anatomically shaped bar from aluminum alloy.
"High-quality 1"" threadless headset with a grease port for quick lubrication."
"Great traction, high-density rubber."
High-density rubber.
High-performance mountain replacement wheel.
```

