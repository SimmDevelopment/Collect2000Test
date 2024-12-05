SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ExtraData_DeleteByAccountID*/
CREATE Procedure [dbo].[sp_ExtraData_DeleteByAccountID]
	@Number int
AS

DELETE FROM ExtraData
WHERE Number = @Number

GO
