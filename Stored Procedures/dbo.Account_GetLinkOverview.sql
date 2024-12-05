SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Account_GetLinkOverview] @LinkID INTEGER
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT 'Account Information' AS [SectionName],
	'Customers' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[master].[customer] AS [Customer Code:format(Upper Case)],
	[customer].[name] AS [Customer:format(Proper Case)],
	[master].[received] AS [Received Date:format(Short Date)],
	[master].[original] AS [Original Balance:format(Currency)],
	[master].[current0] AS [Current Balance:format(Currency)]
FROM [dbo].[master]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
WHERE [master].[link] = @LinkID
ORDER BY [master].[received] DESC;

SELECT 'Account Information' AS [SectionName],
	'Restrictions' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Debtors].[Name] AS [Debtor:format(Proper Case)],
	'No Home Calls' AS [Restriction]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[restrictions]
ON [Debtors].[DebtorID] = [restrictions].[DebtorID]
WHERE [master].[link] = @LinkID
AND [restrictions].[home] = 1
AND [restrictions].[calls] = 0
UNION ALL
SELECT [master].[number],
	[Debtors].[Name],
	'No Work Calls'
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[restrictions]
ON [Debtors].[DebtorID] = [restrictions].[DebtorID]
WHERE [master].[link] = @LinkID
AND [restrictions].[job] = 1
AND [restrictions].[calls] = 0
UNION ALL
SELECT [master].[number],
	[Debtors].[Name],
	'No Phone Calls'
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[restrictions]
ON [Debtors].[DebtorID] = [restrictions].[DebtorID]
WHERE [master].[link] = @LinkID
AND [restrictions].[calls] = 1
UNION ALL
SELECT [master].[number],
	[Debtors].[Name],
	'No Letters'
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[restrictions]
ON [Debtors].[DebtorID] = [restrictions].[DebtorID]
WHERE [master].[link] = @LinkID
AND [restrictions].[suppressletters] = 1
UNION ALL
SELECT [master].[number],
	[Debtors].[Name],
	'Disputed'
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[restrictions]
ON [Debtors].[DebtorID] = [restrictions].[DebtorID]
WHERE [master].[link] = @LinkID
AND [restrictions].[disputed] > 0
ORDER BY [Account ID] ASC;

SELECT 'Account Information' AS [SectionName],
	'Transactions' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[payhistory].[datepaid] AS [Date Paid:format(Short Date)],
	[payhistory].[batchtype] AS [Batch Type:format(Upper Case)],
	[payhistory].[paytype] AS [Pay Type:format(Proper Case)],
	[payhistory].[totalpaid] AS [Total Paid:format(Currency)]
FROM [dbo].[master]
INNER JOIN [dbo].[payhistory]
ON [master].[number] = [payhistory].[number]
WHERE [master].[link] = @LinkID
AND [payhistory].[batchtype] LIKE '[PD]%'
ORDER BY [payhistory].[datepaid] DESC;

SELECT 'Account Information' AS [SectionName],
	'Status' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[master].[status] AS [Status Code:format(Upper Case)],
	[status].[Description] AS [Description:format(Proper Case)],
	MAX(COALESCE([StatusHistory].[DateChanged], [master].[received])) AS [Last Changed:format(General Date)]
FROM [dbo].[master]
INNER JOIN [dbo].[status]
ON [master].[status] = [status].[code]
LEFT OUTER JOIN [dbo].[StatusHistory]
ON [master].[number] = [StatusHistory].[AccountID]
AND [master].[status] = [StatusHistory].[NewStatus]
WHERE [master].[link] = @LinkID
GROUP BY [master].[number],
	[master].[status],
	[status].[Description]
ORDER BY MAX(COALESCE([StatusHistory].[DateChanged], [master].[received])) DESC;

SELECT 'Account Information' AS [SectionName],
	'Desk Distribution (Open Accounts)' AS [SubSectionName];

