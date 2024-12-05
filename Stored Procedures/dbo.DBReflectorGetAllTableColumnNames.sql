SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/02/2006
-- Description: This is the SP that the DBReflector will call to get all the column names for a given table
-- =============================================
/*
exec DBReflectorGetAllTableColumnNames='Services_CT'
*/
CREATE PROCEDURE [dbo].[DBReflectorGetAllTableColumnNames]
	@tableName varchar(255)
AS
BEGIN
	SET NOCOUNT ON;

	Select	col.TABLE_NAME			AS [TableName],
			col.COLUMN_NAME			as [ColumnName]
	From INFORMATION_SCHEMA.COLUMNS col with (nolock)
	Where	col.TABLE_NAME=@tableName

END
GO
