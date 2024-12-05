SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[CallPreferences]
AS

WITH CTE_CP AS
(SELECT DISTINCT pm.MasterPhoneID, pm.PhoneNumber, pm.PhoneExt, pm.Number, pm.DebtorID,
	ISNULL(CASE DATENAME(WEEKDAY, GETDATE())
		WHEN 'Sunday' THEN SundayDoNotCall
		WHEN 'Monday' THEN MondayDoNotCall
		WHEN 'Tuesday' THEN TuesdayDoNotCall
		WHEN 'Wednesday' THEN WednesdayDoNotCall
		WHEN 'Thursday' THEN ThursdayDoNotCall
		WHEN 'Friday' THEN FridayDoNotCall
		WHEN 'Saturday' THEN SaturdayDoNotCall
	END, 0) AS DoNotCall,
	CASE DATENAME(WEEKDAY, GETDATE())
		WHEN 'Sunday' THEN SundayCallWindowStart
		WHEN 'Monday' THEN MondayCallWindowStart
		WHEN 'Tuesday' THEN TuesdayCallWindowStart
		WHEN 'Wednesday' THEN WednesdayCallWindowStart
		WHEN 'Thursday' THEN ThursdayCallWindowStart
		WHEN 'Friday' THEN FridayCallWindowStart
		WHEN 'Saturday' THEN SaturdayCallWindowStart
	END AS CallWindowStart,
	CASE DATENAME(WEEKDAY, GETDATE())
		WHEN 'Sunday' THEN SundayCallWindowEnd
		WHEN 'Monday' THEN MondayCallWindowEnd
		WHEN 'Tuesday' THEN TuesdayCallWindowEnd
		WHEN 'Wednesday' THEN WednesdayCallWindowEnd
		WHEN 'Thursday' THEN ThursdayCallWindowEnd
		WHEN 'Friday' THEN FridayCallWindowEnd
		WHEN 'Saturday' THEN SaturdayCallWindowEnd
	END AS CallWindowEnd,
	CASE DATENAME(WEEKDAY, GETDATE())
		WHEN 'Sunday' THEN SundayNoCallWindowStart
		WHEN 'Monday' THEN MondayNoCallWindowStart
		WHEN 'Tuesday' THEN TuesdayNoCallWindowStart
		WHEN 'Wednesday' THEN WednesdayNoCallWindowStart
		WHEN 'Thursday' THEN ThursdayNoCallWindowStart
		WHEN 'Friday' THEN FridayNoCallWindowStart
		WHEN 'Saturday' THEN SaturdayNoCallWindowStart
	END AS NoCallWindowStart,
	CASE DATENAME(WEEKDAY, GETDATE())
		WHEN 'Sunday' THEN SundayNoCallWindowEnd
		WHEN 'Monday' THEN MondayNoCallWindowEnd
		WHEN 'Tuesday' THEN TuesdayNoCallWindowEnd
		WHEN 'Wednesday' THEN WednesdayNoCallWindowEnd
		WHEN 'Thursday' THEN ThursdayNoCallWindowEnd
		WHEN 'Friday' THEN FridayNoCallWindowEnd
		WHEN 'Saturday' THEN SaturdayNoCallWindowEnd
	END AS NoCallWindowEnd,
	d.NextAllowableCallAttemptDate,
	'Today' AS [When]
FROM Phones_Master pm
LEFT JOIN Phones_Preferences pp ON pp.MasterPhoneId = pm.MasterPhoneID
INNER JOIN Debtors d ON d.DebtorID = pm.DebtorID

UNION

SELECT DISTINCT pm.MasterPhoneID, pm.PhoneNumber, pm.PhoneExt, pm.Number, pm.DebtorID,
	ISNULL(CASE DATENAME(WEEKDAY, DATEADD(DAY, 1, GETDATE()))
		WHEN 'Sunday' THEN SundayDoNotCall
		WHEN 'Monday' THEN MondayDoNotCall
		WHEN 'Tuesday' THEN TuesdayDoNotCall
		WHEN 'Wednesday' THEN WednesdayDoNotCall
		WHEN 'Thursday' THEN ThursdayDoNotCall
		WHEN 'Friday' THEN FridayDoNotCall
		WHEN 'Saturday' THEN SaturdayDoNotCall
	END, 0) AS DoNotCall,
	CASE DATENAME(WEEKDAY, DATEADD(DAY, 1, GETDATE()))
		WHEN 'Sunday' THEN SundayCallWindowStart
		WHEN 'Monday' THEN MondayCallWindowStart
		WHEN 'Tuesday' THEN TuesdayCallWindowStart
		WHEN 'Wednesday' THEN WednesdayCallWindowStart
		WHEN 'Thursday' THEN ThursdayCallWindowStart
		WHEN 'Friday' THEN FridayCallWindowStart
		WHEN 'Saturday' THEN SaturdayCallWindowStart
	END AS CallWindowStart,
	CASE DATENAME(WEEKDAY, DATEADD(DAY, 1, GETDATE()))
		WHEN 'Sunday' THEN SundayCallWindowEnd
		WHEN 'Monday' THEN MondayCallWindowEnd
		WHEN 'Tuesday' THEN TuesdayCallWindowEnd
		WHEN 'Wednesday' THEN WednesdayCallWindowEnd
		WHEN 'Thursday' THEN ThursdayCallWindowEnd
		WHEN 'Friday' THEN FridayCallWindowEnd
		WHEN 'Saturday' THEN SaturdayCallWindowEnd
	END AS CallWindowEnd,
	CASE DATENAME(WEEKDAY, DATEADD(DAY, 1, GETDATE()))
		WHEN 'Sunday' THEN SundayNoCallWindowStart
		WHEN 'Monday' THEN MondayNoCallWindowStart
		WHEN 'Tuesday' THEN TuesdayNoCallWindowStart
		WHEN 'Wednesday' THEN WednesdayNoCallWindowStart
		WHEN 'Thursday' THEN ThursdayNoCallWindowStart
		WHEN 'Friday' THEN FridayNoCallWindowStart
		WHEN 'Saturday' THEN SaturdayNoCallWindowStart
	END AS NoCallWindowStart,
	CASE DATENAME(WEEKDAY, DATEADD(DAY, 1, GETDATE()))
		WHEN 'Sunday' THEN SundayNoCallWindowEnd
		WHEN 'Monday' THEN MondayNoCallWindowEnd
		WHEN 'Tuesday' THEN TuesdayNoCallWindowEnd
		WHEN 'Wednesday' THEN WednesdayNoCallWindowEnd
		WHEN 'Thursday' THEN ThursdayNoCallWindowEnd
		WHEN 'Friday' THEN FridayNoCallWindowEnd
		WHEN 'Saturday' THEN SaturdayNoCallWindowEnd
	END AS NoCallWindowEnd,
	d.NextAllowableCallAttemptDate,
	'Tomorrow' AS [When]
FROM Phones_Master pm
LEFT JOIN Phones_Preferences pp ON pp.MasterPhoneId = pm.MasterPhoneID
INNER JOIN Debtors d ON d.DebtorID = pm.DebtorID)
SELECT MasterPhoneID, PhoneNumber, PhoneExt, Number, DebtorID, DoNotCall, 
CASE WHEN CallWindowStart <> '' THEN CallWindowStart ELSE NULL END AS CallWindowStart, 
CASE WHEN CallWindowEnd <> '' THEN CallWindowEnd ELSE NULL END AS CallWindowEnd, 
CASE WHEN NoCallWindowStart <> '' THEN NoCallWindowStart ELSE NULL END AS NoCallWindowStart, 
CASE WHEN NoCallWindowEnd <> '' THEN NoCallWindowEnd ELSE NULL END AS NoCallWindowEnd, 
NextAllowableCallAttemptDate, [When], CASE WHEN DoNotCall = 0 AND ISNULL(CallWindowStart,'') = '' AND ISNULL(CallWindowEnd,'') = '' AND 
ISNULL(NoCallWindowStart,'') = '' AND ISNULL(NoCallWindowEnd,'') = '' THEN 1 ELSE
(select dbo.IsAllowedtoCall(CallWindowStart,CallWindowEnd,NoCallWindowStart,NoCallWindowEnd,DebtorID,DoNotCall,(DATEPART(Hour,dbo.GetDebtorsLocalTime(DebtorID))))) END AS AllowedNow,

