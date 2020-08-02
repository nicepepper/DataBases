-- 7. Склады, товары, товары на складах.

CREATE DATABASE IF NOT EXISTS lab4 CHARACTER SET utf8 COLLATE utf8_general_ci;

drop table lab4.warehouse;
drop table lab4.price;
drop table lab4.product_availability;
drop table lab4.product;

create table if not exists `lab4`.`warehouse` (
  `id_warehouse` int unsigned not null auto_increment,
  `name` varchar(150) not null,
  `description` varchar(255) not null,
  `country` varchar(100) not null,
  `city` varchar(100) not null,
  `address` varchar(255) not null,
  `phone_number` varchar(20) not null,
  `opening_at` time not null,
  `closing_at` time not null,
  primary key (`id_warehouse`))
engine = InnoDB;

create table if not exists `lab4`.`product` (
  `id_product` int unsigned not null auto_increment,
  `name` varchar(255) not null,
  `description` text not null,
  `producter` varchar(255) not null,
  `storage_conditions` text not null,
  `register_sing` varchar(100) not null,
  primary key (`id_product`))
engine = InnoDB;

create table if not exists `lab4`.`price` (
  `id_price` int unsigned not null auto_increment,
  `id_warehouse` int unsigned not null,
  `create_price_at` DATETIME not null default now(),
  `update_price_at` DATETIME,
  primary key (`id_price`))
engine = InnoDB;

create table if not exists `lab4`.`product_availability` (
  `id_product_availability` int unsigned not null auto_increment,
  `id_price` int unsigned not null,
  `id_product` int unsigned not null,
  `retail_price` int unsigned not null default 0,
  `wholesale_discount` tinyint not null default 0,
  `wholesale_description` text not null,
  `quantity` int unsigned default 0,
  primary key (`id_product_availability`))
engine = InnoDB;


-- 1. INSERT

insert into lab4.warehouse
values
  (default,'КЛАДКА', 'сеть складов строительных материалов', 'Россия', 'Йошкар-Ола', 'ул. Баумана, 102', '8 (836) 231-32-13', '10:00', '20:00'),
  (default,'Игрушки и сувениры', 'Игрушки для детей', 'Россия', 'Йошкар-Ола', 'ул. Суворова, 9', '8 (836) 279-83-95', '09:00', '18:00'),
  (default,'Строительный Мир', 'Оптово-розничный Склад', 'Россия', 'Йошкар-Ола', 'ул. Баумана, 100', '8 (836) 273-35-91', '09:00', '18:00')
;

insert into lab4.product (name, description, producter, storage_conditions, register_sing)
values
  ('Профнастил С-10 оцинкованно-окрашенный 6000*1150*0,5мм, "Зеленый мох"', 'Профнастил можно смело назвать кровельным материалом будущего, благодаря его долговечности и надёжности.', 'ЧЗПСН-Профнастил', 'Пряфмая поверхность, не влажное помещение', '0072233'),
  ('Профнастил С-21 оцинкованно-окрашенный 6000*1050*0,5мм, "Красное вино"' , 'Профнастил можно смело назвать кровельным материалом будущего, благодаря его долговечности и надёжности.', 'ЧЗПСН-Профнастил', 'Пряфмая поверхность, не влажное помещение', '0072235'),
  ('Конструктор LEGO Harry Potter Большой зал Хогвартса' , 'Загадочную, наполненную чудесами атмосферу школы волшебников великолепно передает конструктор LEGO "Большой зал Хогвартса"', 'LEGO Group', 'Особых требований нет', '75954'),
  ('Конструктор LEGO BOOST Набор для конструирования и программирования', 'Конструктор - это интересно, но собирать из него робота – потрясающе!', 'LEGO Group', 'Особых требований нет', '17101')
;

insert into lab4.price (id_warehouse, update_price_at)
values
 ( 
 (select id_warehouse from warehouse where name = 'КЛАДКА'),
 ( DATE_ADD(NOW(), INTERVAL 14 DAY))
 ),
 (
 (select id_warehouse from warehouse where name = 'Строительный Мир'),
 ( DATE_ADD(NOW(), INTERVAL 21 DAY))
 ),
 (
 (select id_warehouse from warehouse where name = 'Игрушки и сувениры'),
 (NOW())
 ) 
;

insert into lab4.product_availability (id_price, id_product, retail_price, wholesale_discount, wholesale_description, quantity)
values
(1,1, 23000, 13, 'Когда покупаеться более 100', 120),
(1,2, 30000, 10, 'Когда покупаеться более 50', 5000),
(2,1, 26000, 10, 'Когда покупаеться более 100', 6000),
(2,2, 28000, 16, 'Когда покупаеться более 50', 10000),
(3, 3, 3500, 14, 'Когда покупаеться более 10', 100),
(3, 4, 6000, 10, 'Когда покупаеться более 10', 70)
;


-- 2. DELETE

DELETE FROM lab4.product_availability;

DELETE FROM lab4.product WHERE name LIKE 'Профнастил%';

TRUNCATE TABLE lab4.product_availability;


-- 3. UPDATE

