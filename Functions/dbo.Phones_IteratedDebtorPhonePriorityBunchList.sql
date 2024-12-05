SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_IteratedDebtorPhonePriorityBunchList](@number INT, @DebtorID INT, @Controls VARCHAR(4),
		@PhoneTypeMapping1  INT,        @Count1  INT,
		@PhoneTypeMapping2  INT = NULL, @Count2  INT = NULL,
		@PhoneTypeMapping3  INT = NULL, @Count3  INT = NULL,
		@PhoneTypeMapping4  INT = NULL, @Count4  INT = NULL,
		@PhoneTypeMapping5  INT = NULL, @Count5  INT = NULL,
		@PhoneTypeMapping6  INT = NULL, @Count6  INT = NULL,
		@PhoneTypeMapping7  INT = NULL, @Count7  INT = NULL,
		@PhoneTypeMapping8  INT = NULL, @Count8  INT = NULL,
		@PhoneTypeMapping9  INT = NULL, @Count9  INT = NULL,
		@PhoneTypeMapping10 INT = NULL, @Count10 INT = NULL,
		@PhoneTypeMapping11 INT = NULL, @Count11 INT = NULL,
		@PhoneTypeMapping12 INT = NULL, @Count12 INT = NULL,
		@PhoneTypeMapping13 INT = NULL, @Count13 INT = NULL,
		@PhoneTypeMapping14 INT = NULL, @Count14 INT = NULL,
		@PhoneTypeMapping15 INT = NULL, @Count15 INT = NULL,
		@PhoneTypeMapping16 INT = NULL, @Count16 INT = NULL
	)
RETURNS @IteratedDebtorPhonePriorityView TABLE (
	Position INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	number INT NOT NULL,
	DebtorID INT NOT NULL,
	PhoneTypeMapping TINYINT NULL,
	Active BIT NULL,
	OnHold BIT NOT NULL,
	PhoneNumber VARCHAR(30) NOT NULL,
	Priority INT NOT NULL,
	Attempts INT NULL,
	LastAttempt DATETIME NULL,
	MasterPhoneID INT NOT NULL,
	DateAdded DATETIME NULL)
AS
BEGIN

-- include A to order by *Attempts*, otherwise orders by *DateAdded*
-- include H to include numbers which are ON HOLD, otherwise they are filtered out (only not on hold)
-- include N to include numbers which are NOT ACTIVE (aka BAD), otherwise they are filtered out (good/active and unknown only)
-- include B to group (hunch) all phone numbers together and resort, otherwise, they are sorted within the requested phone types

DECLARE @FirstIn TABLE (
	Position INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- FirstIn and SecondIn tables are identical
	number INT NOT NULL,
	DebtorID INT NOT NULL,
	PhoneTypeMapping TINYINT NULL,
	Active BIT NULL,
	OnHold BIT NOT NULL,
	PhoneNumber VARCHAR(30) NOT NULL,
	Priority INT NOT NULL,
	Attempts INT NULL,
	LastAttempt DATETIME NULL,
	MasterPhoneID INT NOT NULL,
	DateAdded DATETIME NULL)
DECLARE @SecondIn TABLE (
	Position INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	number INT NOT NULL,
	DebtorID INT NOT NULL,
	PhoneTypeMapping TINYINT NULL,
	Active BIT NULL,
	OnHold BIT NOT NULL,
	PhoneNumber VARCHAR(30) NOT NULL,
	Priority INT NOT NULL,
	Attempts INT NULL,
	LastAttempt DATETIME NULL,
	MasterPhoneID INT NOT NULL,
	DateAdded DATETIME NULL)

WHILE 1 = 1
BEGIN

	                                      INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping1,  @Controls) WHERE Position <= @Count1
	IF @PhoneTypeMapping2 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping2,  @Controls) WHERE Position <= @Count2
	IF @PhoneTypeMapping3 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping3,  @Controls) WHERE Position <= @Count3
	IF @PhoneTypeMapping4 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping4,  @Controls) WHERE Position <= @Count4
	IF @PhoneTypeMapping5 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping5,  @Controls) WHERE Position <= @Count5
	IF @PhoneTypeMapping6 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping6,  @Controls) WHERE Position <= @Count6
	IF @PhoneTypeMapping7 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping7,  @Controls) WHERE Position <= @Count7
	IF @PhoneTypeMapping8 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping8,  @Controls) WHERE Position <= @Count8
	IF @PhoneTypeMapping9 IS NULL BREAK   INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping9,  @Controls) WHERE Position <= @Count9
	IF @PhoneTypeMapping10 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping10, @Controls) WHERE Position <= @Count10
	IF @PhoneTypeMapping11 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping11, @Controls) WHERE Position <= @Count11
	IF @PhoneTypeMapping12 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping12, @Controls) WHERE Position <= @Count12
	IF @PhoneTypeMapping13 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping13, @Controls) WHERE Position <= @Count13
	IF @PhoneTypeMapping14 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping14, @Controls) WHERE Position <= @Count14
	IF @PhoneTypeMapping15 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping15, @Controls) WHERE Position <= @Count15
	IF @PhoneTypeMapping16 IS NULL BREAK  INSERT INTO @FirstIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded) SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded FROM dbo.Phones_IteratedDebtorPhonePriorityList(@number, @DebtorID, @PhoneTypeMapping16, @Controls) WHERE Position <= @Count16
	BREAK

END

IF CHARINDEX('B', @Controls) <> 0
BEGIN

	IF CHARINDEX('A', @Controls) <> 0
		INSERT INTO @SecondIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID)
		SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID FROM @FirstIn
		ORDER BY Priority DESC, Attempts ASC, MasterPhoneID DESC
	ELSE
		INSERT INTO @SecondIn (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID)
		SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID FROM @FirstIn
		ORDER BY Priority DESC, DateAdded ASC, MasterPhoneID ASC
	
	INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID)
	SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID FROM @SecondIn

END
ELSE
BEGIN

	INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID)
	SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID FROM @FirstIn

END

RETURN
END

GO
