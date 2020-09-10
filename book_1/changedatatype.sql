ALTER TABLE vehicletypes 
ALTER COLUMN make TYPE INT USING make::integer;

ALTER TABLE vehicletypes 
ALTER COLUMN model TYPE INT USING model::integer;