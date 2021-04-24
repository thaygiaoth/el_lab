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

-- tăng tốc độ lên 2x, 3x khi tắt binlog
-- chỉ ăn trong phiên làm việc (session) hiện tại
SET sql_log_bin=off;

-- Muốn tắt hoàn toàn binlog thì phải
-- /etc/my.cnf
-- [mysqld]
-- disable_log_bin
-- sau đó systemctl restart mysqld
               
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

-- Các bạn tải file CSV chứa 1 tỷ dòng ở đây, đỡ tốn tiền điện chạy 4-5 ngày
-- https://www.mediafire.com/folder/8udqydmaqlxi5/db_1tydong                                                                 
