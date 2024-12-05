SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ryan Mack
-- Create date: 2019-02-21
-- Description:	Performs updates related to user registration on Propensio portal
-- =============================================
CREATE PROCEDURE [dbo].[Propensio_UserRegistered] 
	@FileNum INT, 
	@UserId VARCHAR(MAX),
	@Email VARCHAR(MAX),
	@MobileNumber VARCHAR(MAX),
	@Consent BIT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PhoneType INT
	DECLARE @DebtorId INT
	DECLARE @ExistingEmail VARCHAR(MAX)

	SELECT TOP 1 @ExistingEmail = Email, @DebtorId = DebtorID FROM Debtors WHERE Number = @FileNum AND Seq = 0

	IF (@Consent = 0)
	BEGIN
	-- handle e-mail
	-- if no consent just note it otherwise update debtor
		INSERT INTO [dbo].[notes]
			([number]
			,[created]
			,[user0]
			,[action]
			,[result]
			,[comment])
		VALUES
			(@FileNum,
			GETDATE(),
			'PayWeb',
			'CO',
			'CO', 
			'Email: ' + @Email + ' Consent: FALSE')

	--handle mobile phone
	-- no consent add as type "3" otherwise type "46"
		SET @PhoneType = 3
	END
	ELSE
	BEGIN

		IF (@ExistingEmail IS NOT NULL AND @ExistingEmail NOT LIKE @Email)
		BEGIN
			INSERT INTO [dbo].[notes]
				([number]
				,[created]
				,[user0]
				,[action]
				,[result]
				,[comment])
			VALUES
				(@FileNum,
				GETDATE(),
				'PayWeb',
				'CO',
				'CO', 
				'Replacing old e-mail address: ' + @ExistingEmail)
		END

		UPDATE Debtors SET Email = @Email WHERE DebtorID = @DebtorId
		
		INSERT INTO [dbo].[notes]
			([number]
			,[created]
			,[user0]
			,[action]
			,[result]
			,[comment])
		VALUES
			(@FileNum,
			GETDATE(),
			'PayWeb',
			'CO',
			'CO', 
			'Consumer provided consent to email ' + @Email + ' and SMS to ' + @MobileNumber + ' through the online portal')

		SET @PhoneType = 46
	END

	IF (NOT EXISTS(SELECT 'true' FROM Phones_Master WHERE PhoneNumber LIKE @MobileNumber AND Number = @FileNum))
	BEGIN
		INSERT INTO [dbo].[Phones_Master]
			([Number]
			,[PhoneTypeID]
			,[PhoneStatusID]
			,[OnHold]
			,[PhoneNumber]
			,[PhoneExt]
			,[DebtorID]
			,[DateAdded]
			,[LoginName])
		VALUES
			(@FileNum
			,@PhoneType
			,0
			,0
			,@MobileNumber
			,''
			,@DebtorId
			,GETDATE()
			,'PayWeb')
	END
END
GO
