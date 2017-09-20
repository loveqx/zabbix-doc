DELIMITER $$
CREATE PROCEDURE `partition_maintenance_all`(SCHEMA_NAME VARCHAR(32))
BEGIN
       CALL partition_maintenance(SCHEMA_NAME, 'history', 28, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_log', 28, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_str', 28, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_text', 28, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'history_uint', 28, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'trends', 730, 24, 14);
       CALL partition_maintenance(SCHEMA_NAME, 'trends_uint', 730, 24, 14);
END$$
DELIMITER ;
