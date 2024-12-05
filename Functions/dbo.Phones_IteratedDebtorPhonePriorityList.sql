SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Phones_IteratedDebtorPhonePriorityList](@number INT, @DebtorID INT, @PhoneTypeMapping INT, @Controls VARCHAR(4))
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

IF CHARINDEX('A', @Controls) <> 0
BEGIN

	IF CHARINDEX('H', @Controls) <> 0
	BEGIN
	
		IF CHARINDEX('N', @Controls) <> 0

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (1 = 1) AND (1 = 1)
			ORDER BY Priority DESC, Attempts ASC, MasterPhoneID DESC

		ELSE

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (Active IS NULL OR Active <> 0) AND (1 = 1)
			ORDER BY Priority DESC, Attempts ASC, MasterPhoneID DESC

	END
	ELSE
	BEGIN

		IF CHARINDEX('N', @Controls) <> 0

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (1 = 1) AND (OnHold IS NULL OR OnHold = 0)
			ORDER BY Priority DESC, Attempts ASC, MasterPhoneID DESC

		ELSE

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (Active IS NULL OR Active <> 0) AND (OnHold IS NULL OR OnHold = 0)
			ORDER BY Priority DESC, Attempts ASC, MasterPhoneID DESC
		
	END
	
END
ELSE
BEGIN

	IF CHARINDEX('H', @Controls) <> 0
	BEGIN

		IF CHARINDEX('N', @Controls) <> 0

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (1 = 1) AND (1 = 1)
			ORDER BY Priority DESC, DateAdded ASC, MasterPhoneID ASC

		ELSE

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (Active IS NULL OR Active <> 0) AND (1 = 1)
			ORDER BY Priority DESC, DateAdded ASC, MasterPhoneID ASC

	END
	ELSE
	BEGIN

		IF CHARINDEX('N', @Controls) <> 0

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (1 = 1) AND (OnHold IS NULL OR OnHold = 0)
			ORDER BY Priority DESC, DateAdded ASC, MasterPhoneID ASC

		ELSE

			INSERT INTO @IteratedDebtorPhonePriorityView (number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded)
			SELECT number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
			FROM Phones_DebtorPhonePriorityViewBase WHERE number = @number AND DebtorID = @DebtorID AND PhoneTypeMapping = @PhoneTypeMapping
			AND (Active IS NULL OR Active <> 0) AND (OnHold IS NULL OR OnHold = 0)
			ORDER BY Priority DESC, DateAdded ASC, MasterPhoneID ASC
		
	END

END

RETURN END

GO
