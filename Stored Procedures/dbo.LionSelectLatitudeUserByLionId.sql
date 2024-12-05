SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectLatitudeUserByLionId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectLatitudeUserByLionId]
(
	@LionUserId int
)
AS
	SET NOCOUNT ON;
SELECT	u.ID, 
		u.UserName, 
		u.LoginName, 
		u.Password, 
		u.PasswordDate, 
		u.Alias, 
		u.RoleID, 
		u.BranchCode, 
		u.DeptID, 
		u.Phone, 
		u.Extension, 
		u.DeskCode, 
		u.Email,
		u.TimeClock,
		u.Active, 
		u.WindowsSID, 
		u.WindowsUserName, 
		u.Attempts, 
		u.LockoutDate, 
		u.PasswordSalt 
FROM dbo.Users u
Join LionUsers lu on lu.UserId=u.ID
where lu.Id=@LionUserId
GO
