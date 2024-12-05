SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Phones_DebtorPhonePriorityView]
AS
SELECT
	number, DebtorID, PhoneTypeMapping, Active, OnHold, PhoneNumber, Priority, Attempts, LastAttempt, MasterPhoneID, DateAdded
FROM
	dbo.Phones_DebtorPhonePriorityViewBase
WHERE
	(Priority > 1) AND (Active IS NULL OR Active <> 0)

GO
