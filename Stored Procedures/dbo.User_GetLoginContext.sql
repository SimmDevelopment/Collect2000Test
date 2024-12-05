SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[User_GetLoginContext] 
    @userID INT
AS
BEGIN

    DECLARE @unknown INT
    DECLARE @desk INT
    DECLARE @supervisor INT
    DECLARE @manager INT

    SET @unknown = 0

   SELECT @desk = 1 FROM users WHERE Users.id = @userID
   SELECT @supervisor = 2 FROM Teams WHERE Teams.SupervisorID = @userID
   SELECT @manager = 4 FROM Departments dpts WHERE dpts.ManagerID = @userID

   SELECT COALESCE(@manager, @supervisor, @desk, @unknown) AS LoginContext
END

GO
