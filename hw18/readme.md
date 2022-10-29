## Выполнение домашнего задания

#### Сложная выборка 

Буду использовать базу данных AdventureWorks

```
SELECT
    soh.SalesOrderID,
    soh.OrderDate,
    soh.SalesOrderNumber,
    soh.AccountNumber,
    soh.SubTotal,
    sod.ProductID,
    sod.UnitPrice,
    sod.ModifiedDate
FROM salesorderheader soh
LEFT join salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
LEFT join address addr ON soh.BillToAddressID = addr.AddressID
WHERE year(soh.OrderDate) = '2002' AND sod.UnitPrice > 1000 AND addr.City = 'London';
```

Время выполнения запроса: 523 ms

#### EXPLAIN

```
1,SIMPLE,addr,,ALL,PRIMARY,,,,19639,10,Using where
1,SIMPLE,soh,,ref,"PRIMARY,my_fk_53",my_fk_53,4,otus.addr.AddressID,1,100,Using where
1,SIMPLE,sod,,ref,my_fk_46,my_fk_46,4,otus.soh.SalesOrderID,3,33.33,Using where
```
#### EXPLAIN FORMAT=JSON

```
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "13559.75"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "addr",
          "access_type": "ALL",
          "possible_keys": [
            "PRIMARY"
          ],
          "rows_examined_per_scan": 19639,
          "rows_produced_per_join": 1963,
          "filtered": "10.00",
          "cost_info": {
            "read_cost": "1807.76",
            "eval_cost": "196.39",
            "prefix_cost": "2004.15",
            "data_read_per_join": "1M"
          },
          "used_columns": [
            "AddressID",
            "City"
          ],
          "attached_condition": "((`otus`.`addr`.`City` = 'London') and (`otus`.`addr`.`AddressID` is not null))"
        }
      },
      {
        "table": {
          "table_name": "soh",
          "access_type": "ref",
          "possible_keys": [
            "PRIMARY",
            "my_fk_53"
          ],
          "key": "my_fk_53",
          "used_key_parts": [
            "BillToAddressID"
          ],
          "key_length": "4",
          "ref": [
            "otus.addr.AddressID"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 3192,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "798.06",
            "eval_cost": "319.22",
            "prefix_cost": "3121.43",
            "data_read_per_join": "2M"
          },
          "used_columns": [
            "SalesOrderID",
            "OrderDate",
            "SalesOrderNumber",
            "AccountNumber",
            "BillToAddressID",
            "SubTotal"
          ],
          "attached_condition": "(year(`otus`.`soh`.`OrderDate`) = '2002')"
        }
      },
      {
        "table": {
          "table_name": "sod",
          "access_type": "ref",
          "possible_keys": [
            "my_fk_46"
          ],
          "key": "my_fk_46",
          "used_key_parts": [
            "SalesOrderID"
          ],
          "key_length": "4",
          "ref": [
            "otus.soh.SalesOrderID"
          ],
          "rows_examined_per_scan": 3,
          "rows_produced_per_join": 3617,
          "filtered": "33.33",
          "cost_info": {
            "read_cost": "9352.98",
            "eval_cost": "361.74",
            "prefix_cost": "13559.75",
            "data_read_per_join": "508K"
          },
          "used_columns": [
            "SalesOrderID",
            "ProductID",
            "UnitPrice",
            "ModifiedDate"
          ],
          "attached_condition": "(`otus`.`sod`.`UnitPrice` > 1000)"
        }
      }
    ]
  }
}
```

#### Оптимизация

Изначально, в той версии данных, которую я загружал для AdventureWorks, нет индексов, кроме PRIMARY и FK

Нужно попробовать добавить индексы для запроса по полям, по которым идет фильтрация

До изменений "query_cost": "13559.75"

- Добавление индекса на города:

```
CREATE INDEX idx_address_city ON address(city);
```
После добавления индекса по address(city) "query_cost": "2602.90"

- Добавление индекса на UnitPrice

```
CREATE INDEX idx_salesorderdetail_UnitPrice ON salesorderdetail(UnitPrice);
```

После добавления индекса по salesorderdetail(UnitPrice) "query_cost": "1221.48"

- Замена условия поиска с year(soh.OrderDate) = '2002' на (soh.OrderDate between '2002-01-01 00:00:00' and '2002-12-31 23:59:59')

После изменения "query_cost": "416.30"

- Попробовал другие варианты оптимизации, например, добавление индекса по датам OrderDate, особо не помогло

#### Финальный  EXPLAIN

```
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "416.30"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "addr",
          "access_type": "ref",
          "possible_keys": [
            "PRIMARY",
            "idx_address_city"
          ],
          "key": "idx_address_city",
          "used_key_parts": [
            "City"
          ],
          "key_length": "92",
          "ref": [
            "const"
          ],
          "rows_examined_per_scan": 434,
          "rows_produced_per_join": 434,
          "filtered": "100.00",
          "using_index": true,
          "cost_info": {
            "read_cost": "5.85",
            "eval_cost": "43.40",
            "prefix_cost": "49.25",
            "data_read_per_join": "227K"
          },
          "used_columns": [
            "AddressID",
            "City"
          ],
          "attached_condition": "(`otus`.`addr`.`AddressID` is not null)"
        }
      },
      {
        "table": {
          "table_name": "soh",
          "access_type": "ref",
          "possible_keys": [
            "PRIMARY",
            "my_fk_53"
          ],
          "key": "my_fk_53",
          "used_key_parts": [
            "BillToAddressID"
          ],
          "key_length": "4",
          "ref": [
            "otus.addr.AddressID"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 84,
          "filtered": "11.11",
          "cost_info": {
            "read_cost": "190.30",
            "eval_cost": "8.46",
            "prefix_cost": "315.67",
            "data_read_per_join": "61K"
          },
          "used_columns": [
            "SalesOrderID",
            "OrderDate",
            "SalesOrderNumber",
            "AccountNumber",
            "BillToAddressID",
            "SubTotal"
          ],
          "attached_condition": "(`otus`.`soh`.`OrderDate` between '2002-01-01 00:00:00' and '2002-12-31 23:59:59')"
        }
      },
      {
        "table": {
          "table_name": "sod",
          "access_type": "ref",
          "possible_keys": [
            "my_fk_46",
            "idx_salesorderdetail_UnitPrice"
          ],
          "key": "my_fk_46",
          "used_key_parts": [
            "SalesOrderID"
          ],
          "key_length": "4",
          "ref": [
            "otus.soh.SalesOrderID"
          ],
          "rows_examined_per_scan": 3,
          "rows_produced_per_join": 98,
          "filtered": "34.21",
          "cost_info": {
            "read_cost": "71.88",
            "eval_cost": "9.84",
            "prefix_cost": "416.30",
            "data_read_per_join": "13K"
          },
          "used_columns": [
            "SalesOrderID",
            "ProductID",
            "UnitPrice",
            "ModifiedDate"
          ],
          "attached_condition": "(`otus`.`sod`.`UnitPrice` > 1000)"
        }
      }
    ]
  }
}
```

В итоге удалось оптимизировать запрос: "query_cost": "13559.75" -> "query_cost": "416.30"