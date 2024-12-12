CREATE TABLE IF NOT EXISTS AccountLimits (
	UserId varchar(100) NOT NULL,
	UserType varchar(20) NOT NULL,
	MonthPredictionsLimit integer NOT NULL,
	MonthTrainingDurationMinutesLimit integer NOT NULL,
	PRIMARY KEY (UserId)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;