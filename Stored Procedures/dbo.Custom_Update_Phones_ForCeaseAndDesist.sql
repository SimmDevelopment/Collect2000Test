SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Update_Phones_ForCeaseAndDesist]
@PhoneNumber VARCHAR(30),
@Enable bit = 1,
@UpdatedBy varchar(256),
@RowCount int OUT
AS
/* 
	Find every occurrance of this phone number in phones_master,
	mark each record as bad, and add a note to the account to 
	indicate the cease and desist order on this phonenumber.
*/
-- Variable declaration.
DECLARE @Comment VARCHAR(5000)
DECLARE @Action VARCHAR(6)
DECLARE @Result VARCHAR(6)
DECLARE @PhonesAffected TABLE ([Number] INTEGER NOT NULL,	[MasterPhoneID] INT NOT NULL);
DECLARE @AccountsAffected TABLE ([Number] INTEGER NOT NULL);
DECLARE @ApplicableStatusId INT

-- Variable assignment.
SET @Comment = '"Cease And Desist" on phone number: ' + LTRIM(@PhoneNumber)
SET @Action = '+++++'
SET @Result = '+++++'
SET @UpdatedBy = ISNULL(@UpdatedBy, suser_sname())
SELECT @ApplicableStatusId = [dbo].[Phones_StatusIdForCeaseAndDesist]()

-- Getting th Current UserName
	DECLARE	@LoginName VARCHAR(10);

    SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

IF @Enable = 1
BEGIN
	INSERT INTO @PhonesAffected ([Number], [MasterPhoneID])
		SELECT p.[number], p.[MasterPhoneID]
		FROM [dbo].[Phones_master] p WITH (INDEX(IX_PhonesMaster_PhoneNumber))
		WHERE p.PhoneNumber = @PhoneNumber AND ISNULL(p.PhoneStatusID, 0) != @ApplicableStatusId

	INSERT INTO @AccountsAffected ([Number])
		SELECT DISTINCT(p.[number])
		FROM @PhonesAffected p

	-- Insert a "Cease And Desist" note on each affected account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [AccountsAffected].[Number],
		null,
		GETDATE(),
		LEFT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Added ' + @Comment,
		0,
		0
	FROM @AccountsAffected AS [AccountsAffected]

	-- set each phone record to bad.
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = @ApplicableStatusId,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @PhonesAffected AS [PhonesAffected] INNER JOIN [dbo].[Phones_master]
		ON [PhonesAffected].[MasterPhoneID] = [dbo].[Phones_master].[MasterPhoneID]

	SET @RowCount = @@ROWCOUNT
END
ELSE
BEGIN
	INSERT INTO @PhonesAffected ([Number], [MasterPhoneID])
		SELECT p.[number], p.[MasterPhoneID]
		FROM [dbo].[Phones_master] p WITH (INDEX(IX_PhonesMaster_PhoneNumber))
		WHERE p.PhoneNumber = @PhoneNumber AND ISNULL(p.PhoneStatusID, 0) = @ApplicableStatusId

	INSERT INTO @AccountsAffected ([Number])
		SELECT DISTINCT(p.[number])
		FROM @PhonesAffected p

	-- Insert a "Removed Cease And Desist" note on each affected account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [AccountsAffected].[Number],
		null,
		GETDATE(),
		LEFT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Removed ' + @Comment,
		0,
		0
	FROM @AccountsAffected AS [AccountsAffected]

	-- set each phone record to unknown.
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = 0,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @PhonesAffected AS [PhonesAffected] INNER JOIN [dbo].[Phones_master]
		ON [PhonesAffected].[MasterPhoneID] = [dbo].[Phones_master].[MasterPhoneID]

	SET @RowCount = @@ROWCOUNT
END

RETURN @@Error

GO
