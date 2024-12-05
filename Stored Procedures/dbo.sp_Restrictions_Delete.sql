SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Restrictions_Delete*/
CREATE Procedure [dbo].[sp_Restrictions_Delete]
@Number INT
AS

DELETE FROM restrictions
WHERE Number = @Number
GO
