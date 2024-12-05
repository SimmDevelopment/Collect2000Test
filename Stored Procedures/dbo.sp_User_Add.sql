SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_User_Add*/
CREATE Procedure [dbo].[sp_User_Add]
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

INSERT INTO Users
(
ID,
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
TimeClock
)
VALUES
(
@ID,
@UserName,
@LoginName,
@Password,
@PasswordDate,
@Alias,
@RoleID,
@BranchCode,
@DeptID,
@Phone,
@Extension,
@DeskCode,
@Email,
@TimeClock
)

--SET @UserID = @@IDENTITY
GO
