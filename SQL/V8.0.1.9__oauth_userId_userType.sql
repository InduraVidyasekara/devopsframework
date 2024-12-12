DROP PROCEDURE IF EXISTS Alter_Table;

DELIMITER $$
CREATE PROCEDURE Alter_Table()
BEGIN
	IF NOT EXISTS(SELECT NULL
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE table_name = 'TrainSession'
				AND table_schema = database()
				AND column_name = 'UserId')  THEN

		ALTER TABLE TrainSession
		RENAME COLUMN ApiKey to UserId,
		ADD COLUMN UserType char(100);

		ALTER TABLE PredictionSummary
		RENAME COLUMN ApiKey to UserId,
		ADD COLUMN UserType char(100);

	END IF;
END $$
DELIMITER ;

CALL Alter_Table();

DROP PROCEDURE Alter_Table;

