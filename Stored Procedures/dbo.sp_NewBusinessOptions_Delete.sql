SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_NewBusinessOptions_Delete*/
CREATE Procedure [dbo].[sp_NewBusinessOptions_Delete]
@NewBusinessOptionsID INT
AS

DELETE FROM NewBusinessOptions
WHERE NewBusinessOptionsID = @NewBusinessOptionsID

GO
