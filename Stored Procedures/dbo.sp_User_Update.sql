SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_User_Update*/
CREATE Procedure [dbo].[sp_User_Update]
@ID int,
@UserName varchar(50),
@LoginName varchar(10),
@Password varchar(20),
@PasswordDate datetime,
@Alias varchar(50),
@RoleID int,
@BranchCode varchar(5),
@DeptID int,
@Phone varchar(20),
@Extension varchar(10),
@DeskCode varchar(10),
@Email varchar(50),
@TimeClock bit
AS

UPDATE Users
SET
UserName = @UserName,
LoginName = @LoginName,
Password = @Password,
PasswordDate = @PasswordDate,
Alias = @Alias,
RoleID = @RoleID,
BranchCode = @BranchCode,
DeptID = @DeptID,
Phone = @Phone,
Extension = @Extension,
DeskCode = @DeskCode,
Email = @Email,
TimeClock = @TimeClock
WHERE ID = @ID
GO
