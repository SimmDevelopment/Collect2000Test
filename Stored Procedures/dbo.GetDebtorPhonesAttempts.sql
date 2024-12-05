SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDebtorPhonesAttempts] 
	@DebtorID INT
AS
BEGIN
	
	WITH cte_30daycount AS
	(
		SELECT Count(*) as Attempts30, m.PhoneTypeID as typeid
		FROM Phones_Master m INNER JOIN phones_attempts a
				ON a.MasterPhoneID = m.MasterPhoneID
		WHERE m.DebtorID = @DebtorID
			AND a.AttemptedDate >= CAST(DATEADD(DAY, -29, GETDATE()) AS DATE)
		Group By m.PhoneTypeID
	), 
	cte_7daycount AS
	(
		SELECT Count(*) as Attempts7, m.PhoneTypeID as typeid
		FROM Phones_Master m INNER JOIN phones_attempts a
				ON a.MasterPhoneID = m.MasterPhoneID
		WHERE m.DebtorID = @DebtorID
			AND a.AttemptedDate >= CAST(DATEADD(DAY, -6, GETDATE()) AS DATE)
		Group By m.PhoneTypeID
	),
	cte_phonetypes AS
	(
		SELECT t.PhoneTypeID, t.PhoneTypeDescription
		FROM Phones_Types t
	)
	SELECT t.PhoneTypeDescription as [Description], ISNULL(seven.Attempts7, 0) as attempts7, ISNULL(thirty.Attempts30, 0) as Attempts30
	FROM cte_phonetypes t INNER JOIN cte_30daycount thirty 
			ON t.PhoneTypeID = thirty.typeid
		LEFT OUTER JOIN cte_7daycount seven
			ON thirty.typeid = seven.typeid

END
GO
