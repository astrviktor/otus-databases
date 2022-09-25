## Выполнение домашнего задания

#### 1. Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.

Учебный пример: удалить товар по product_id

Создание хранимой процедуры

```
CREATE PROCEDURE delete_product(in id int)
BEGIN
  DELETE FROM price WHERE product_id = id;

  DELETE FROM product WHERE product_id = id;
END;
```
Выполнение хранимой процедуры

```
CALL delete_product(1);
```

#### 2. Загрузить данные из приложенных в материалах csv.

- #### Загрузка данных через LOAD DATA
 
На примере файла jevelry.csv

Нужно приготовить таблицу, в которые загружать данные.

Нужно знать информацию о типах полей, 
для теста можно сделать все данные строками разной длинны

```
CREATE TABLE IF NOT EXISTS jewelry (
  Handle varchar(100),
  Title varchar(100),
  Body_HTML varchar(1000),
  Vendor varchar(100),
  Type varchar(100),
  Tags varchar(100),
  Published varchar(100),
  Option1_Name varchar(100),
  Option1_Value varchar(100),
  Option2_Name varchar(100),
  Option2_Value varchar(100),
  Option3_Name varchar(100),
  Option3_Value varchar(100),
  Variant_SKU varchar(100),
  Variant_Grams varchar(100),
  Variant_Inventory_Tracker varchar(100),
  Variant_Inventory_Qty varchar(100),
  Variant_Inventory_Policy varchar(100),
  Variant_Fulfillment_Service varchar(100),
  Variant_Price varchar(100),
  Variant_Compare_At_Price varchar(100),
  Variant_Requires_Shipping varchar(100),
  Variant_Taxable varchar(100),
  Variant_Barcode varchar(100),
  Image_Src varchar(1000),
  Image_Alt_Text varchar(1000),
  Gift_Card varchar(100),
  SEO_Title varchar(100),
  SEO_Description varchar(100),
  Google_Shopping_Google_Product_Category varchar(100),
  Google_Shopping_Gender varchar(100),
  Google_Shopping_Age_Group varchar(100),
  Google_Shopping_MPN varchar(100),
  Google_Shopping_AdWords_Grouping varchar(100),
  Google_Shopping_AdWords_Labels varchar(100),
  Google_Shopping_Condition varchar(100),
  Google_Shopping_Custom_Product varchar(100),
  Google_Shopping_Custom_Label_0 varchar(100),
  Google_Shopping_Custom_Label_1 varchar(100),
  Google_Shopping_Custom_Label_2 varchar(100),
  Google_Shopping_Custom_Label_3 varchar(100),
  Google_Shopping_Custom_Label_4 varchar(100),
  Variant_Image varchar(100),
  Variant_Weight_Unit varchar(100)
);
```
Для загрузки из под MySQL в docker-контейнере, нужно:

- через docker-compose прокинуть нужную папку с файлами внутрь контейнера

```
volumes:
  - /home/astrviktor/otus-databases/hw12/CSVs:/home/root
```

- добавить опцию в my.cnf

```
secure-file-priv=/home/root
```

Выполнить команду загрузки

```
LOAD DATA INFILE '/home/root/jewelry.csv'
INTO TABLE jewelry
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

- #### Загрузка данных через mysqlimport

https://dev.mysql.com/doc/refman/8.0/en/mysqlimport.html

Очистить результат прошлой загрузки

```
DELETE FROM jewelry;
```

Зайти в docker-контейнер с MySQL и выполнить команду по загрузке

```
docker exec -it otus-mysql-docker_otusdb_1 /bin/bash

mysqlimport --fields-enclosed-by='"' --fields-terminated-by='\n' --lines-terminated-by=',' --ignore-lines=1 --user="root" --password="12345" otus /home/root/jewelry.csv
```