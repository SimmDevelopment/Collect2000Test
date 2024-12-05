SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_NewBusinessOptions_GetByID*/
CREATE Procedure [dbo].[sp_NewBusinessOptions_GetByID]
@NewBusinessOptionsID INT
AS

SELECT *
FROM NewBusinessOptions
WHERE NewBusinessOptionsID = @NewBusinessOptionsID

GO
