SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Update_Phones_AllCeaseAndDesist]
AS
/* 
	FOR every enabled phone number in the Phones_CeaseAndDesist table,
	find each occurrance of the phone number in phones_master that isn't marked as bad,
	mark each record as bad, and add a note to the account that 
	indicates the cease and desist order on this phonenumber.
	End FOR
*/
	DECLARE @UpdatedBy varchar(256)
	DECLARE @Comment VARCHAR(5000)
	DECLARE @Action VARCHAR(6)
	DECLARE @Result VARCHAR(6)
	DECLARE @PhonesAffected TABLE ([Number] INTEGER NOT NULL,	[MasterPhoneID] INT NOT NULL, [PhoneNumber] VARCHAR(30) NOT NULL);
	DECLARE @ApplicableStatusId INT

	SET @Comment = '"Cease And Desist" on phone number: '
	SET @Action = '+++++'
	SET @Result = '+++++'
	SET @UpdatedBy = ISNULL(@UpdatedBy, suser_sname())
	SELECT @ApplicableStatusId = [dbo].[Phones_StatusIdForCeaseAndDesist] ()

	-- Capture all the affected phones and accounts
	INSERT INTO @PhonesAffected ([Number], [MasterPhoneID], [PhoneNumber])
	SELECT p.[number], p.[MasterPhoneID], p.[PhoneNumber]
	FROM [dbo].[Phones_CeaseAndDesist] d INNER JOIN [dbo].[Phones_master] p 
		ON p.[PhoneNumber] = d.[PhoneNumber]
	WHERE d.[Enabled] = 1 AND ISNULL(p.[PhoneStatusID], 0) != @ApplicableStatusId

	-- Insert a "Cease And Desist" note on each affected account and phone number
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [PhonesAffected].[Number],
		null,
		GETDATE(),
		LEFT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Added ' + @Comment + LTRIM([PhonesAffected].[PhoneNumber]),
		0,
		0
	FROM @PhonesAffected AS [PhonesAffected]

	-- set each phone record to bad.

	DECLARE	@LoginName VARCHAR(10);

    SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = @ApplicableStatusId,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM [dbo].[Phones_master] INNER JOIN @PhonesAffected AS [PhonesAffected] 
		ON [dbo].[Phones_master].[MasterPhoneID] = [PhonesAffected].[MasterPhoneID]

RETURN @@Error

GO
