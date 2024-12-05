SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Phonecall_Contacts_Update]
			@ID int,
			@ExpressConsentDate date
		AS 

		UPDATE Phonecall_Contacts SET
			ExpressConsentDate = @ExpressConsentDate
		WHERE PhonecallContactsID = @ID

		Return @@Error
GO
