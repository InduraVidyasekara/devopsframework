CREATE TABLE IF NOT EXISTS Prediction (
    Id bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    StartTime datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    EndTime datetime(3) DEFAULT NULL,
    ModelInstanceId varchar(50) NOT NULL,
    Error varchar(1000) DEFAULT NULL,
    PRIMARY KEY (Id),
    UNIQUE INDEX UK_Prediction_Id (Id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

-- Add indexes
ALTER TABLE Prediction
ADD INDEX IDX_Prediction_ModelInstanceId (ModelInstanceId);

ALTER TABLE Prediction
ADD INDEX IDX_Prediction_StartTime (StartTime);

-- Safely drop the foreign key if it exists
SET @FK_NAME = (
    SELECT CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_NAME = 'Prediction'
      AND TABLE_SCHEMA = DATABASE()
      AND CONSTRAINT_NAME = 'ml/FK_Prediction_ModelInstanceId'
);

-- Only drop if @FK_NAME is not NULL
SET @QUERY = IF(@FK_NAME IS NOT NULL, CONCAT('ALTER TABLE Prediction DROP FOREIGN KEY ', @FK_NAME), 'SELECT "Foreign key does not exist"');
PREPARE stmt FROM @QUERY;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add the foreign key constraint
ALTER TABLE Prediction
ADD CONSTRAINT FK_Prediction_ModelInstanceId FOREIGN KEY (ModelInstanceId)
REFERENCES ModelInstance (Id) ON DELETE CASCADE ON UPDATE CASCADE;