UPDATE lab4.price SET update_price_at = NOW();

UPDATE lab4.product_availability
SET retail_price = 30000
WHERE id_price = 1 AND id_product = 1; 

UPDATE	lab4.product_availability
SET retail_price = 29950, wholesale_discount = 11
WHERE  retail_price = 30000; 
 
 
 -- 4. SELECT

SELECT name,  description 
FROM product;

SELECT * FROM product;

SELECT * FROM product
WHERE name LIKE '%Профнастил%';


-- 5. SELECT ORDER BY + TOP (LIMIT)

SELECT pa.id_price, p.name,  p.description
FROM product p
INNER JOIN product_availability pa ON pa.id_product = p.id_product
GROUP BY p.name ASC
LIMIT 3;

SELECT name, description
FROM product
GROUP BY product.name DESC;

SELECT producter, name
FROM product
GROUP BY product.producter, product.name
LIMIT 5;

SELECT product.name, product.description
FROM product
GROUP BY 1 DESC LIMIT 3;


-- 6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.

SELECT *
FROM price 
WHERE price.update_price_at < NOW();

SELECT *
FROM price
WHERE YEAR(price.create_price_at) = 2020;

-- 7. SELECT GROUP BY с функциями агрегации

SELECT MIN(pv.retail_price), MAX(pv.retail_price)
FROM product_availability pv
WHERE pv.retail_price > 0;


SELECT  p.name, AVG(pv.retail_price)
FROM product_availability pv
INNER JOIN product p ON pv.id_product = p.id_product
WHERE p.name LIKE '%Зеленый мох%';

SELECT SUM(pv.quantity)
FROM product_availability pv
INNER JOIN product p ON pv.id_product = p.id_product
WHERE p.name LIKE '%Профнастил%';

SELECT COUNT(pv.id_product)
FROM product_availability pv
INNER JOIN product p ON pv.id_product = p.id_product
WHERE p.name LIKE '%Профнастил%';


-- 8. SELECT GROUP BY + HAVING

SELECT w.name AS warehouse_name , SUM(pa.quantity) AS product_quantity
FROM warehouse w 
INNER JOIN price p ON p.id_warehouse = w.id_warehouse
INNER JOIN product_availability pa ON pa.id_price = p.id_price
INNER JOIN product pd ON pd.id_product = pa.id_product
GROUP BY w.name;

SELECT w.name AS warehouse_name , SUM(pa.quantity) AS product_quantity
FROM warehouse w 
INNER JOIN price p ON p.id_warehouse = w.id_warehouse
INNER JOIN product_availability pa ON pa.id_price = p.id_price
INNER JOIN product pd ON pd.id_product = pa.id_product
GROUP BY w.name
HAVING SUM(pa.quantity) > 5000
ORDER BY 2 DESC;

SELECT w.name AS warehouse_name , MAX(pa.quantity) AS product_quantity
FROM warehouse w 
INNER JOIN price p ON p.id_warehouse = w.id_warehouse
INNER JOIN product_availability pa ON pa.id_price = p.id_price
GROUP BY w.name
ORDER BY 2 DESC;


-- 9. SELECT JOIN

SELECT DISTINCT price.id_price, product_availability.id_product
FROM price 
LEFT JOIN product_availability USING(id_price)
WHERE product_availability.retail_price > 25000 AND price.id_price = 1;

SELECT DISTINCT pa.id_price, p.name, p.description
FROM product_availability pa
RIGHT JOIN product p USING(id_product)
ORDER BY 2 ASC
LIMIT 3;

SELECT w.name AS warehouse_name, pa.quantity AS product_quantity
FROM warehouse w 
LEFT JOIN price p ON p.id_warehouse = w.id_warehouse
LEFT JOIN product_availability pa ON pa.id_price = p.id_price
WHERE w.address = 'ул. Баумана, 102' AND p.id_price = 1 AND pa.quantity > 3000;

SELECT *
FROM product
LEFT JOIN product_availability USING(id_product)
UNION 
SELECT *
FROM product
RIGHT JOIN product_availability USING(id_product);


-- 10. Подзапросы

SELECT w.name AS warehouse_name, pa.quantity AS product_quantity
FROM warehouse w 
INNER JOIN price p ON p.id_warehouse = w.id_warehouse
INNER JOIN product_availability pa ON pa.id_price = p.id_price
INNER JOIN product pd ON pd.id_product = pa.id_product 
WHERE pd.id_product IN
(
SELECT pd.id_product
FROM product pd
WHERE pd.name LIKE '%Профнастил%'
);

SELECT SUM(pa.quantity)
FROM product_availability pa
INNER JOIN price p ON p.id_price = pa.id_price
WHERE price.id_warehouse = warehouse.id_warehouse;


SELECT 
w.name AS warehouse_name, 
(
SELECT SUM(pa.quantity)
FROM price p
INNER JOIN product_availability pa ON p.id_price = pa.id_price
WHERE p.id_warehouse = w.id_warehouse
) AS quantity_of_goods
FROM warehouse w
ORDER BY quantity_of_goods DESC; 