-- Manual SQL Server migration for the ten-minute VietQR payment-session lifecycle.
-- The target and data type of order_id are derived from the live dbo.orders.id metadata.
-- Timestamps are stored in DATETIME2(3) with UTC semantics. Safe to rerun.

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @initial_transaction_count INT = @@TRANCOUNT;
DECLARE @started_transaction BIT = 0;

BEGIN TRY
    IF @initial_transaction_count = 0
    BEGIN
        BEGIN TRANSACTION;
        SET @started_transaction = 1;
    END
    ELSE
    BEGIN
        SAVE TRANSACTION v2_add_vietqr_payment_sessions;
    END;

    DECLARE @orders_object_id INT = OBJECT_ID(N'dbo.orders', N'U');

    IF @orders_object_id IS NULL
        THROW 51000, N'dbo.orders does not exist.', 1;

    DECLARE @orders_id_user_type_id INT;
    DECLARE @orders_id_max_length SMALLINT;
    DECLARE @orders_id_precision TINYINT;
    DECLARE @orders_id_scale TINYINT;
    DECLARE @orders_id_collation SYSNAME;
    DECLARE @orders_id_type_definition NVARCHAR(512);

    SELECT
        @orders_id_user_type_id = c.user_type_id,
        @orders_id_max_length = c.max_length,
        @orders_id_precision = c.precision,
        @orders_id_scale = c.scale,
        @orders_id_collation = c.collation_name,
        @orders_id_type_definition =
            CASE
                WHEN t.is_user_defined = 1
                    THEN QUOTENAME(SCHEMA_NAME(t.schema_id))
                         + N'.' + QUOTENAME(t.name)
                WHEN t.name IN (N'char', N'varchar', N'binary', N'varbinary')
                    THEN QUOTENAME(t.name)
                         + N'('
                         + CASE
                               WHEN c.max_length = -1 THEN N'MAX'
                               ELSE CONVERT(NVARCHAR(10), c.max_length)
                           END
                         + N')'
                WHEN t.name IN (N'nchar', N'nvarchar')
                    THEN QUOTENAME(t.name)
                         + N'('
                         + CASE
                               WHEN c.max_length = -1 THEN N'MAX'
                               ELSE CONVERT(NVARCHAR(10), c.max_length / 2)
                           END
                         + N')'
                WHEN t.name IN (N'decimal', N'numeric')
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.precision)
                         + N',' + CONVERT(NVARCHAR(10), c.scale) + N')'
                WHEN t.name IN (N'datetime2', N'datetimeoffset', N'time')
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.scale) + N')'
                WHEN t.name = N'float'
                    THEN QUOTENAME(t.name)
                         + N'(' + CONVERT(NVARCHAR(10), c.precision) + N')'
                ELSE QUOTENAME(t.name)
            END
            + CASE
                  WHEN c.collation_name IS NOT NULL
                      THEN N' COLLATE ' + QUOTENAME(c.collation_name)
                  ELSE N''
              END
    FROM sys.columns c
    JOIN sys.types t
      ON t.user_type_id = c.user_type_id
    WHERE c.object_id = @orders_object_id
      AND c.name = N'id';

    IF @orders_id_user_type_id IS NULL
        THROW 51001, N'dbo.orders.id does not exist.', 1;

    IF NULLIF(LTRIM(RTRIM(@orders_id_type_definition)), N'') IS NULL
        THROW 51005, N'Could not derive the SQL data type of dbo.orders.id.', 1;

    -- A foreign key may target a PRIMARY KEY or an unfiltered UNIQUE candidate
    -- key. The primary key may be composite; only a separate candidate key on
    -- dbo.orders.id itself matters here.
    IF NOT EXISTS (
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
        THROW 51002, N'dbo.orders.id is not a PRIMARY KEY or UNIQUE candidate key. Run REPAIR__orders_id_candidate_key.sql separately after reviewing its safety checks.', 1;
    END;

    IF OBJECT_ID(N'dbo.sepay_transactions', N'U') IS NULL
        THROW 51003, N'dbo.sepay_transactions does not exist.', 1;

    IF COL_LENGTH(N'dbo.sepay_transactions', N'transaction_date') IS NULL
    BEGIN
        EXEC sys.sp_executesql
            N'ALTER TABLE dbo.sepay_transactions
              ADD transaction_date DATETIME2(3) NULL;';
    END;

    DECLARE @payment_sessions_object_id INT =
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U');
    DECLARE @payment_sessions_schema_is_valid BIT = 0;

    IF @payment_sessions_object_id IS NOT NULL
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'id'
             AND t.name = N'bigint'
             AND c.is_identity = 1
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'order_id'
             AND c.user_type_id = @orders_id_user_type_id
             AND c.max_length = @orders_id_max_length
             AND c.precision = @orders_id_precision
             AND c.scale = @orders_id_scale
             AND ISNULL(c.collation_name, N'') =
                 ISNULL(@orders_id_collation, N'')
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'qr_created_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'qr_expires_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 0
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'paid_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 1
       )
       AND EXISTS (
           SELECT 1
           FROM sys.columns c
           JOIN sys.types t ON t.user_type_id = c.user_type_id
           WHERE c.object_id = @payment_sessions_object_id
             AND c.name = N'expired_at'
             AND t.name = N'datetime2'
             AND c.scale = 3
             AND c.is_nullable = 1
       )
       AND EXISTS (
           SELECT 1
           FROM sys.key_constraints kc
           JOIN sys.index_columns first_key
             ON first_key.object_id = kc.parent_object_id
            AND first_key.index_id = kc.unique_index_id
            AND first_key.key_ordinal = 1
           JOIN sys.columns first_column
             ON first_column.object_id = first_key.object_id
            AND first_column.column_id = first_key.column_id
           WHERE kc.parent_object_id = @payment_sessions_object_id
             AND kc.type = N'PK'
             AND first_column.name = N'id'
             AND NOT EXISTS (
                 SELECT 1
                 FROM sys.index_columns additional_key
                 WHERE additional_key.object_id = kc.parent_object_id
                   AND additional_key.index_id = kc.unique_index_id
                   AND additional_key.key_ordinal > 1
             )
       )
    BEGIN
        SET @payment_sessions_schema_is_valid = 1;
    END;

    IF @payment_sessions_object_id IS NOT NULL
       AND @payment_sessions_schema_is_valid = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.sepay_payment_sessions)
            THROW 51004, N'dbo.sepay_payment_sessions has an incompatible schema and contains data; refusing to drop it.', 1;

        DROP TABLE dbo.sepay_payment_sessions;
        SET @payment_sessions_object_id = NULL;
    END;

    IF OBJECT_ID(N'dbo.sepay_payment_sessions', N'U') IS NULL
    BEGIN
        DECLARE @create_payment_sessions_sql NVARCHAR(MAX) =
            N'CREATE TABLE dbo.sepay_payment_sessions (
                id BIGINT IDENTITY(1,1) NOT NULL
                    CONSTRAINT pk_sepay_payment_sessions PRIMARY KEY,
                order_id ' + @orders_id_type_definition + N' NOT NULL,
                qr_created_at DATETIME2(3) NOT NULL,
                qr_expires_at DATETIME2(3) NOT NULL,
                paid_at DATETIME2(3) NULL,
                expired_at DATETIME2(3) NULL
            );';

        EXEC sys.sp_executesql @create_payment_sessions_sql;
    END;

    SET @payment_sessions_object_id =
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U');

    IF @payment_sessions_object_id IS NULL
        THROW 51006, N'CREATE TABLE completed without creating dbo.sepay_payment_sessions.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc
          ON fkc.constraint_object_id = fk.object_id
        JOIN sys.columns parent_column
          ON parent_column.object_id = fkc.parent_object_id
         AND parent_column.column_id = fkc.parent_column_id
        JOIN sys.columns referenced_column
          ON referenced_column.object_id = fkc.referenced_object_id
         AND referenced_column.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id = @payment_sessions_object_id
          AND fkc.referenced_object_id = @orders_object_id
          AND parent_column.name = N'order_id'
          AND referenced_column.name = N'id'
    )
    BEGIN
        ALTER TABLE dbo.sepay_payment_sessions WITH CHECK
            ADD CONSTRAINT fk_sepay_payment_sessions_order
            FOREIGN KEY (order_id) REFERENCES dbo.orders(id);
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'idx_sepay_payment_sessions_order_created'
          AND object_id = @payment_sessions_object_id
    )
    BEGIN
        CREATE INDEX idx_sepay_payment_sessions_order_created
            ON dbo.sepay_payment_sessions (order_id, qr_created_at DESC);
    END;

    -- Backfill one deterministic session for existing VietQR orders without inventing a fresh ten-minute window.
    INSERT INTO dbo.sepay_payment_sessions (
        order_id,
        qr_created_at,
        qr_expires_at,
        paid_at,
        expired_at
    )
    SELECT
        o.id,
        CAST(o.created_at AS DATETIME2(3)),
        DATEADD(MINUTE, 10, CAST(o.created_at AS DATETIME2(3))),
        NULL,
        CASE
            WHEN o.status = N'CHO_XAC_NHAN_THANH_TOAN'
                 AND SYSUTCDATETIME() >= DATEADD(MINUTE, 10, CAST(o.created_at AS DATETIME2(3)))
                THEN SYSUTCDATETIME()
            ELSE NULL
        END
    FROM dbo.orders o
    WHERE o.payment_method = N'VIETQR'
      AND o.created_at IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.sepay_payment_sessions s
          WHERE s.order_id = o.id
      );

    IF OBJECT_ID(N'dbo.sepay_payment_sessions', N'U') IS NULL
        THROW 51007, N'Migration postcondition failed: dbo.sepay_payment_sessions does not exist.', 1;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc
          ON fkc.constraint_object_id = fk.object_id
        JOIN sys.columns parent_column
          ON parent_column.object_id = fkc.parent_object_id
         AND parent_column.column_id = fkc.parent_column_id
        JOIN sys.columns referenced_column
          ON referenced_column.object_id = fkc.referenced_object_id
         AND referenced_column.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id =
              OBJECT_ID(N'dbo.sepay_payment_sessions', N'U')
          AND fkc.referenced_object_id = @orders_object_id
          AND parent_column.name = N'order_id'
          AND referenced_column.name = N'id'
    )
        THROW 51008, N'Migration postcondition failed: order_id does not reference dbo.orders.id.', 1;

    IF @started_transaction = 1
        COMMIT TRANSACTION;

    SELECT
        OBJECT_ID(N'dbo.sepay_payment_sessions', N'U')
            AS payment_sessions_object_id,
        COL_LENGTH(N'dbo.sepay_transactions', N'transaction_date')
            AS transaction_date_length,
        @@TRANCOUNT AS transaction_count_after_migration;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
    BEGIN
        IF @started_transaction = 1
            ROLLBACK TRANSACTION;
        ELSE IF XACT_STATE() = 1
            ROLLBACK TRANSACTION v2_add_vietqr_payment_sessions;
    END;

    THROW;
END CATCH;
