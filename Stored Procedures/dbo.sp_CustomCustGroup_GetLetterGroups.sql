SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroup_GetLetterGroups*/
CREATE Procedure [dbo].[sp_CustomCustGroup_GetLetterGroups]
	/* Param List */
AS

SELECT *
FROM CustomCustGroups
WHERE LetterGroup = 1

GO
