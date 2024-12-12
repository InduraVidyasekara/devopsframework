UPDATE TrainSession
SET UserType = 'ApiKey'
WHERE IFNULL(UserType, '') = '' AND IFNULL(UserId, '') <> '';

UPDATE PredictionSummary
SET UserType = 'ApiKey'
WHERE IFNULL(UserType, '') = '' AND IFNULL(UserId, '') <> '';
