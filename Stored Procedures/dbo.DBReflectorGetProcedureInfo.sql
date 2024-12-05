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
--				To get the definition of the procedure you must use the other SP 
--				DBReflectorGetProcedureDef
-- =============================================
CREATE PROCEDURE [dbo].[DBReflectorGetProcedureInfo]
	@ProcName varchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT
	rout.ROUTINE_NAME	as [Name],
	--ROUTINE_TYPE	as [Type],
	CASE(rout.ROUTINE_TYPE)
		WHEN 'FUNCTION'	THEN 'Function'
		WHEN 'PROCEDURE' THEN 'Procedure'
		ELSE 'Unknown'
	END				as [Type],
	rout.LAST_ALTERED	as [LastAltered],
	rout.CREATED			as [Created],
	obj.id			as [Id]
FROM INFORMATION_SCHEMA.ROUTINES rout
join sysobjects obj on obj.name=rout.ROUTINE_NAME
WHERE rout.ROUTINE_NAME = @ProcName

/*
SELECT
	ROUTINE_NAME	as [Name],
	--ROUTINE_TYPE	as [Type],
	CASE(ROUTINE_TYPE)
		WHEN 'FUNCTION'	THEN 'Function'
		WHEN 'PROCEDURE' THEN 'Procedure'
		ELSE 'Unknown'
	END				as [Type],
	LAST_ALTERED	as [LastAltered],
	CREATED			as [Created]
FROM INFORMATION_SCHEMA.ROUTINES
*/
END
GO
