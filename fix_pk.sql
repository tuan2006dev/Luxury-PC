SET QUOTED_IDENTIFIER ON;
DECLARE @TableName NVARCHAR(256);
DECLARE @Sql NVARCHAR(MAX);

DECLARE TableCursor CURSOR FOR 
SELECT t.table_name 
FROM information_schema.tables t
JOIN information_schema.columns c ON t.table_name = c.table_name
WHERE t.table_type = 'BASE TABLE' AND c.column_name = 'id'
AND NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints tc 
    WHERE tc.table_name = t.table_name 
    AND tc.constraint_type = 'PRIMARY KEY'
);

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Remove duplicates
    SET @Sql = 'WITH CTE AS (SELECT id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY (SELECT NULL)) as rn FROM [' + @TableName + ']) DELETE FROM CTE WHERE rn > 1;';
    PRINT 'Removing duplicates for ' + @TableName;
    EXEC sp_executesql @Sql;

    -- Add Primary Key
    SET @Sql = 'ALTER TABLE [' + @TableName + '] ADD CONSTRAINT PK_' + @TableName + ' PRIMARY KEY (id);';
    PRINT 'Adding PK for ' + @TableName;
    EXEC sp_executesql @Sql;

    FETCH NEXT FROM TableCursor INTO @TableName;
END

CLOSE TableCursor;
DEALLOCATE TableCursor;
