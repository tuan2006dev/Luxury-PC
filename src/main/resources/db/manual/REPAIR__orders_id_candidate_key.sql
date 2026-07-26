-- Run this script separately only when V2 reports that dbo.orders.id is not
-- backed by a PRIMARY KEY or UNIQUE candidate key.
--
-- This script never deletes or updates order data. It adds an unfiltered
-- UNIQUE constraint only after verifying that every id is non-null and unique.

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @orders_object_id INT = OBJECT_ID(N'dbo.orders', N'U');

    IF @orders_object_id IS NULL
        THROW 51100, N'dbo.orders does not exist.', 1;

    IF COL_LENGTH(N'dbo.orders', N'id') IS NULL
        THROW 51101, N'dbo.orders.id does not exist. Stop and reconcile the database schema with the application mapping.', 1;

    IF EXISTS (
        SELECT 1
        FROM sys.indexes i
        JOIN sys.index_columns first_key
          ON first_key.object_id = i.object_id
         AND first_key.index_id = i.index_id
         AND first_key.key_ordinal = 1
        JOIN sys.columns first_column
          ON first_column.object_id = first_key.object_id
         AND first_column.column_id = first_key.column_id
        WHERE i.object_id = @orders_object_id
          AND i.is_unique = 1
          AND i.is_disabled = 0
          AND i.is_hypothetical = 0
          AND i.has_filter = 0
          AND first_column.name = N'id'
          AND NOT EXISTS (
              SELECT 1
              FROM sys.index_columns additional_key
              WHERE additional_key.object_id = i.object_id
                AND additional_key.index_id = i.index_id
                AND additional_key.key_ordinal > 1
          )
    )
    BEGIN
        COMMIT TRANSACTION;
        PRINT N'dbo.orders.id already has a PRIMARY KEY or UNIQUE candidate key. No repair was needed.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.orders WHERE id IS NULL)
        THROW 51102, N'Cannot create a candidate key: dbo.orders.id contains NULL values. No data was changed.', 1;

    IF EXISTS (
        SELECT id
        FROM dbo.orders
        GROUP BY id
        HAVING COUNT_BIG(*) > 1
    )
        THROW 51103, N'Cannot create a candidate key: dbo.orders.id contains duplicate values. No data was changed.', 1;

    ALTER TABLE dbo.orders
        ADD CONSTRAINT uq_orders_id_vietqr_fk
        UNIQUE NONCLUSTERED (id);

    COMMIT TRANSACTION;
    PRINT N'Created UNIQUE candidate key uq_orders_id_vietqr_fk on dbo.orders.id.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
