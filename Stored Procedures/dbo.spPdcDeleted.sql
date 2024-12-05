SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*SPPDCDeleted sp*/
CREATE PROCEDURE [dbo].[spPdcDeleted] AS
DECLARE @Insert_error int
DECLARE @Delete_error int
DECLARE @Update_error int
DECLARE @Email_error int

 -- Start a transaction.
BEGIN TRAN
-- Select Closed Accounts with PDC's And Save PDC's to Table:PDCDeleted
INSERT INTO PdcDeleted  (Number,Pdc_Type,Entered,OnHold,Processed1,processedflag,deposit,amount,checknbr,seq,ltrcode,nitd,desk,customer,printed,approvedby,promisemode)
       SELECT Number,Pdc_Type,Entered,OnHold,Processed1,processedflag,deposit,amount,checknbr,seq,ltrcode,nitd,desk,customer,printed,approvedby,promisemode
       FROM PDC Where Number in (Select Number from master where Qlevel > '997')
-- Update Account Column
update PDCDeleted set Account=master.account,pdcdeleted.qlevel=master.qlevel from master where pdcdeleted.number=master.number and pdcdeleted.deleteddate is null
SELECT @Insert_error = @@ERROR
-- Delete the Selected PDC's From the PDC Table
Delete from PDC where number in (Select Number From Master Where Qlevel > '997')
SELECT @Delete_error = @@ERROR
DECLARE @Description NVARCHAR(100)
DECLARE @Message NVARCHAR(150)
DECLARE @Recipients NVARCHAR(200)
select @Recipients = email from controlFile with (NoLock) 
DECLARE @Query NVARCHAR(2000)
-- Send Email To User Un The Control File
EXEC master.dbo.xp_sendmail @recipients = @recipients, @subject = 'Deleted Post Dated Checks On Closed Accounts', @message = '', @dbuse = 'collect2000', @query = 'Select number,cast(deposit as varchar(11)) As Deposit,cast(amount as varchar(12)) As Amount,checknbr As CheckNumber,customer,account from PdcDeleted where DeletedDate is Null order by customer,number,qlevel',   @width = 15000 
SELECT @Email_error = @@ERROR
Update PdcDeleted set DeletedDate=getdate() where DeletedDate is Null 
SELECT @Update_error = @@ERROR  
-- Test the error values.
IF @Insert_error = 0 AND @Delete_error = 0 AND @Update_error = 0 AND @Email_error = 0
   -- Success. Commit the transaction.
COMMIT TRAN
ELSE  ROLLBACK TRAN
    
 
GO