SELECT [master].[desk] AS [Desk Code:format(Upper Case)],
	[desk].[name] AS [Desk:format(Proper Case)],
	[desk].[desktype] AS [Type:format(Proper Case)],
	COUNT([master].[number]) AS [Accounts #],
	SUM([master].[current0]) AS [Balance:format(Currency)],
	MAX([master].[worked]) AS [Last Worked:format(General Date):nz(Never)],
	MAX([master].[contacted]) AS [Last Contacted:format(General Date):nz(Never)],
	[master].[desk] AS [Action:link(SetDesk, Set Desk)]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
WHERE [master].[link] = @LinkID
AND [master].[qlevel] NOT IN ('998', '999')
GROUP BY [master].[desk],
	[desk].[name],
	[desk].[desktype]
ORDER BY MAX([master].[worked]) DESC,
	MAX([master].[contacted]) DESC;

SELECT 'Account Information' AS [SectionName],
	'Desk Assignments' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[master].[desk] AS [Desk Code:format(Upper Case)],
	[desk].[name] AS [Desk:format(Proper Case)],
	[desk].[desktype] AS [Type:format(Proper Case)],
	[BranchCodes].[Name] AS [Branch:format(Proper Case)]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
INNER JOIN [dbo].[Teams]
ON [desk].[TeamID] = [Teams].[ID]
INNER JOIN [dbo].[Departments]
ON [Teams].[DepartmentID] = [Departments].[ID]
INNER JOIN [dbo].[BranchCodes]
ON [Departments].[Branch] = [BranchCodes].[Code]
WHERE [master].[link] = @LinkID
AND NOT [master].[qlevel] IN ('998', '999')
ORDER BY [desk].[desktype],
	[desk].[code],
	[master].[number];

SELECT 'Account Information' AS [SectionName],
	'Support Queue Items' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[QLevel].[QName] AS [Queue:format(Proper Case)],
	[SupportQueueItems].[DateAdded] AS [Added:format(Short Date)],
	[SupportQueueItems].[DateDue] AS [Due:format(Short Date)],
	[SupportQueueItems].[UserName] AS [User:format(Proper Case)],
	[SupportQueueItems].[Comment] AS [Comment:format(Proper Case)]
FROM [dbo].[master]
INNER JOIN [SupportQueueItems]
ON [master].[number] = [SupportQueueItems].[AccountID]
INNER JOIN [dbo].[qlevel]
ON [SupportQueueItems].[QueueCode] = [qlevel].[code]
WHERE [master].[link] = @LinkID
ORDER BY [DateDue] DESC,
	[DateAdded] ASC;

SELECT 'Account Information' AS [SectionName],
	'Patient Information' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[PatientInfo].[Name] AS [Patient Name:format(Proper Case)],
	[PatientInfo].[FacilityName] AS [Facility:format(Proper Case)],
	[PatientInfo].[AdmissionDate] AS [Admission:format(Short Date)],
	[PatientInfo].[ServiceDate] AS [Service:format(Short Date)],
	[PatientInfo].[DischargeDate] AS [Discharge:format(Short Date)]
FROM [dbo].[master]
INNER JOIN [dbo].[PatientInfo]
ON [master].[number] = [PatientInfo].[AccountID]
WHERE [master].[link] = @LinkID
ORDER BY [master].[received] DESC;

SELECT 'Demographics' AS [SectionName],
	'Phone Numbers' AS [SubSectionName];

SELECT [Phones_Types].[PhoneTypeDescription] AS [Type],
	[dbo].[fnFormatPhone]([Phones_Master].[PhoneNumber], [Phones_Master].[PhoneExt]) AS [Phone Number],
	COALESCE([Phones_Statuses].[PhoneStatusDescription], 'Unknown') + CASE [Phones_Master].[OnHold] WHEN 1 THEN ' (Hold)' ELSE '' END AS [Status],
	COALESCE(COALESCE([NearbyContacts].[Type], 'Nearby') + ': ' + [NearbyContacts].[LName] + ',' + [NearbyContacts].[FName], [Debtors].[Name], '') AS [Debtor],
	COALESCE((SELECT COUNT(*)
		FROM [dbo].[Phones_Attempts]
		WHERE [Phones_Attempts].[MasterPhoneID] = [Phones_Master].[MasterPhoneID]
		AND [Phones_Attempts].[Active] = 1), 0) AS [Attempts],
	(SELECT MAX([Phones_Attempts].[AttemptedDate])
		FROM [dbo].[Phones_Attempts]
		WHERE [Phones_Attempts].[MasterPhoneID] = [Phones_Master].[MasterPhoneID]
		AND [Phones_Attempts].[Active] = 1) AS [LastAttempt:format(Short Date):nz(Never)]
FROM [dbo].[master]
INNER JOIN [dbo].[Phones_Master]
ON [master].[number] = [Phones_Master].[Number]
INNER JOIN [dbo].[Phones_Types]
ON [Phones_Types].[PhoneTypeID] = [Phones_Master].[PhoneTypeID]
LEFT OUTER JOIN [dbo].[Phones_Statuses]
ON [Phones_Statuses].[PhoneStatusID] = [Phones_Master].[PhoneStatusID]
LEFT OUTER JOIN [dbo].[NearbyContacts]
ON [NearbyContacts].[NearbyContactID] = [Phones_Master].[NearbyContactID]
LEFT OUTER JOIN [dbo].[Debtors]
ON [Debtors].[DebtorID] = [Phones_Master].[DebtorID]
WHERE [master].[link] = @LinkID
AND ([Phones_Master].[PhoneStatusID] IS NULL
	OR [Phones_Statuses].[Active] IS NULL
	OR [Phones_Statuses].[Active] = 1);
	
/*

SELECT 'Home' AS [Type],
	[Debtors].[homephone] AS [Phone],
	MAX(COALESCE([PhoneHistory].[DateChanged], [master].[received])) AS [Updated:format(General Date)],
	'H' + CAST(MIN([Debtors].[DebtorID]) AS VARCHAR(15)) AS [Action:link(SetPhone, Set Phone)]
FROM [dbo].[Debtors]
INNER JOIN [dbo].[master]
ON [Debtors].[number] = [master].[number]
LEFT OUTER JOIN [dbo].[PhoneHistory]
ON [master].[number] = [PhoneHistory].[AccountID]
AND [Debtors].[DebtorID] = [PhoneHistory].[DebtorID]
AND [PhoneHistory].[NewNumber] = [Debtors].[homephone]
WHERE [master].[link] = @LinkID
AND [Debtors].[homephone] > '0'
AND [Debtors].[Responsible] = 1
GROUP BY [Debtors].[homephone]
UNION ALL
SELECT 'Work',
	[Debtors].[workphone],
	MAX(COALESCE([PhoneHistory].[DateChanged], [master].[received])),
	'W' + CAST(MIN([Debtors].[DebtorID]) AS VARCHAR(15))
FROM [dbo].[Debtors]
INNER JOIN [dbo].[master]
ON [Debtors].[number] = [master].[number]
LEFT OUTER JOIN [dbo].[PhoneHistory]
ON [master].[number] = [PhoneHistory].[AccountID]
AND [Debtors].[DebtorID] = [PhoneHistory].[DebtorID]
AND [PhoneHistory].[NewNumber] = [Debtors].[homephone]
WHERE [master].[link] = @LinkID
AND [Debtors].[workphone] > '0'
AND [Debtors].[Responsible] = 1
GROUP BY [Debtors].[workphone]
ORDER BY [Updated:format(General Date)] DESC;

*/

SELECT 'Demographics' AS [SectionName],
	'Addresses' AS [SubSectionName];

SELECT [Debtors].[Street1] AS [Street:format(Proper Case)],
	[Debtors].[Street2] AS [Street 2:format(Proper Case)],
	[Debtors].[City] AS [City:format(Proper Case)],
	[Debtors].[State] AS [State:format(Upper Case)],
	[Debtors].[ZipCode] AS [ZipCode],
	MAX(COALESCE([AddressHistory].[DateChanged], [master].[received])) AS [LastUpdated:format(General Date)],
	CASE [Debtors].[MR]
		WHEN 'Y' THEN 'Bad Address'
		ELSE 'Good Address'
	END AS [Mail Return],
	MIN([Debtors].[DebtorID]) AS [Action:link(SetAddress,Set Address)]
FROM [dbo].[Debtors]
INNER JOIN [dbo].[master]
ON [master].[number] = [Debtors].[number]
LEFT OUTER JOIN [dbo].[AddressHistory]
ON [master].[number] = [AddressHistory].[AccountID]
AND [Debtors].[DebtorID] = [AddressHistory].[DebtorID]
WHERE [master].[link] = @LinkID
AND [Debtors].[Responsible] = 1
GROUP BY [Debtors].[Street1],
	[Debtors].[Street2],
	[Debtors].[City],
	[Debtors].[State],
	[Debtors].[ZipCode],
	[Debtors].[MR]
ORDER BY [LastUpdated:format(General Date)] DESC;

SELECT 'Research' AS [SectionName],
	'Services' AS [SubSectionName];

SELECT [master].[number] AS [AccountID],
	[Services].[Description] AS [Service:format(Proper Case)],
	[ServiceHistory].[CreationDate] AS [Requested:format(General Date)],
	[ServiceHistory].[ReturnedDate] AS [Returned:format(General Date)],
	[master].[number] AS [View:link(ViewService,View Service)]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[ServiceHistory] WITH (INDEX(IX_ServiceHistory_DebtorID))
ON [Debtors].[DebtorID] = [ServiceHistory].[DebtorID]
INNER JOIN [dbo].[Services]
ON [ServiceHistory].[ServiceID] = [Services].[ServiceID]
WHERE [master].[link] = @LinkID
ORDER BY [ReturnedDate] DESC;

SELECT 'Research' AS [SectionName],
	'Credit Bureau Reports' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[master].[number] AS [View:link(ViewCBR,View Credit Bureau Report)]
FROM [dbo].[master]
INNER JOIN [dbo].[hardcopy]
ON [master].[number] = [hardcopy].[number]
WHERE [master].[link] = @LinkID;

SELECT 'Research' AS [SectionName],
	'Nearby Contacts' AS [SubSectionName];

SELECT COALESCE([NearbyContacts].[Type], 'Nearby') AS [Type],
	COALESCE([NearbyContacts].[LName] + ', ', '') +
		COALESCE([NearbyContacts].[FName] + COALESCE(' ' + [NearbyContacts].[MI], '') , '') AS [Name],
	COALESCE([NearbyContacts].[Addr1] + ' ', '') +
		COALESCE([NearbyContacts].[Addr2] + ' ', '') +
		COALESCE([NearbyContacts].[City] + ', ', '') + COALESCE([NearbyContacts].[State], '') + COALESCE(' ' + [NearbyContacts].[Zip], '') AS [Address]
FROM [dbo].[master]
INNER JOIN [dbo].[NearbyContacts]
ON [master].[number] = [NearbyContacts].[number]
WHERE [master].[link] = @LinkID;

SELECT 'Work Effort' AS [SectionName],
	'Statistics' AS [SubSectionName];

SELECT CASE GROUPING([master].[number])
		WHEN 1 THEN 'All Accounts'
		ELSE CAST([master].[number] AS VARCHAR(15))
	END AS [Account ID],
	SUM([master].[TotalViewed]) AS [Total Viewed],
	SUM([master].[TotalWorked]) AS [Total Worked],
	SUM([master].[TotalContacted]) AS [Total Contacted],
	MAX([master].[Worked]) AS [Last Worked:format(General Date):nz(Never)],
	MAX([master].[Contacted]) AS [Last Contacted:format(General Date):nz(Never)]
FROM [dbo].[master]
WHERE [master].[link] = @LinkID
GROUP BY [master].[number] WITH ROLLUP
ORDER BY GROUPING([master].[number]) DESC,
	MAX([master].[Contacted]) DESC,
	MAX([master].[Worked]) DESC,
	SUM([master].[TotalContacted]) DESC,
	SUM([master].[TotalWorked]) DESC,
	SUM([master].[TotalViewed]) DESC;

SELECT 'Work Effort' AS [SectionName],
	'Arrangements' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	'Promise' AS [Type],
	[Promises].[Entered] AS [Entered:format(General Date)],
	[Promises].[DueDate] AS [Due:format(General Date)],
	[Promises].[Amount] AS [Amount:format(Currency)]
FROM [dbo].[master]
INNER JOIN [dbo].[Promises]
ON [master].[number] = [Promises].[AcctID]
WHERE [master].[link] = @LinkID
AND [Promises].[Active] = 1
UNION ALL
SELECT [master].[number],
	'Post-Dated Check' AS [Type],
	[pdc].[entered],
	[pdc].[deposit],
	[pdc].[amount]
FROM [dbo].[master]
INNER JOIN [dbo].[pdc]
ON [master].[number] = [pdc].[number]
WHERE [master].[link] = @LinkID
AND [pdc].[Active] = 1
UNION ALL
SELECT [master].[number],
	'Credit Card' AS [Type],
	[DebtorCreditCards].[DateEntered],
	[DebtorCreditCards].[DepositDate],
	[DebtorCreditCards].[Amount]
FROM [dbo].[master]
INNER JOIN [dbo].[DebtorCreditCards]
ON [master].[number] = [DebtorCreditCards].[number]
WHERE [master].[link] = @LinkID
AND [DebtorCreditCards].[IsActive] = 1
ORDER BY [DueDate] ASC;

SELECT 'Work Effort' AS [SectionName],
	'Letters' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[letter].[code] AS [Letter Code],
	[letter].[Description] AS [Letter:format(Proper Case)],
	[Debtors].[Name] AS [Debtor:format(Proper Case)],
	[LetterRequest].[DateRequested] AS [Requested:format(Short Date)],
	[LetterRequest].[DueDate] AS [Due Date:format(Short Date):nz(N/A)],
	[LetterRequest].[AmountDue] AS [Amount Due:format(Currency):nz(N/A)],
	[LetterRequest].[UserName] AS [Requested By:nz(System)]
FROM [dbo].[master]
INNER JOIN [dbo].[LetterRequest]
ON [master].[number] = [LetterRequest].[AccountID]
INNER JOIN [dbo].[letter]
ON [LetterRequest].[LetterID] = [letter].[LetterID]
INNER JOIN [dbo].[Debtors]
ON [LetterRequest].[SubjDebtorID] = [Debtors].[DebtorID]
WHERE [master].[link] = @LinkID
ORDER BY [LetterRequest].[DateRequested] DESC;

SELECT 'Work Effort' AS [SectionName],
	'Reminders' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Reminders].[Due] AS [Due:tzToLocal():format(General Date)],
	CASE [Reminders].[FollowAccountDesk]
		WHEN 0 THEN [Reminders].[Desk]
		ELSE [master].[desk]
	END AS [Desk Code:format(Upper Case)],
	[desk].[name] AS [Desk:format(Proper Case)]
