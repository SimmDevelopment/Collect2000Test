SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_StateRestriction_GetByID*/
CREATE Procedure [dbo].[sp_StateRestriction_GetByID]
@Abbreviation varchar(3)
AS

SELECT *
FROM StateRestrictions
WHERE Abbreviation = @Abbreviation
GO
