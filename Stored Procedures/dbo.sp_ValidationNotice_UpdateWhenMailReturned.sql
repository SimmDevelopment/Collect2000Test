SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Name:		sp_ValidationNotice_UpdateWhenMailReturned
-- Function:	This procedure will clear  validation notice fields using the debtor as an input parameter.
-- Creation:	unknown 
-- Usage :      After clicking MailReturn ,it should update validationnotice update.

/*[sp_ValidationNotice_UpdateWhenMailReturned]*/
CREATE PROCEDURE [dbo].[sp_ValidationNotice_UpdateWhenMailReturned]
	@DebtorID int
 AS
 BEGIN
		Declare @MailReturnDate DateTime
		Declare @Expiration DateTime
	
		BEGIN TRAN	
			SET @MailReturnDate =GETUTCDATE()

			select @Expiration=ValidationPeriodExpiration from validationnotice where DebtorID=@DebtorID and isnull(LetterRequestID,0) <> 0 
			If(@MailReturnDate<@Expiration)
			Begin
				Update ValidationNotice set ValidationPeriodExpiration= NULL
				,ValidationPeriodCompleted =0 
				,Status= 'Returned'
				,LastUpdated = GETDATE()
				where noticeid in (select noticeId from validationnotice where DebtorID=@DebtorID and isnull(LetterRequestID,0) <> 0 )	
			End

		IF (@@error = 0) 
			COMMIT TRAN
		ELSE BEGIN
			ROLLBACK TRAN	
		END
END
GO
