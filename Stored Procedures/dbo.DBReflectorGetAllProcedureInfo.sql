SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Sayed Ibrahim Hashimi
-- Create date: 12/9/2005
-- Description:	This will return some lightweight information for all stored procedures
--				This store procedure is a dependency of the DBReflector, do not unknowingly
--				make any changes to it.
-- =============================================
CREATE PROCEDURE [dbo].[DBReflectorGetAllProcedureInfo]
AS             --DBReflectorGetAllProcedureInfo
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT
	rout.ROUTINE_NAME			as [Name],
	--ROUTINE_TYPE	as [Type],
	CASE(rout.ROUTINE_TYPE)
		WHEN 'FUNCTION'	THEN 'Function'
		WHEN 'PROCEDURE' THEN 'Procedure'
		ELSE 'Unknown'
	END							as [Type],
	rout.LAST_ALTERED			as [LastAltered],
	rout.CREATED				as [Created],
	obj.id						as [Id]
FROM INFORMATION_SCHEMA.ROUTINES rout
join sysobjects obj on obj.name=rout.ROUTINE_NAME
WHERE ROUTINE_TYPE='PROCEDURE'
ORDER BY rout.ROUTINE_NAME
END
------------------------------------------------------------------------------------------------------------------------------------------
GO
