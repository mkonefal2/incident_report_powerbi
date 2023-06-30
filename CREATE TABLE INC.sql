create database DA_INC
use DA_INC

CREATE TABLE INC (
  Number VARCHAR(10) NOT NULL,
  Status VARCHAR(20) NOT NULL,
  Site VARCHAR(20) NOT NULL,
  Priority VARCHAR(1) NOT NULL,
  Owner VARCHAR(50),
  Summary VARCHAR(100) NOT NULL,
  Reported_Date DATETIME,
  Target_Finish DATETIME,
  Actual_Start DATETIME,
  Actual_Finish DATETIME
);






INSERT INTO INC (Number, Status, Site, Priority, Owner, Summary, Reported_Date, Target_Finish, Actual_Start, Actual_Finish)
SELECT CONCAT('INC', LPAD(FLOOR(RAND() * 99999) + 1, 5, '0')), 
       ELT(1 + FLOOR(RAND() * 3), 'INPROGRESS', 'RESOLVED', 'OPENED'), 
       ELT(1 + FLOOR(RAND() * 4), 'EMEA', 'US', 'AFRICA', 'ASIA'), 
       CASE WHEN RAND() < 0.02 THEN 1 ELSE FLOOR(RAND() * 2) + 2 END,
       ELT(1 + FLOOR(RAND() * 6), IF(RAND() < 0.4,'Michael Bane','Rose Donnelly'), 'Lacy Goodwin', 'John Dare', 'Daniel Way', 'Joe Doe'),
       CONCAT(ELT(1 + FLOOR(RAND() * 4), 'EMEA', 'US', 'AFRICA', 'ASIA'), '_', ELT(1 + FLOOR(RAND() * 6), 'LINVM1', 'LINVM2', 'LINVM3', 'WINVM1', 'WINVM2', 'WINVM3'), '_', ELT(1 + FLOOR(RAND() * 5), 'CPU', 'RAM', 'SWAP', 'DOWN', 'DISK')),
       DATE_ADD(DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 7) DAY), INTERVAL ROUND(RAND() * 86400) SECOND),
       DATE_ADD(DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 7) DAY), INTERVAL ROUND(RAND() * 86400) SECOND),
       DATE_ADD(DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 7) DAY), INTERVAL ROUND(RAND() * 86400) SECOND),
       DATE_ADD(DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 7) DAY), INTERVAL ROUND(RAND() * 86400) SECOND)
FROM INFORMATION_SCHEMA.TABLES AS t1
CROSS JOIN INFORMATION_SCHEMA.TABLES AS t2
LIMIT 1569;







SET SQL_SAFE_UPDATES=0;
UPDATE INC SET Priority = 1 WHERE Summary LIKE '%DOWN%';
UPDATE INC SET Priority = FLOOR(RAND() * 2) + 2 WHERE Summary LIKE '%CPU%' OR Summary LIKE '%SWAP%' OR Summary LIKE '%DISK%';
UPDATE INC SET Owner = 'Rose Donnelly' WHERE Owner IS null;


UPDATE INC 
SET Target_Finish = 
    CASE 
        WHEN Priority = 3 THEN DATE_ADD(Reported_Date, INTERVAL 7 DAY)
        WHEN Priority = 2 THEN DATE_ADD(Reported_Date, INTERVAL 3 DAY)
        WHEN Priority = 1 THEN DATE_ADD(Reported_Date, INTERVAL 1 DAY)
    END;


UPDATE INC SET Actual_Start = Reported_Date + INTERVAL 1 DAY WHERE Actual_Start < Reported_Date;
UPDATE INC SET Actual_Finish = DATE_ADD(Actual_Start, INTERVAL FLOOR(RAND() * DATEDIFF(Actual_Start, NOW())) DAY);
UPDATE INC SET STATUS = 'INPROGRESS' WHERE STATUS = 'OPENED' LIMIT 400;
UPDATE INC SET OWNER  = NULL WHERE STATUS = 'OPENED';
UPDATE INC SET Actual_Start  = NULL WHERE STATUS = 'OPENED';
UPDATE INC SET Actual_Finish  = NULL WHERE STATUS = 'OPENED';