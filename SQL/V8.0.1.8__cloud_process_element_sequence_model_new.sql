DELETE FROM ModelInstance WHERE Id = '471d0caf-9661-4193-abfd-50bf78ede9a4';
DELETE FROM TrainSession WHERE Id = 'c6aca289-304a-49b9-835b-1054d2b1cf9a';

INSERT INTO TrainSession (Id, CreatedOn, State, ProblemType, ApiKey, ModelSchemaId, ModelSchemaMetadata, StateChangedOn, LastError) VALUES
('c6aca289-304a-49b9-835b-1054d2b1cf9a', '2042-01-30 19:03:45', 'Done', 'SequencePrediction', '35LRJ5fWnnI9oZGr5k87gdH0LXziuJaCt6fliwEj', 'b624f2fd-81e1-4e8d-890b-5184994d1154', '{"inputs":[{"type":"Lookup","isRequired":false,"isIgnored":false,"name":"SequenceId"},{"type":"Numeric","isRequired":false,"isIgnored":false,"name":"Position"},{"type":"Text","isRequired":false,"isIgnored":false,"name":"Value"}],"output":{"type":"Numeric","name":"Output__"}}', '2022-01-30 19:46:11', NULL);


INSERT INTO ModelInstance
(Id, CreatedOn, TrainSessionId, IsActive, TrainingTimeMinutes, TrainSetSize, ModelMetric, ModelMetricType, ModelData, ModelSummary, FeatureImportance, XgbData, Version)

