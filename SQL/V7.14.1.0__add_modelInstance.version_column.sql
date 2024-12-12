DROP PROCEDURE IF EXISTS Alter_Table;

DELIMITER $$
CREATE PROCEDURE Alter_Table()
BEGIN
	IF NOT EXISTS( SELECT NULL
			  FROM INFORMATION_SCHEMA.COLUMNS
			 WHERE table_name = 'ModelInstance'
			   AND table_schema = database()
			   AND column_name = 'Version')	 THEN

	ALTER TABLE ModelInstance
	  ADD COLUMN `Version` decimal(4, 2) DEFAULT 1.00 AFTER `XgbData`;

	END IF;
END $$
DELIMITER ;

CALL Alter_Table();

DROP PROCEDURE Alter_Table;
