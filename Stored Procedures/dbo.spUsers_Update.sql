SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*spUsers_Update*/
CREATE   PROCEDURE [dbo].[spUsers_Update]
	@UserID int,
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
	@WindowsUser varchar(255)
AS
SET NOCOUNT ON;

--If the Updated DeskCode is different than the User's existing DeskCode then write a History record.
Declare @OldDesk varchar(10)
Select @OldDesk = DeskCode From Users Where ID = @UserID
If @OldDesk <> @DeskCode
	INSERT INTO User_Desk_History(UserID,DeskCode,AssignedDate) Values(@UserID,@DeskCode,GetDate())

DECLARE @WindowsSID VARBINARY(85);

SET @WindowsSID = NULL;

IF @WindowsUser IS NOT NULL AND LEN(RTRIM(@WindowsUser)) > 0 AND @WindowsUser LIKE '%\%'
	SET @WindowsSID = SUSER_SID(@WindowsUser);
	IF @WindowsSID IS NULL OR DATALENGTH(@WindowsSID) < 8
		SET @WindowsSID = NULL;

Update Users Set UserName=@UserName,
		LoginName=@LoginName,
		Alias=@Alias,
		Email=@Email,
		BranchCode=@BranchCode,
		Phone=@Phone,
		Extension=@Extension,
		DeskCode=@DeskCode,
		RoleID=@RoleID,
		TimeClock=@TimeClock,
		WindowsSID=@WindowsSID,
		Active = 1
WHERE ID = @UserID;

RETURN @@ERROR;


GO
