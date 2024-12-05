SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_RequestCbr] @CbrType SMALLINT, @CoDebtor BIT = 0
AS
SET NOCOUNT ON;

DECLARE @TypeName VARCHAR(50);
DECLARE @TypeDesc VARCHAR(50);

IF @CbrType = 1 BEGIN
	SET @TypeName = 'Equifax Req (FULL)';
	SET @TypeDesc = 'Equifax Full';
END;
ELSE IF @CbrType = 2 BEGIN
	SET @TypeName = 'Equifax Req (FINDERS)';
	SET @TypeDesc = 'Equifax FInders';
END;
ELSE IF @CbrType = 3 BEGIN
	SET @TypeName = 'Equifax Req (DTEC)';
	SET @TypeDesc = 'Equifax DTEC';
END;
ELSE IF @CbrType = 4 BEGIN
	SET @TypeName = 'TU Req (SSN)';
	SET @TypeDesc = 'TransUnion Dtec';
END;
ELSE IF @CbrType = 11 BEGIN
	SET @TypeName = 'TU Req (FULL)';
	SET @TypeDesc = 'TransUnion Full';
END;
ELSE IF @CbrType = 12 BEGIN
	SET @TypeName = 'TU Req (FINDERS)';
	SET @TypeDesc = 'TransUnion Fact';
END;
ELSE IF @CbrType = 13 BEGIN
	SET @TypeName = 'Experian(SSN)';
	SET @TypeDesc = 'Experian SSN';
END;
ELSE IF @CbrType = 14 BEGIN
	SET @TypeName = 'Experian(FINDERS)';
	SET @TypeDesc = 'Experian Collect';
END;
ELSE BEGIN
	SET @CbrType = 15;
	SET @TypeName = 'Experian(FULL)';
	SET @TypeDesc = 'Experian Full';
END;

SET @CoDebtor = COALESCE(@CoDebtor, 0);

DECLARE @Requests TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[Number] INTEGER NOT NULL,
	[Seq] INTEGER NOT NULL,
	[City] VARCHAR(30) NULL,
	[State] CHAR(2) NULL,
	[ZipCode] VARCHAR(10) NULL,
	[FirstName] VARCHAR(20) NULL,
	[LastName] VARCHAR(30) NULL,
	[MiddleName] VARCHAR(5) NULL,
	[Street] VARCHAR(30) NULL,
	[StreetName] VARCHAR(30) NULL,
	[StreetNumber] VARCHAR(10) NULL,
	[StreetDir] VARCHAR(10) NULL,
	[NameSuffix] VARCHAR(10) NULL,
	[SSN] VARCHAR(15) NULL,
	[Requested] BIT NOT NULL
);

INSERT INTO @Requests ([Number], [Seq], [City], [State], [ZipCode], [FirstName], [LastName], [MiddleName], [Street], [NameSuffix], [SSN], [Requested])
SELECT [master].[number],
	[Debtors].[Seq],
	LEFT([Debtors].[City], 30),
	LEFT([Debtors].[State], 2),
	LEFT([Debtors].[ZipCode], 10),
	LEFT(CASE
		WHEN [Debtors].[FirstName] IS NOT NULL THEN [Debtors].[FirstName]
		ELSE [dbo].[GetFirstNameEx]([Debtors].[Name])
	END, 20),
	LEFT(CASE
		WHEN [Debtors].[LastName] IS NOT NULL THEN [Debtors].[LastName]
		ELSE [dbo].[GetLastNameEx]([Debtors].[Name])
	END, 30),
	LEFT(CASE
		WHEN [Debtors].[MiddleName] IS NOT NULL THEN [Debtors].[MiddleName]
		ELSE [dbo].[GetMiddleNameEx]([Debtors].[Name])
	END, 5),
	LEFT([Debtors].[Street1], 30),
	LEFT([Debtors].[Suffix], 10),
	LEFT([Debtors].[SSN], 15),
	CASE
		WHEN EXISTS (
			SELECT *
			FROM [dbo].[hardcopy]
			WHERE [hardcopy].[number] = [master].[number]
			AND DATALENGTH([hardcopy].[hardCopyData]) > 0)
		THEN 1
		ELSE 0
	END
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
AND (
	(@CoDebtor = 0
		AND [master].[PSeq] = [Debtors].[Seq])
	OR (@CoDebtor = 1
		AND [master].[PSeq] + 1 = [Debtors].[Seq])
);
	
DECLARE @Street VARCHAR(30);
DECLARE @Number VARCHAR(10);
DECLARE @Name VARCHAR(30);
DECLARE @Dir VARCHAR(10);
DECLARE @Pos INTEGER;

