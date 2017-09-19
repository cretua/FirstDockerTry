/* Change table_name, database_name 
SET @table_name = 'test_table';
SET @table_schema = 'sql8190040';

SELECT * FROM ', @table_schema, '.', @table_name, ' */
/*SELECT * FROM ', @table_schema, '.', @table_name, ' WHERE line = "standard"*/

SELECT * FROM testdata.productdata;
