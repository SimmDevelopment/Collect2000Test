SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_SyncFromAccounts] @AccountID INTEGER, @LinkID INTEGER
AS
SET NOCOUNT ON;

DECLARE @BadStatus INTEGER;
DECLARE @HomeType INTEGER;
DECLARE @WorkType INTEGER;
DECLARE @CellType INTEGER;
DECLARE @FaxType INTEGER;
DECLARE @SpouseHomeType INTEGER;
DECLARE @SpouseWorkType INTEGER;

SELECT TOP 1 @BadStatus = [Phones_Statuses].[PhoneStatusID]
FROM [dbo].[Phones_Statuses]
WHERE [Phones_Statuses].[Active] = 0;

SELECT TOP 1 @HomeType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 0;

SELECT TOP 1 @WorkType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 1;

SELECT TOP 1 @CellType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 2;

SELECT TOP 1 @FaxType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 3;

SELECT TOP 1 @SpouseHomeType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 4;

SELECT TOP 1 @SpouseWorkType = [Phones_Types].[PhoneTypeID]
FROM [dbo].[Phones_Types]
WHERE [Phones_Types].[PhoneTypeMapping] = 5;

DECLARE @Debtors TABLE (
	[DebtorID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
);

DECLARE @Phones TABLE (
	[AccountID] INTEGER NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[Type] INTEGER NOT NULL,
	[Status] INTEGER NULL,
	[PhoneNumber] VARCHAR(30) NOT NULL,
	[Extension] VARCHAR(10) NOT NULL,
	[LoginName] VARCHAR(10) NULL,
	[DateAdded] DATETIME NULL
);

INSERT INTO @Debtors ([DebtorID])
SELECT [Debtors].[DebtorID]
FROM [dbo].[Debtors]
INNER JOIN [dbo].[fnGetLinkedAccounts](@AccountID, @LinkID) AS [LinkedAccounts]
ON [Debtors].[number] = [LinkedAccounts].[AccountID];

IF @HomeType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @HomeType, [dbo].[StripNonDigits]([Debtors].[homephone]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[homephone])) >= 7;

	IF @BadStatus IS NOT NULL BEGIN
		INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [Status], [PhoneNumber], [Extension])
		SELECT [PhoneHistory].[AccountID], [PhoneHistory].[DebtorID], @HomeType, @BadStatus, [dbo].[StripNonDigits]([OldNumber]), ''
		FROM [dbo].[PhoneHistory]
		INNER JOIN @Debtors AS [DebtorList]
		ON [PhoneHistory].[DebtorID] = [DebtorList].[DebtorID]
		WHERE [PhoneHistory].[Phonetype] = 1
		AND LEN([dbo].[StripNonDigits]([PhoneHistory].[OldNumber])) >= 7;
	END;
END;

IF @WorkType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @WorkType, [dbo].[StripNonDigits]([Debtors].[workphone]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[workphone])) >= 7;

	IF @BadStatus IS NOT NULL BEGIN
		INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [Status], [PhoneNumber], [Extension])
		SELECT [PhoneHistory].[AccountID], [PhoneHistory].[DebtorID], @HomeType, @BadStatus, [dbo].[StripNonDigits]([OldNumber]), ''
		FROM [dbo].[PhoneHistory]
		INNER JOIN @Debtors AS [DebtorList]
		ON [PhoneHistory].[DebtorID] = [DebtorList].[DebtorID]
		WHERE [PhoneHistory].[Phonetype] = 2
		AND LEN([dbo].[StripNonDigits]([PhoneHistory].[OldNumber])) >= 7;
	END;
END;

IF @CellType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @CellType, [dbo].[StripNonDigits]([Debtors].[Pager]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[Pager])) >= 7;
END;

IF @FaxType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @FaxType, [dbo].[StripNonDigits]([Debtors].[Fax]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[Fax])) >= 7;
END;

IF @SpouseHomeType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @SpouseHomeType, [dbo].[StripNonDigits]([Debtors].[SpouseHomePhone]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[SpouseHomePhone])) >= 7;
END;

IF @SpouseWorkType IS NOT NULL BEGIN
	INSERT INTO @Phones ([AccountID], [DebtorID], [Type], [PhoneNumber], [Extension])
	SELECT [Debtors].[number], [Debtors].[DebtorID], @SpouseWorkType, [dbo].[StripNonDigits]([Debtors].[SpouseWorkPhone]), ''
	FROM [dbo].[Debtors]
	INNER JOIN @Debtors AS [DebtorList]
	ON [Debtors].[DebtorID] = [DebtorList].[DebtorID]
	WHERE LEN([dbo].[StripNonDigits]([Debtors].[SpouseWorkPhone])) >= 7;
END;

UPDATE @Phones
SET [PhoneNumber] = SUBSTRING([PhoneNumber], 2, 30)
WHERE [PhoneNumber] LIKE '1%'
AND LEN([PhoneNumber]) > 10;

--Removing the below code as it was inserting number into Extension wrongly
--UPDATE @Phones
--SET [Extension] = SUBSTRING([PhoneNumber], 11, 10),
--	[PhoneNumber] = SUBSTRING([PhoneNumber], 1, 10)
--WHERE LEN([PhoneNumber]) > 10;

DELETE [Phones]
FROM @Phones AS [Phones]
INNER JOIN [dbo].[Phones_Master]
ON [Phones].[AccountID] = [Phones_Master].[Number]
AND [Phones].[PhoneNumber] = [Phones_Master].[PhoneNumber];

--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
INSERT INTO [dbo].[Phones_Master] ([Number], [PhoneTypeID], [Relationship], [PhoneStatusID], [OnHold], [PhoneNumber], [PhoneExt], [DebtorID], [DateAdded], [RequestID], [PhoneName], [LoginName],[LastUpdated],[UpdatedBy])
SELECT DISTINCT [Phones].[AccountID], [Phones].[Type], '', ISNULL([Phones].[Status],0), 0, [Phones].[PhoneNumber], [Phones].[Extension], [Phones].[DebtorID], GETDATE(), NULL, '', 'CONVERSION',NULL,NULL
FROM @Phones AS [Phones]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[Phones_Master]
	WHERE [Phones_Master].[Number] = [Phones].[AccountID]
	AND [Phones_Master].[PhoneNumber] = [Phones].[PhoneNumber]
	AND [Phones_Master].[DebtorID] = [Phones].[DebtorID]
);

RETURN 0;
GO
