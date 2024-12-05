SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Phonecall_Contacts_Remove]
			@ID int
		AS 

		DELETE Phonecall_Contacts
		WHERE PhonecallContactsID = @ID

		Return @@Error
GO
