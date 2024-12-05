SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Permission_GetAll*/
CREATE Procedure [dbo].[sp_Permission_GetAll]
AS

SELECT *
FROM Permissions
GO
