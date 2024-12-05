SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Update_Phones_ForDoNotUse]
@PhoneNumber VARCHAR(30),
@DebtorId int, 
@Enable bit = 1,
@UpdatedBy varchar(256),
@RowCount int OUT
AS
/*
	Find all the phone number matches for all the debtors with matchin SS#
	and set the phone to bad and add a note for each account.
*/
-- Variable declaration.
DECLARE @Comment VARCHAR(5000)
DECLARE @Action VARCHAR(6)
DECLARE @Result VARCHAR(6)
DECLARE @PhonesAffected TABLE ([Number] INTEGER NOT NULL, [DebtorId] INT NOT NULL, [MasterPhoneID] INT NOT NULL);
DECLARE @DebtorsAffected TABLE ([Number] INTEGER NOT NULL, [DebtorId] INT NOT NULL);
DECLARE @SSN VARCHAR(15)
DECLARE @ApplicableStatusId INT

-- Variable assignment.
SET @Comment = '"Do Not Use" on phone number: ' + LTRIM(@PhoneNumber) + ' for DebtorID '
SET @Action = '+++++'
SET @Result = '+++++'
SET @UpdatedBy = ISNULL(@UpdatedBy, suser_sname())
SELECT @SSN = LTRIM(RTRIM(ISNULL(SSN, ''))) FROM Debtors WHERE DebtorID = @DebtorId
SELECT @ApplicableStatusId = [dbo].[Phones_StatusIdForDoNotUse] ()

IF LEN(@SSN) = 0
BEGIN
	-- debtor does not have a valid SSN so exit out...
	SET @RowCount = 0
	RETURN @@Error
END

-- Getting th Current UserName
	DECLARE	@LoginName VARCHAR(10);

    SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

IF @Enable = 1
BEGIN
	INSERT INTO @PhonesAffected ([Number], [DebtorId], [MasterPhoneID])
		SELECT p.[number], p.[DebtorID], p.[MasterPhoneID]
		FROM [dbo].[Phones_master] p WITH (INDEX(IX_PhonesMaster_PhoneNumber))
			INNER JOIN [dbo].[Debtors] d
				ON p.DebtorId = d.DebtorId
		WHERE p.PhoneNumber = @PhoneNumber AND d.SSN = @SSN AND ISNULL(p.PhoneStatusID, 0) != @ApplicableStatusId

	INSERT INTO @DebtorsAffected ([Number], [DebtorId])
		SELECT DISTINCT p.[number], p.[DebtorId]
		FROM @PhonesAffected p

	-- Insert a note on each affected debtor account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [DebtorsAffected].[Number],
		null,
		GETDATE(),
		LEFT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Added ' + @Comment + CONVERT(VARCHAR, [DebtorsAffected].[DebtorId]),
		0,
		0
	FROM @DebtorsAffected AS [DebtorsAffected]

	-- set each phone record to bad.
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = 1,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @PhonesAffected AS [PhonesAffected] INNER JOIN [dbo].[Phones_master]
		ON [PhonesAffected].[MasterPhoneID] = [dbo].[Phones_master].[MasterPhoneID]

	SET @RowCount = @@ROWCOUNT
END
ELSE
BEGIN
	INSERT INTO @PhonesAffected ([Number], [DebtorId], [MasterPhoneID])
		SELECT p.[number], p.[DebtorID], p.[MasterPhoneID]
		FROM [dbo].[Phones_master] p WITH (INDEX(IX_PhonesMaster_PhoneNumber))
			INNER JOIN [dbo].[Debtors] d
				ON p.DebtorId = d.DebtorId
		WHERE p.PhoneNumber = @PhoneNumber AND d.SSN = @SSN AND ISNULL(p.PhoneStatusID, 0) = @ApplicableStatusId

	INSERT INTO @DebtorsAffected ([Number], [DebtorId])
		SELECT DISTINCT p.[number], p.[DebtorId]
		FROM @PhonesAffected p

	-- Insert a "removed" note on each affected debtor account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [DebtorsAffected].[Number],
		null,
		GETDATE(),
		Left(@UpdatedBy, 10),
		@Action,
		@Result,
		'Removed ' + @Comment + CONVERT(VARCHAR, [DebtorsAffected].[DebtorId]),
		0,
		0
	FROM @DebtorsAffected AS [DebtorsAffected]

	-- set each phone record to bad.
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = 0,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @PhonesAffected AS [PhonesAffected] INNER JOIN [dbo].[Phones_master]
		ON [PhonesAffected].[MasterPhoneID] = [dbo].[Phones_master].[MasterPhoneID]

	SET @RowCount = @@ROWCOUNT
END

RETURN @@Error

GO
