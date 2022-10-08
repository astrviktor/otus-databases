## Выполнение домашнего задания

#### 1. Установить xtrabackup

https://docs.percona.com/percona-xtrabackup/8.0/installation/apt_repo.html

#### 2. Расшифровать архив с бэкапом базы

```
openssl des3 -d -in backup_des.xbstream.gz.des3 -out backup_des.xbstream.gz -k "password"
```

#### 3. Восстановить данные

```
gzip -d backup_des.xbstream.gz 
xbstream -x < backup_des.xbstream

mysql -uroot world < /home/astrviktor/otus-databases/hw16/data/world_db.sql

mysql -uroot world -e "alter table city discard tablespace;"

sudo cp world/city.ibd /var/lib/mysql/world
sudo chown -R mysql.mysql /var/lib/mysql/world/city.ibd

mysql -uroot world -e "alter table city import tablespace;"
```

#### 4. Посчитать количество

```
mysql> select count(*) from city where countrycode = 'RUS';
+----------+
| count(*) |
+----------+
|      189 |
+----------+
1 row in set (0,00 sec)
```
