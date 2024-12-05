SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Master_Delete*/
CREATE Procedure [dbo].[sp_Master_Delete]
@Number int
AS

DELETE FROM master
WHERE Number = @Number

GO
