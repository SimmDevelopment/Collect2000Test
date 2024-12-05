SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Update_Phones_ForBankruptcy]
@DebtorId int, 
@Enable bit = 1,
@UpdatedBy varchar(256),
@RowCount int OUT
AS
/*
	For every account where the primary debtors SSN matches the given debtors,
	we need to add a note, and mark all phones on each account as bad.
*/

-- Variable declaration.
DECLARE @Comment VARCHAR(5000)
DECLARE @Action VARCHAR(6)
DECLARE @Result VARCHAR(6)
DECLARE @AccountsAffected TABLE ([Number] INTEGER NOT NULL);
DECLARE @SSN VARCHAR(15)

-- Variable assignment.
SET @Comment = 'Bankruptcy reported for debtor ' + CONVERT(VARCHAR, @DebtorId)
SET @Action = '+++++'
SET @Result = '+++++'
SET @UpdatedBy = ISNULL(@UpdatedBy, suser_sname())
SELECT @SSN = LTRIM(RTRIM(ISNULL(SSN, ''))) FROM Debtors WHERE DebtorID = @DebtorId

IF LEN(@SSN) = 0
BEGIN
	-- debtor does not have a valid SSN so exit out...
	SET @RowCount = 0
	RETURN @@Error
END

INSERT INTO @AccountsAffected ([Number])
	SELECT d.[number]
	FROM [dbo].[Debtors] d
	WHERE d.[seq] = 0 AND d.SSN = @SSN

	-- Getting th Current UserName
	DECLARE	@LoginName VARCHAR(10);

    SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

IF @Enable = 1
BEGIN
	-- Insert a note on each affected debtor account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [AccountsAffected].[Number],
		null,
		GETDATE(),
		RIGHT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Added ' + @Comment,
		0,
		0
	FROM @AccountsAffected AS [AccountsAffected]

	-- set each phone record to bad.
	
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = 1,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @AccountsAffected AS [AccountsAffected] INNER JOIN [dbo].[Phones_master]
		ON [AccountsAffected].[Number] = [dbo].[Phones_master].[Number]

	SET @RowCount = @@ROWCOUNT
END
ELSE
BEGIN
 	-- Insert a "removed" note on each affected debtor account
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
	SELECT [AccountsAffected].[Number],
		null,
		GETDATE(),
		RIGHT(@UpdatedBy, 10),
		@Action,
		@Result,
		'Removed ' + @Comment,
		0,
		0
	FROM @AccountsAffected AS [AccountsAffected]

	-- set each phone record to bad.
	--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
	UPDATE [dbo].[Phones_master]
	SET [PhoneStatusID] = 0,[LastUpdated] = GETDATE(), [UpdatedBy] = @LoginName
	FROM @AccountsAffected AS [AccountsAffected] INNER JOIN [dbo].[Phones_master]
		ON [AccountsAffected].[Number] = [dbo].[Phones_master].[Number]

	SET @RowCount = @@ROWCOUNT
END

RETURN @@Error

GO
