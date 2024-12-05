SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroup_GetByID*/
CREATE Procedure [dbo].[sp_CustomCustGroup_GetByID]
@ID INT
AS

SELECT *
FROM CustomCustGroups
WHERE ID = @ID

GO
