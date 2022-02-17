-- USE AxDB
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DROP PROCEDURE IF EXISTS TruncateNoise
GO

CREATE PROCEDURE TruncateNoise
@tableNameEnding NVARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @objectname nvarchar(130); 
	DECLARE @command nvarchar(4000);
	DECLARE @objectid int;

	DECLARE @sum bigint;

	SELECT schemas.name + '.' + objects.name as name, objects.object_id
		INTO #TargetTables
		FROM sys.objects as objects
		INNER JOIN sys.schemas as schemas
			ON (objects.schema_id = schemas.schema_id)
		WHERE objects.name LIKE '%' + @tableNameEnding
		  AND objects.type_desc = 'USER_TABLE'
		  AND schemas.name = 'dbo';


	-- Declare the cursor for the list of partitions to be processed.
	DECLARE partitions CURSOR FOR SELECT * FROM #TargetTables;

	-- Open the cursor.
	OPEN partitions;

	-- Loop through the partitions.
	WHILE (1=1)
	BEGIN;
		FETCH NEXT
			FROM partitions
			INTO @objectname, @objectid;
		IF @@FETCH_STATUS < 0 BREAK;

		BEGIN TRY
			SET @command = N'TRUNCATE TABLE ' + @objectname;
				EXEC (@command);
			PRINT N'EXECUTED: ' + @command;
		END TRY
		BEGIN CATCH
			PRINT N'RETRYING TO TRUNCATE TABLE ' + @objectname;
			BEGIN TRY
					EXEC (@command);
				PRINT N'EXECUTED: ' + @command;
			END TRY
			BEGIN CATCH
				PRINT N'FAILED TO TRUNCATE ' + @objectname;
			END CATCH
		END CATCH
				
	END;

	-- Close and deallocate the cursor.
	CLOSE partitions;
	DEALLOCATE partitions;

	DROP TABLE #TargetTables
END
GO