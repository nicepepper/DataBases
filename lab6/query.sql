-- Создание таблиц для импорта данных

CREATE TABLE IF NOT EXISTS lab6.company
(
  id_company INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL DEFAULT '',
  established INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_company)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS lab6.dealer
(
  id_dealer INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_company INT UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL DEFAULT '',
  phone VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id_dealer)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS lab6.medicine
(
  id_medicine INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL DEFAULT '',
  cure_duration SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id_medicine)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS lab6.order
(
  id_order INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_production INT UNSIGNED NOT NULL,
  id_dealer INT UNSIGNED NOT NULL,
  id_pharmacy INT UNSIGNED NOT NULL,
  date DATE NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_order)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS lab6.pharmacy
(
  id_pharmacy INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL DEFAULT '',
  rating  FLOAT NULL,
  PRIMARY KEY (id_pharmacy)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS lab6.production
(
  id_production INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_company INT UNSIGNED NOT NULL,
  id_medicine INT UNSIGNED NOT NULL,
  price NUMERIC(10, 2) NOT NULL DEFAULT 0,
  rating SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id_production)
)
ENGINE = InnoDB;


-- 1. Добавить внешние ключи.

ALTER TABLE lab6.dealer
ADD CONSTRAINT fk_dealer_company FOREIGN KEY (id_company) REFERENCES lab6.company (id_company);

ALTER TABLE lab6.order
ADD CONSTRAINT fk_order_production FOREIGN KEY (id_production) REFERENCES lab6.production (id_production);

ALTER TABLE lab6.order
ADD CONSTRAINT fk_order_dealer FOREIGN KEY (id_dealer) REFERENCES lab6.dealer (id_dealer);

-- Error Code: 1215. Cannot add foreign key constraint
-- ALTER TABLE lab6.pharmacy MODIFY id_pharmacy INT UNSIGNED NOT NULL AUTO_INCREMENT;
-- тут не идентично определил столбец пришлось переписвыть, ну оставил просто как пример
ALTER TABLE `lab6`.`order`
ADD CONSTRAINT `fk_order_pharmacy` FOREIGN KEY (`id_pharmacy`) REFERENCES `lab6`.`pharmacy` (`id_pharmacy`); 

ALTER TABLE lab6.production
ADD CONSTRAINT fk_production_company FOREIGN KEY (id_company) REFERENCES lab6.company (id_company);

ALTER TABLE lab6.production
ADD CONSTRAINT fk_production_medicine FOREIGN KEY (id_medicine) REFERENCES lab6.medicine (id_medicine);


-- 2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с
--    указанием названий аптек, дат, объема заказов.

SELECT
  ph.name pharmacy,
  o.date,
  o.quantity,
  p.price,
  o.quantity * p.price total
FROM
  lab6.order o
  INNER JOIN lab6.production p ON o.id_production = p.id_production
  INNER JOIN lab6.company c ON p.id_company = c.id_company
  INNER JOIN lab6.medicine m ON p.id_medicine = m.id_medicine
  INNER JOIN lab6.pharmacy ph ON o.id_pharmacy = ph.id_pharmacy
WHERE
  c.name = 'Аргус'
  AND m.name = 'Кордеон'
;


-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы
--    до 25 января.

SELECT
  m.name medicine,
  p.price
FROM
  lab6.company c
  INNER JOIN lab6.production p ON c.id_company = p.id_company
  INNER JOIN lab6.medicine m ON p.id_medicine = m.id_medicine
WHERE
  c.name = 'Фарма'
  AND p.id_production NOT IN 
  (
    SELECT o.id_production
    FROM lab6.order o 
    WHERE o.date < '2019-01-25'
  )
;


-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
--    оформила не менее 120 заказов.

SELECT
  c.name company_name,
  MIN(p.rating) min_prod_rating,
  MAX(p.rating) max_prod_rating
FROM
  lab6.order o
  INNER JOIN lab6.production p ON o.id_production = p.id_production
  INNER JOIN lab6.company c ON p.id_company = c.id_company
GROUP BY c.id_company, c.name
HAVING COUNT(DISTINCT o.id_order) >= 120
;


-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
--    Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT
  d.name dealer_name,
  d.phone dealer_phone,
  r.pharmacy_name
FROM
  lab6.dealer d
  INNER JOIN company c ON d.id_company = c.id_company
  LEFT JOIN 
  (
    SELECT
      o.id_dealer,
      ph.name pharmacy_name
    FROM
      lab6.order o
      INNER JOIN lab6.pharmacy ph ON o.id_pharmacy = ph.id_pharmacy
  ) r ON d.id_dealer = r.id_dealer
WHERE
  c.name = 'AstraZeneca'
;


-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
--    длительность лечения не более 7 дней.

UPDATE
  lab6.production p
  INNER JOIN lab6.medicine m ON p.id_medicine = m.id_medicine
SET 
  price = price * 0.8
WHERE
  p.price > 3000
  AND m.cure_duration <= 7
;


-- 7. Добавить необходимые индексы.
CREATE INDEX IX_dealer_id_company ON lab6.dealer(id_company);
CREATE INDEX IX_order_id_production ON lab6.order(id_production);
CREATE INDEX IX_order_id_dealer ON lab6.order(id_dealer);
CREATE INDEX IX_order_id_pharmacy ON lab6.order(id_pharmacy);
CREATE INDEX IX_order_date ON lab6.order(date);
CREATE INDEX IX_production_id_company ON lab6.production(id_company);
CREATE INDEX IX_production_id_medicine ON lab6.production(id_medicine);
CREATE INDEX IX_production_price ON lab6.production(price);
CREATE INDEX IX_medicine_cure_duration ON lab6.medicine(cure_duration);


