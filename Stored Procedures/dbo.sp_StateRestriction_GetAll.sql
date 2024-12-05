SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_StateRestriction_GetAll*/
CREATE Procedure [dbo].[sp_StateRestriction_GetAll]
AS

SELECT *
FROM StateRestrictions
GO
