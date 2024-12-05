SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[NewBizGetAccountIDs]
 	@Quantity int,
 	@FirstAccountID int OUTPUT
 
AS
 
Declare @Err int
 
SET NOCOUNT ON
BEGIN TRAN
 
--Get NextDebtor from ControlFile
Select @FirstAccountID = NextDebtor from ControlFile
 
--Check for uninitialized ControlFile 
IF @@RowCount <> 1 BEGIN
 Rollback Tran
 RAISERROR ('ControlFile not initialized',11,1)
 Return -1
END
ELSE BEGIN
 IF @FirstAccountID is Null SET @FirstAccountID = 1
 
 Update ControlFile Set NextDebtor = NextDebtor + @Quantity
 
 --Check for an Error, Commit or Rollback Tran
 SELECT @Err = @@Error
 IF @Err = 0 BEGIN
  COMMIT TRAN
  Return 0
 END
 ELSE BEGIN
  Rollback Tran
  RAISERROR ('Failed to Update Controlfile. Error=%d',11,1,@Err)
  Return 
 END
 
END
 

GO
