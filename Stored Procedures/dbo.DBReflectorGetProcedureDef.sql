SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 12/8/2005
-- Description:	Will give you contents of the stored procedure with the specified name.
--			    The DBReflector component of the Exchange depends on this store procedure
--				do not unknowlingly modify this in any way.
-- Modified: KAR 09/25/2007 Need to remove criteria on schema_ver column
--           from sysobjects. Causes problems on SQL Server2000 in which
--           this column is incremented if the definition has been altered.
-- =============================================
CREATE PROCEDURE [dbo].[DBReflectorGetProcedureDef]
	@ProcName varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @id int
DECLARE @name nvarchar(128)
SELECT @id =id, @name=name FROM [sysobjects] WHERE type = 'p' AND name =@ProcName
--SELECT @id
SELECT 
	@id			as [ID],
	@name		as [Name],
	[text]		as [Definition]
FROM syscomments WHERE id=@id

END
--EXEC DBReflectorGetProcedureDef @ProcName='Custom_Report_Cingular_Month_End'
------------------------------------------------------------------------------------------------------------------------------------------
GO
