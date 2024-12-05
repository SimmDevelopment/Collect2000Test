SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*Permissions_Update*/
Create Procedure [dbo].[Permissions_Update]
	@PermissionID int,
	@RoleID int,
	@NewValue bit,
	@SetBy_UserID int
AS

 /*
**Name            :Permissions_Update
**Function        :Adds or Deletes a Permission from the Fact Table.  Adds a History record of any altered permission.
**Creation        :11/29/2004 mr for Version 5
**Used by         :GSSLogin.Permissions
**Change History  :
*/

IF @NewValue = 1 BEGIN
	Delete From Fact Where PermissionID=@PermissionID and RoleID=@RoleID
	IF @@RowCount = 0 Insert Into Permissions_History(PermissionID,RoleID,NewValue,SetBy_UserID,DateSet)Values(@PermissionID,@RoleID,@NewValue,@SetBy_UserID,GetDate())
	Insert Into Fact(PermissionID,RoleID)Values(@PermissionID,@RoleID)
	
END
ELSE BEGIN
	Delete From Fact Where PermissionID=@PermissionID and RoleID=@RoleID
	IF @@RowCount > 0 Insert Into Permissions_History(PermissionID,RoleID,NewValue,SetBy_UserID,DateSet)Values(@PermissionID,@RoleID,@NewValue,@SetBy_UserID,GetDate())
END

Return @@Error

GO
