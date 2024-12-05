SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroup_GetAll*/
CREATE Procedure [dbo].[sp_CustomCustGroup_GetAll]
AS

SELECT *
FROM CustomCustGroups
WHERE LetterGroup = 0

GO
