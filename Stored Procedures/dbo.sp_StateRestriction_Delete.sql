SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_StateRestriction_Delete*/
CREATE Procedure [dbo].[sp_StateRestriction_Delete]
@Abbreviation varchar(3)
AS

DELETE FROM StateRestrictions
WHERE Abbreviation = @Abbreviation
GO
