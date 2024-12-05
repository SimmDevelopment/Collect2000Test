SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetUsersAvailable    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetUsersAvailable]
AS
	SET NOCOUNT ON;
SELECT	ID, 
		UserName, 
		LoginName, 
		Password, 
		PasswordDate,
		Alias, 
		RoleID, 
		BranchCode, 
		DeptID, 
		Phone, 
		Extension, 
		DeskCode, 
		Email, 
		TimeClock, 
		Active, 
		WindowsSID, 
		WindowsUserName, 
		Attempts, 
		LockoutDate, 
		PasswordSalt 
FROM dbo.Users with (nolock)
Where id not in(select UserID from LionUsers)
GO
