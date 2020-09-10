create table vehicleBodyType (
  vehicle_body_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20)
);
create table vehicleModel (
  vehicle_model_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20)
);
create table vehicleMake (
  vehicle_make_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(20)
);