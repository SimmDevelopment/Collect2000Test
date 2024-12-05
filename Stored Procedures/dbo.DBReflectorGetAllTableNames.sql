SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/02/2006
-- Description: This is the SP that the DBReflector will call to get all the columns contained in a given table
-- =============================================
/*
exec DBReflectorGetAllTableNames
*/
CREATE PROCEDURE [dbo].[DBReflectorGetAllTableNames]
	
AS
BEGIN
	SET NOCOUNT ON;

	Select		TABLE_NAME			as [TableName]
	From INFORMATION_SCHEMA.TABLES with (nolock)
	Where TABLE_TYPE = 'BASE TABLE'
	Order by TABLE_NAME asc

END
GO