FROM [dbo].[master]
INNER JOIN [dbo].[Reminders]
ON [master].[number] = [Reminders].[AccountID]
INNER JOIN [dbo].[desk]
ON CASE [Reminders].[FollowAccountDesk] WHEN 0 THEN [Reminders].[Desk] ELSE [master].[desk] END = [desk].[code]
WHERE [master].[link] = @LinkID
AND [master].[qlevel] NOT IN ('998', '999');

SELECT 'Legal' AS [SectionName],
	'Representation' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Debtors].[name] AS [Debtor:format(Proper Case)],
	[DebtorAttorneys].[Firm] AS [Firm:format(Proper Case)],
	[DebtorAttorneys].[Name] AS [Attorney:format(Proper Case)],
	[DebtorAttorneys].[Phone] AS [Phone]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[DebtorAttorneys]
ON [Debtors].[number] = [DebtorAttorneys].[AccountID]
AND [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID]
WHERE [master].[link] = @LinkID
ORDER BY [master].[number];

SELECT 'Legal' AS [SectionName],
	'Court Cases' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[CourtCases].[CaseNumber] AS [Case #],
	[CourtCases].[Status] AS [Status:format(Proper Case)],
	[CourtCases].[DateFiled] AS [Filed:format(Short Date)],
	[Courts].[County] + ', ' + [Courts].[State] AS [County:format(Proper Case)],
	[CourtCases].[CourtDate] AS [Court Date:format(General Date)]
FROM [dbo].[master]
INNER JOIN [dbo].[CourtCases]
ON [master].[number] = [CourtCases].[AccountID]
INNER JOIN [dbo].[Courts]
ON [CourtCases].[CourtID] = [Courts].[CourtID]
WHERE [master].[link] = @LinkID
ORDER BY [CourtCases].[CourtDate] DESC,
	[CourtCases].[DateFiled] DESC;

SELECT 'Legal' AS [SectionName],
	'Judgments' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Courts].[County] + ', ' + [Courts].[State] AS [County:format(Proper Case)],
	[CourtCases].[JudgementDate] AS [Judgment Date:format(Short Date)],
	ISNULL([CourtCases].[JudgementAmt], 0) + 
		ISNULL([CourtCases].[JudgementIntAward], 0) +
		ISNULL([CourtCases].[JudgementAttorneyCostAward], 0) +
		ISNULL([CourtCases].[JudgementCostAward], 0) +
		ISNULL([CourtCases].[JudgementOtherAward], 0) AS [Total Award:format(Currency)],
	[CourtCases].[JudgementIntRate] AS [Interest Rate:format(Percent)]
