SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--KMG Added salt and hash parameters to insert user passwords correctly for Latitude
--KMG Added LatitudeRoleID to create a valid association (this will be used initially for the Password Security Policy)

CREATE PROCEDURE [dbo].[LionInsertLionUser]
(
	--@UserID int,
	@CustomerGroupID int,
	@ReportRoleId int,
	@SupervisiorEmail varchar(255),
	@NotifyEmail varchar(255),
	@FirstName varchar(50),
	@LastName varchar(50),
	@Enabled bit,
	@LionPassword image,
	@LatitudePassword varchar(20),
	@Username varchar(50),
	@PasswordSalt varchar(128),
	@PasswordHash varchar(128),
	@LatitudeRoleID int
)
AS
	SET NOCOUNT OFF;

Declare @userId int
IF NOT EXISTS (select * from Users where UserName=@Username)
BEGIN
	INSERT INTO Users([Username],[LoginName],[Password],[PasswordDate],[PasswordSalt],[Alias],[RoleID],[BranchCode],[Phone],[Extension],[DeskCode],[Email],[TimeClock],[Active],[Attempts],[LockoutDate]) 
	Values(@Username, @Username, @PasswordHash, '01/01/1753',@PasswordSalt, '', @LatitudeRoleID, '', '', '', '', @NotifyEmail, '', 1,0,'01/01/1753')
END
SELECT @userId=(select ID from Users where UserName=@Username)

INSERT INTO LionUsers ([UserID], [CustomerGroupID], [ReportRoleId], [SupervisiorEmail], [NotifyEmail], [FirstName], [LastName], [Enabled], [LionPassword]) 
VALUES (@UserID, @CustomerGroupID,@ReportRoleId, @SupervisiorEmail, @NotifyEmail, @FirstName, @LastName, @Enabled, @LionPassword);

return SCOPE_IDENTITY()
	
GO
