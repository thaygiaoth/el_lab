DROP DATABASE IF EXISTS thờigian;

CREATE SCHEMA thờigian DEFAULT CHARACTER SET utf8mb4;

-- database = schema

USE thờigian;

CREATE TABLE dòngthờigian (
  số BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  trôiqua VARCHAR(26) NOT NULL,
  PRIMARY KEY (số))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

SET sql_log_bin=off;

DELIMITER //
CREATE PROCEDURE thờigian()   
BEGIN
DECLARE i INT DEFAULT 1;
WHILE (i) DO
    INSERT INTO dòngthờigian (trôiqua) values (current_timestamp(6));
END WHILE;
END
//

DELIMITER //
CREATE PROCEDURE killthờigian()
BEGIN
  DECLARE tiếntrình SMALLINT;
  SELECT id INTO tiếntrình FROM information_schema.processlist 
  WHERE info='INSERT INTO dòngthờigian (trôiqua) values (current_timestamp(6))';
  KILL tiếntrình;
END
//

DELIMITER ;

-- chạy file sql
-- mysql -uroot -p'password' < 1tydong.sql

-- sinh ra 1 tỷ dòng --> mấy ngày à nhen
-- mysql -uroot -p'password' -e 'use thờigian; call thờigian'

-- mở 1 terminal khác, đếm xem có bi nhiêu dòng roài
-- mysql -uroot -p'password' -e 'use thờigian; select count(1) from dòngthờigian'

-- sợ chạy lâu tốn điện quá thì mở 1 terminal khác
-- mysql -uroot -p'password' -e 'use thờigian; call killthờigian'