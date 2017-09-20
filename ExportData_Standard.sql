SET @table_schema = 'testdata';
SET @table_name = 'productdata';

SELECT * FROM ', @table_schema, '.', @table_name,' WHERE line = "standard";

/* SELECT * FROM testdata.productdata; */