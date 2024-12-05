SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spUsers_Insert*/
CREATE   PROCEDURE [dbo].[spUsers_Insert]
        @UserName varchar(50),
        @LoginName varchar(10),
        @Alias varchar(50),
        @Email  varchar(50),
        @BranchCode varchar(5),
        @Phone varchar(20),
        @Extension varchar(10),
        @DeskCode varchar(10),
        @RoleID tinyint,
        @TimeClock bit,
	@WindowsUser varchar(255) output,
	@UserID int output
AS
SET NOCOUNT ON;

DECLARE @WindowsSID VARBINARY(85);

SET @WindowsSID = NULL;

IF @WindowsUser IS NOT NULL AND LEN(RTRIM(@WindowsUser)) > 0 AND @WindowsUser LIKE '%\%'
	SET @WindowsSID = SUSER_SID(@WindowsUser);
	IF @WindowsSID IS NULL OR DATALENGTH(@WindowsSID) < 8
		SET @WindowsSID = NULL;

SET @WindowsUser = SUSER_SNAME(@WindowsSID);

INSERT INTO dbo.Users (UserName, LoginName, Alias, Email, BranchCode, Phone, Extension, DeskCode, RoleID, TimeClock, WindowsSID, Active)
VALUES (@UserName, @LoginName, @Alias, @Email, @BranchCode, @Phone, @Extension, @DeskCode, @RoleID, @TimeClock, @WindowsSID, 1);

SELECT @UserID = SCOPE_IDENTITY();

RETURN @@ERROR;

GO
