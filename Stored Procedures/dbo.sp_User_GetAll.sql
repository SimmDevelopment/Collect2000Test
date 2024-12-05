SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_User_GetAll*/
CREATE Procedure [dbo].[sp_User_GetAll]
AS

SELECT *
FROM Users
GO