DECLARE @Index INTEGER;

SET @Index = 1;

WHILE EXISTS (SELECT * FROM @Requests WHERE [ID] = @Index) BEGIN
	SELECT @Street = [Street]
	FROM @Requests
	WHERE [ID] = @Index;

	SET @Number = '';
	SET @Name = '';
	SET @Dir = '';

	SET @Pos = CHARINDEX(' ', @Street);

	IF @Pos > 1 BEGIN
		SET @Number = SUBSTRING(@Street, 1, @Pos - 1);
		IF ISNUMERIC(@Number) = 1
			SET @Street = SUBSTRING(@Street, @Pos + 1, 30);
		ELSE
			SET @Number = '';
	END;

	IF @Street LIKE '% RD %' BEGIN
		SET @Dir = 'RD';
		SET @Pos = CHARINDEX(' RD ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% ROAD %' BEGIN
		SET @Dir = 'RD';
		SET @Pos = CHARINDEX(' ROAD ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% AVE %' BEGIN
		SET @Dir = 'AVE';
		SET @Pos = CHARINDEX(' AVE ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% TR %' BEGIN
		SET @Dir = 'TR';
		SET @Pos = CHARINDEX(' TR ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% TERR %' BEGIN
		SET @Dir = 'TR';
		SET @Pos = CHARINDEX(' TERR ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% AVENUE %' BEGIN
		SET @Dir = 'AVE';
		SET @Pos = CHARINDEX(' AVENUE ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% LN %' BEGIN
		SET @Dir = 'LN';
		SET @Pos = CHARINDEX(' LN ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% LANE %' BEGIN
		SET @Dir = 'LN';
		SET @Pos = CHARINDEX(' LANE ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% CIR %' BEGIN
		SET @Dir = 'CIR';
		SET @Pos = CHARINDEX(' CIR ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% CIRCLE %' BEGIN
		SET @Dir = 'CIR';
		SET @Pos = CHARINDEX(' CIRCLE ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% CT %' BEGIN
		SET @Dir = 'CT';
		SET @Pos = CHARINDEX(' CT ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;
	ELSE IF @Street LIKE '% COURT %' BEGIN
		SET @Dir = 'CT';
		SET @Pos = CHARINDEX(' COURT ', @Street);
		IF @Pos > 1
			SET @Street = SUBSTRING(@Street, 1, @Pos - 1);
	END;

	SET @Name = @Street;

	UPDATE @Requests
	SET [StreetNumber] = @Number,
		[StreetName] = @Name,
		[StreetDir] = @Dir
	WHERE [ID] = @Index;

	SET @Index = @Index + 1;
END;

INSERT INTO [dbo].[future] ([Action], [LetterCode], [LetterDesc], [user0], [number], [Seq], [Entered], [Requested], [City], [State], [ZipCode], [FirstName], [LastName], [MiddleName], [StreetName], [StreetDir], [StreetNumber], [NameSuffix], [SSN])
SELECT 'CBR',
	@CbrType,
	@TypeName,
	'WorkFlow',
	[Requests].[Number],
	[Requests].[Seq],
	{ fn CURDATE() },
	{ fn CURDATE() },
	[Requests].[City],
	[Requests].[State],
	[Requests].[ZipCode],
	[Requests].[FirstName],
	[Requests].[LastName],
	[Requests].[MiddleName],
	[Requests].[StreetName],
	[Requests].[StreetDir],
	[Requests].[StreetNumber],
	[Requests].[NameSuffix],
	[Requests].[SSN]
FROM @Requests AS [Requests]
WHERE [Requests].[Requested] = 1;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [Seq], [IsPrivate])
SELECT [Requests].[Number],
	'WRK',
	GETDATE(),
	'WorkFlow',
	'+++++',
	'+++++',
	'Credit Report Requested : ' + @TypeDesc + ' - Debtor ' + CAST([Requests].[Seq] + 1 AS VARCHAR(50)),
	[Requests].[Seq],
	0
FROM @Requests AS [Requests]
WHERE [Requests].[Requested] = 1;

UPDATE [WorkFlowAcct]
SET [Comment] = CASE [Requests].[Requested]
		WHEN 1 THEN 'Credit bureau report was already requested on this account.'
		ELSE @TypeDesc + ' credit bureau report requested on account.'
	END
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Requests AS [Requests]
ON [WorkFlowAcct].[AccountID] = [Requests].[Number];

RETURN 0;
GO
