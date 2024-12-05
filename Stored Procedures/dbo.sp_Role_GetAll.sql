SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Role_GetAll*/
CREATE Procedure [dbo].[sp_Role_GetAll]
AS

SELECT *
FROM Roles
GO
