/* Change table_name, database_name, set the default concatenation limit and output file */
SET @table_name = 'test_table';
SET @table_schema = 'sql8190040';
SET @output_file = '/var/lib/mysql-files/output.csv';
SET @default_group_concat_max_len = (SELECT @@group_concat_max_len);

/* Sets Group Concat Max Limit larger for tables with a lot of columns */
SET SESSION group_concat_max_len = 1000000;

SET @col_names = (
  SELECT GROUP_CONCAT(QUOTE(`column_name`)) AS columns
  FROM information_schema.columns
  WHERE table_schema = @table_schema
  AND table_name = @table_name);
  
SET @cols = CONCAT('(SELECT ', @col_names, ')');


SET @query = CONCAT('(SELECT * FROM ', @table_schema, '.', @table_name,
  ' WHERE line = "standard" INTO OUTFILE \'/var/lib/mysql-files/output_remote.csv\'
  FIELDS ENCLOSED BY \'\\\'\' TERMINATED BY \'\t\' ESCAPED BY \'\'
  LINES TERMINATED BY \'\n\')');

  /*
SET @query = CONCAT('(SELECT * FROM ', @table_schema, '.', @table_name,
  ' INTO OUTFILE \'/var/lib/mysql-files/output.csv\')');
*/

/* 
SET @query = CONCAT('(SELECT * FROM ', @table_schema, '.', @table_name,
  ' INTO OUTFILE \'/var/lib/mysql-files/output.csv\'
  FIELDS ENCLOSED BY \'\\\'\' TERMINATED BY \'\t\' ESCAPED BY \'\'
  LINES TERMINATED BY \'\n\')');
*/
  
/* Concatenates column names to query */
SET @sql = CONCAT(@cols, ' UNION ALL ', @query);

/*SET @sql = CONCAT(@cols, ' UNION ALL ', @query); */

/* Resets Group Contact Max Limit back to original value */
SET SESSION group_concat_max_len = @default_group_concat_max_len;

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