FROM [dbo].[master]
INNER JOIN [dbo].[CourtCases]
ON [master].[number] = [CourtCases].[AccountID]
INNER JOIN [dbo].[Courts]
ON [CourtCases].[CourtID] = [Courts].[CourtID]
WHERE [master].[link] = @LinkID
AND [CourtCases].[Judgement] = 1
ORDER BY [CourtCases].[JudgementDate] DESC;

SELECT 'Legal' AS [SectionName],
	'Bankruptcy' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Debtors].[Name] AS [Debtor:format(Proper Case)],
	[Bankruptcy].[Chapter],
	[Bankruptcy].[DateFiled] AS [Date Filed:format(Short Date)],
	[Bankruptcy].[Status]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[Bankruptcy]
ON [Debtors].[number] = [Bankruptcy].[AccountID]
AND [Debtors].[DebtorID] = [Bankruptcy].[DebtorID]
WHERE [master].[link] = @LinkID;

SELECT 'Legal' AS [SectionName],
	'Assets' AS [SubSectionName];

SELECT [master].[number] AS [Account ID],
	[Debtors].[name] AS [Debtor:format(Proper Case)],
	[Debtor_Assets].[Name] AS [Asset Name],
	CASE [Debtor_Assets].[AssetType]
		WHEN 1 THEN 'Automobile'
		WHEN 2 THEN 'Real Property'
		WHEN 3 THEN 'Bank Account'
		WHEN 4 THEN 'Securities'
		WHEN 5 THEN 'Personal Property'
		WHEN 6 THEN 'Business Equipment'
		WHEN 7 THEN 'Farm Equipment'
		ELSE 'Other'
	END AS [Asset Type],
	[Debtor_Assets].[CurrentValue] AS [Current Value:format(Currency)],
	[Debtor_Assets].[LienAmount] AS [Lien Amount:format(Currency)]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[Debtor_Assets]
ON [Debtors].[number] = [Debtor_Assets].[AccountID]
AND [Debtors].[DebtorID] = [Debtor_Assets].[DebtorID]
WHERE [master].[link] = @LinkID
ORDER BY [Debtor_Assets].[LienAmount] DESC,
	[Debtor_Assets].[CurrentValue] DESC,
	[Debtor_Assets].[Description];

RETURN 0;



GO
