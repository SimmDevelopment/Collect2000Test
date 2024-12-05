SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_updMasterAccounts*/
Create Procedure [dbo].[sp_updMasterAccounts] 
@Branch varchar(5), 
@Desk varchar(10), 
@Number int, 
@QLevel varchar(3), 
@QDate varchar(8), 
@DateStamp varchar(10),
@ReturnValue int OUTPUT as 

BEGIN
  Update Master Set Desk = @Desk, Branch = @Branch, Qlevel = @QLevel, 
         DMDateStamp = @DateStamp 
  Where Number = @Number 
  IF (@QDate <> '') 
    Begin 
       Update master set QDate = @QDate where Number = @Number 
  End
  select @ReturnValue = 0
END

Return @ReturnValue
GO
