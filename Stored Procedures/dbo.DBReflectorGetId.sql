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
CREATE PROCEDURE [dbo].[DBReflectorGetId]
	@Type varchar(20),
	@Name varchar(1000)
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @typeCode varchar(10)

SELECT @typeCode=
			CASE(@Type)
				WHEN 'PROCEDURE' THEN 'P'
				WHEN 'P' THEN 'P'

			    WHEN 'FUNCTION' THEN 'FN'
				WHEN 'F' THEN 'FN'
				WHEN 'FN' THEN 'FN'

				WHEN 'TABLE' THEN 'U'
				WHEN 'T' THEN 'U'
				WHEN 'U' THEN 'U'

				WHEN 'VIEW' THEN 'V'
				WHEN 'V' THEN 'V'

				ELSE	--THROW ERROR
					'error'
				--'test'
/*					RAISERROR('Unrecognized objec type')
					RAISERROR('ERROR',15,1,1,1,1)*/

			END
IF @type='error'
BEGIN
	RAISERROR ('Unrecognized objec type:  %s',10,1,@Type);
end

SELECT id				as [id]
FROM sysobjects
WHERE name=@name and type=@typeCode AND schema_ver = 0

END
-----------------------------------------------------------------------------------------------------------------------------------------
GO
