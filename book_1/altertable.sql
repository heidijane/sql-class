ALTER TABLE vehicletypes
ADD CONSTRAINT FK_body_type
FOREIGN KEY (body_type) REFERENCES
vehiclebodytype(vehicle_body_type_id);

ALTER TABLE vehicletypes
ADD CONSTRAINT FK_make
FOREIGN KEY (make) REFERENCES
vehiclemake(vehicle_make_id);

ALTER TABLE vehicletypes
ADD CONSTRAINT FK_model
FOREIGN KEY (model) REFERENCES
vehiclemodel(vehicle_model_id);