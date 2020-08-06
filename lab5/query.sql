-- Создание таблиц для импорта данных

CREATE TABLE IF NOT EXISTS `lab5`.`hotel` 
(
  `id_hotel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL DEFAULT '',
  `stars` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_hotel`)
 )
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab5`.`room_category` 
(
  `id_room_category` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL DEFAULT '',
  `square` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_room_category`)
 )
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab5`.`room` 
(
  `id_room` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_hotel` INT UNSIGNED NOT NULL,
  `id_room_category`INT UNSIGNED NOT NULL,
  `number` VARCHAR(10) NOT NULL DEFAULT 0,
  `price` DECIMAL(7, 2) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_room`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab5`.`client`
(
  `id_client` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id_client`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab5`.`booking` 
(
  `id_booking` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_client` INT UNSIGNED NOT NULL,
  `booking_date` DATE NOT NULL,
  PRIMARY KEY (`id_booking`)
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab5`.`room_in_booking` 
(
  `id_room_in_booking` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_booking` INT UNSIGNED NOT NULL,
  `id_room` INT UNSIGNED NOT NULL,
  `checkin_date` DATE NOT NULL,
  `checkout_date` DATE NOT NULL,
  PRIMARY KEY (`id_room_in_booking`)
)
ENGINE = InnoDB;

-- 1. Добавить внешние ключи.

ALTER TABLE lab5.room
ADD CONSTRAINT fk_room_hotel FOREIGN KEY (id_hotel) REFERENCES lab5.hotel (id_hotel);

ALTER TABLE lab5.room
ADD CONSTRAINT fk_room_room_category FOREIGN KEY (id_room_category) REFERENCES lab5.room_category (id_room_category);

ALTER TABLE lab5.booking
ADD CONSTRAINT fk_booking_client FOREIGN KEY (id_client) REFERENCES lab5.client (id_client);

ALTER TABLE lab5.room_in_booking
ADD CONSTRAINT fk_room_in_booking_booking FOREIGN KEY (id_booking) REFERENCES lab5.booking (id_booking);

ALTER TABLE lab5.room_in_booking
ADD CONSTRAINT fk_room_in_booking_room FOREIGN KEY (id_room) REFERENCES lab5.room (id_room);


-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах
--    категории “Люкс” на 1 апреля 2019г.

SELECT c.*
FROM
  lab5.room_in_booking rib
  INNER JOIN lab5.room r ON rib.id_room = r.id_room
  INNER JOIN lab5.room_category rc ON r.id_room_category = rc.id_room_category
  INNER JOIN lab5.hotel h ON r.id_hotel = h.id_hotel
  INNER JOIN lab5.booking b ON rib.id_booking = b.id_booking
  INNER JOIN lab5.client c ON b.id_client = c.id_client
WHERE
  h.name = 'Космос'
  AND rc.name = 'Люкс'
  AND rib.checkin_date <= '2019-04-01'
  AND rib.checkout_date > '2019-04-01'
;


-- 3. Дать список свободных номеров всех гостиниц на 22 апреля.

SELECT
  h.name hotel_name,
  h.stars hotel_stars,
  r.number room_number,
  rc.name room_category,
  rc.square room_square,
  r.price
FROM
  lab5.hotel h
  INNER JOIN lab5.room r ON h.id_hotel = r.id_hotel
  INNER JOIN lab5.room_category rc ON r.id_room_category = rc.id_room_category
WHERE
  r.id_room NOT IN 
  (
    SELECT rib.id_room
    FROM
      lab5.room_in_booking rib
    WHERE
      rib.checkin_date <= '2019-04-22'
      AND rib.checkout_date > '2019-04-22'
  )
ORDER BY 1, 4;
;


-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой
--    категории номеров

SELECT
  rc.name room_category,
  COUNT(DISTINCT c.id_client) clients_count
FROM
  lab5.room_in_booking rib
  INNER JOIN lab5.room r ON rib.id_room = r.id_room
  INNER JOIN lab5.room_category rc ON r.id_room_category = rc.id_room_category
  INNER JOIN lab5.hotel h ON r.id_hotel = h.id_hotel
  INNER JOIN lab5.booking b ON rib.id_booking = b.id_booking
  INNER JOIN lab5.client c ON b.id_client = c.id_client
WHERE
  h.name = 'Космос'
  AND rib.checkin_date <= '2019-03-23'
  AND rib.checkout_date > '2019-03-23'
GROUP BY rc.name
ORDER BY 1
;



-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы
--    “Космос”, выехавшим в апреле с указанием даты выезда.

SELECT c.name, rib.checkout_date 
FROM
  lab5.room_in_booking rib
  INNER JOIN lab5.room r ON rib.id_room = r.id_room
  INNER JOIN lab5.room_category rc ON r.id_room_category = rc.id_room_category
  INNER JOIN lab5.hotel h ON r.id_hotel = h.id_hotel
  INNER JOIN lab5.booking b ON rib.id_booking = b.id_booking
  INNER JOIN lab5.client c ON b.id_client = c.id_client
WHERE
  h.name = 'Космос'
  AND rib.checkout_date >= '2019-04-1'
  AND rib.checkout_date < '2019-05-1'
ORDER BY 2;
;
  

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам
--    комнат категории “Бизнес”, которые заселились 10 мая.


UPDATE
  lab5.room_in_booking rib
  INNER JOIN lab5.room r ON r.id_room = rib.id_room
  INNER JOIN lab5.hotel h ON h.id_hotel = r.id_hotel
  INNER JOIN lab5.room_category rc ON rc.id_room_category = r.id_room_category
SET
  rib.checkout_date = DATE_ADD(rib.checkout_date, INTERVAL 2 DAY)
WHERE
  h.name = 'Космос'
  AND rc.name = 'Бизнес'
  AND rib.checkin_date = '2019-05-10'
;


-- 7. Найти все "пересекающиеся" варианты проживания. Правильное состояние: не
--    может быть забронирован один номер на одну дату несколько раз, т.к. нельзя
--    заселиться нескольким клиентам в один номер. Записи в таблице
--    room_in_booking с id_room_in_booking = 5 и 2154 являются примером
--    неправильного состояния, которые необходимо найти. Результирующий кортеж
--    выборки должен содержать информацию о двух конфликтующих номерах.

SELECT
  rib.id_room_in_booking,
  rib.id_booking,
  rib.id_room,
  rib.checkin_date,
  rib.checkout_date,
  rib_copy_data_match.id_room_in_booking,
  rib_copy_data_match.id_booking,
  rib_copy_data_match.id_room,
  rib_copy_data_match.checkin_date,
  rib_copy_data_match.checkout_date
FROM
  room_in_booking rib
  INNER JOIN room_in_booking rib_copy_data_match ON 
  (
    rib.id_room = rib_copy_data_match.id_room
    AND rib.id_room_in_booking <> rib_copy_data_match.id_room_in_booking
    AND rib_copy_data_match.checkin_date BETWEEN rib.checkin_date AND rib.checkout_date + INTERVAL '-1' DAY
  )
;


-- 8. Создать бронирование в транзакции.


BEGIN;

INSERT INTO lab5.client (name, phone)
VALUES ('Иван Васильечич Грочный', '7(666)222-11-00');

INSERT INTO lab5.booking (id_client, booking_date)
VALUES ((SELECT id_client FROM lab5.client ORDER BY 1 DESC LIMIT 1), '2020-07-31');

INSERT INTO lab5.room_in_booking (id_booking, id_room, checkin_date, checkout_date)
VALUES ((SELECT booking.id_booking FROM lab5.booking ORDER BY 1 DESC LIMIT 1), 1, '2020-08-01', '2020-08-14');

COMMIT;


-- 9. Добавить необходимые индексы для всех таблиц.

CREATE INDEX IX_room_id_hotel ON lab5.room(id_hotel);
CREATE INDEX IX_room_id_room_category ON lab5.room(id_room_category);
CREATE INDEX IX_client_phone ON lab5.client(phone);
CREATE INDEX iX_room_in_booking_id_booking ON lab5.room_in_booking(id_booking);
CREATE INDEX IX_room_in_booking_id_room ON lab5.room_in_booking(id_room);
CREATE INDEX IX_room_in_booking_checkin_date_checkout_date ON lab5.room_in_booking(checkin_date, checkout_date);