--CASE WHEN (DATEPART(HOUR,dbo.getdebtorslocaltime(DebtorID)) BETWEEN ISNULL(CallWindowStart,0) AND ISNULL(CallWindowEnd,0) - 1) AND DoNotCall = 0 THEN 1 ELSE 0 END END AS AllowedNow, 
CASE 
	WHEN NOT EXISTS (SELECT 1 FROM AppliedPermissions ap
	INNER JOIN Permissions p ON p.ID = ap.PermissionID
	WHERE p.PermissionName = 'Call Attempt and Conversation Limits' AND ap.Configured = 1) THEN 1
	WHEN NextAllowableCallAttemptDate IS NULL THEN 1 
	WHEN NextAllowableCallAttemptDate = CONVERT(DATE, GETDATE())
	THEN 1 ELSE 0 END AS AllowedToday,
CASE 
	WHEN NOT EXISTS (SELECT 1 FROM AppliedPermissions ap
	INNER JOIN Permissions p ON p.ID = ap.PermissionID
	WHERE p.PermissionName = 'Call Attempt and Conversation Limits' AND ap.Configured = 1) THEN 1
	WHEN NextAllowableCallAttemptDate IS NULL THEN 1 
	WHEN NextAllowableCallAttemptDate = CONVERT(DATE, DATEADD(DAY, 1, GETDATE()))
	THEN 1 ELSE 0 END AS AllowedTomorrow 
FROM CTE_CP;

GO
