SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Future_Delete*/
CREATE Procedure [dbo].[sp_Future_Delete]
@Uid INT
AS

DELETE FROM future
WHERE uid = @Uid

GO
