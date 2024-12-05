SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Permission_Get*/
CREATE Procedure [dbo].[sp_Permission_Get]
	@ModuleName varchar(30)
AS

SELECT *
FROM Permissions
WHERE ModuleName = @ModuleName
GO
