SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDirectory]
   @UserId INT
AS
BEGIN
   SELECT UserName,Extension FROM Users 
   WHERE Extension IS NOT NULL AND Extension <> '' AND Active=1
   ORDER BY UserName
END

GO
