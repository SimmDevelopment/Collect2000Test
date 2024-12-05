SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[QueueEngine_PieQueue_GetAccounts] @desks TEXT, @MaxAccounts INTEGER, @RestrictedAccess BIT
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET ROWCOUNT @MaxAccounts;

DECLARE @DeskTable TABLE (
	[Desk] VARCHAR(10) NOT NULL PRIMARY KEY CLUSTERED
);

INSERT INTO @DeskTable ([Desk])
SELECT [value]
FROM [dbo].[fnExtractFixedStrings](@desks, 10);


/* PieQueue.Loading */

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT [master].[number],
	[desk].[code] AS [deskcode],
	[desk].[name] AS [deskname],
	[status].[code] AS [statuscode],
	[status].[description] AS [status],
	[customer].[customer] AS [customercode],
	[COB].[Code] AS [ClassOfBusiness],
	[COB].[Description] AS [ClassOfBusinessDescription],
	[customer].[name] AS [customer],
	CASE
		WHEN [master].[link] > 0
		THEN ISNULL([linked].[received], [master].[received])
		ELSE [master].[received]
	END AS [received],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[worked], [master].[worked])
		ELSE [master].[worked]
	END AS [worked],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[contacted], [master].[contacted])
		ELSE [master].[contacted]
	END AS [contacted],
	[master].[lastpaid] AS [lastpaid],
	[master].[UserDate1] AS [UserDate1],
	[master].[UserDate2] AS [UserDate2],
	[master].[UserDate3] AS [UserDate3],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[TotalWorked], [master].[TotalWorked], 0)
		ELSE ISNULL([master].[TotalWorked], 0)
	END AS [TotalWorked],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[TotalContacted], [master].[TotalContacted], 0)
		ELSE ISNULL([master].[TotalContacted], 0)
 	END AS [TotalContacted],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[current0], [master].[current0], 0)
		ELSE ISNULL([master].[current0], 0)
	END AS [balance],
	CASE
		WHEN [master].[link] > 0
		THEN COALESCE([linked].[original], [master].[original], 0)
		ELSE ISNULL([master].[original], 0)
	END AS [original],
	
	COALESCE(CASE WHEN LTRIM(ISNULL([debtors].[homephone],''))='' THEN NULL ELSE [debtors].[homephone] END, [debtorphone1].[phonenumber],'') AS  [homephone],

	COALESCE(CASE WHEN LTRIM(ISNULL([debtors].[workphone],''))='' THEN NULL ELSE [debtors].[workphone] END, [debtorphone2].[phonenumber],'') AS [workphone],
			
	[qlevel].[code] AS [queuecode],
	[qlevel].[QName] AS [queue],
	CASE ISDATE([master].[qdate])
		WHEN 1 THEN CAST([master].[qdate] AS DATETIME)
	END AS [queuedate],
	CASE
		WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18 THEN ISNULL([Debtors].[EarlyTimeZone], 5)
		ELSE ISNULL([Debtors].[LateTimeZone], 8)
	END AS [TimeZone],
	[Debtors].[Name],
	[Debtors].[City],
	[Debtors].[State],
	[StateRestrictions].[StateName],
	[master].[account],
	[master].[ID1],
	[master].[ID2],
	[Teams].[ID] AS [TeamID],
	[Teams].[Name] AS [TeamName],
	[Departments].[ID] AS [DepartmentID],
	[Departments].[Name] AS [DepartmentName],
	[BranchCodes].[Code] AS [BranchCode],
	[BranchCodes].[Name] AS [BranchName],
	[master].[Score]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN [dbo].[desk] WITH (NOLOCK)
ON [master].[desk] = [desk].[code]
INNER JOIN [dbo].[Teams] WITH (NOLOCK)
ON [Teams].[ID] = [desk].[TeamID]
INNER JOIN [dbo].[Departments] WITH (NOLOCK)
ON [Departments].[ID] = [Teams].[DepartmentID]
INNER JOIN [dbo].[BranchCodes] WITH (NOLOCK)
ON [Departments].[Branch] = [BranchCodes].[Code]
INNER JOIN [dbo].[status] WITH (NOLOCK)
ON [master].[status] = [status].[code]
INNER JOIN [dbo].[customer] WITH (NOLOCK)
ON [master].[customer] = [customer].[customer]
INNER JOIN [dbo].[vCustomerCOB] WITH(NOLOCK)
ON [customer].[customer] = [vCustomerCOB].[customer]
INNER JOIN [dbo].[COB] WITH (NOLOCK)
ON [COB].[Code] = COALESCE([master].[ClassOfBusiness], [vCustomerCOB].[COB])
INNER JOIN [dbo].[qlevel] WITH (NOLOCK)
ON [master].[qlevel] = [qlevel].[code]
INNER JOIN [dbo].[Debtors] WITH (NOLOCK)
ON [master].[number] = [Debtors].[number]
LEFT OUTER JOIN [dbo].[StateRestrictions] WITH (NOLOCK)
ON [Debtors].[State] = [StateRestrictions].[Abbreviation]
LEFT OUTER JOIN (
	SELECT [master].[link],
		SUM([master].[current0]) AS [current0],
		SUM([master].[original]) AS [original],
		MAX([master].[TotalWorked]) AS [TotalWorked],
		MAX([master].[TotalContacted]) AS [TotalContacted],
		CASE
			WHEN MAX(ISNULL([master].[worked], '9999-12-31')) = '9999-12-31' THEN NULL
			ELSE MAX(ISNULL([master].[worked], '9999-12-31'))
		END AS [worked],
		CASE
			WHEN MAX(ISNULL([master].[contacted], '9999-12-31')) = '9999-12-31' THEN NULL
			ELSE MAX(ISNULL([master].[contacted], '9999-12-31'))
		END AS [contacted],
		MAX([master].[received]) AS [received]
	FROM [dbo].[master] WITH (NOLOCK)
	WHERE [master].[qlevel] NOT IN ('998','999')
	GROUP BY [master].[link]
) AS [linked]
ON [master].[link] = [linked].[link]
AND [master].[link] > 0

OUTER APPLY (
	SELECT [Phones_Master].[number],
		[Phones_Master].[DebtorID], 
		[phones_master].[phonenumber], 
		ISNULL([Phones_Statuses].[PhoneStatusDescription],'unknown') AS [PhoneStatusDescription],  
		ROW_NUMBER() OVER (PARTITION BY [Phones_Master].[Number] ORDER BY [Phones_Statuses].[PhoneStatusDescription] ASC) AS [BestStatus]
	FROM  [dbo].[Phones_Master] 
	LEFT OUTER JOIN [dbo].[Phones_Statuses] ON [phones_master].[PhoneStatusID] = [Phones_Statuses].[PhoneStatusID]
	INNER JOIN [dbo].[Phones_Types] ON [phones_master].[PhoneTypeID] = [Phones_Types].[PhoneTypeID]
	WHERE [Phones_Types].[PhoneTypeDescription] = 'home'
	AND ISNULL([Phones_Statuses].[PhoneStatusDescription],'unknown') IN ('good','unknown')
	AND [Phones_Master].[number] = [Debtors].[number] AND [Phones_Master].[debtorid] = [Debtors].[DebtorID]
	 ) AS [DebtorPhone1]

OUTER APPLY (
	SELECT [Phones_Master].[number],
		[Phones_Master].[DebtorID], 
		[phones_master].[phonenumber], 
		ISNULL([Phones_Statuses].[PhoneStatusDescription],'unknown') AS [PhoneStatusDescription],
		ROW_NUMBER() OVER (PARTITION BY [Phones_Master].[Number] ORDER BY [Phones_Statuses].[PhoneStatusDescription] ASC) AS [BestStatus]
	FROM  [dbo].[Phones_Master] 
	LEFT OUTER  JOIN [dbo].[Phones_Statuses] ON [phones_master].[PhoneStatusID] = [Phones_Statuses].[PhoneStatusID]
	INNER JOIN [dbo].[Phones_Types] ON [phones_master].[PhoneTypeID] = [Phones_Types].[PhoneTypeID]
	WHERE [Phones_Types].[PhoneTypeDescription] = 'work'
	AND ISNULL([Phones_Statuses].[PhoneStatusDescription],'unknown') IN ('good','unknown')
	AND [Phones_Master].[number] = [Debtors].[number] AND [Phones_Master].[debtorid] = [Debtors].[DebtorID]
	 ) AS [DebtorPhone2]


WHERE [Debtors].[Seq] = 0
AND ([master].[link] = 0
	OR [master].[link] IS NULL
	OR [master].[LinkDriver] = 1)
AND [master].[qlevel] NOT IN ('000', '599', '998', '999')
AND [master].[qlevel] NOT LIKE '?%'
AND [master].[ShouldQueue] = 1
AND ([master].[RestrictedAccess] = 0
	OR @RestrictedAccess = 1)
AND ([master].[worked] < CAST({ fn CURDATE() } AS DATETIME)
	OR [master].[worked] IS NULL)
AND [master].[desk] IN (SELECT [Desk] FROM @DeskTable)
AND isnull([DebtorPhone1].[BestStatus],1)=1
OR
[Debtors].[Seq] = 0
AND ([master].[link] = 0
	OR [master].[link] IS NULL
	OR [master].[LinkDriver] = 1)
AND [master].[qlevel] NOT IN ('000', '599', '998', '999')
AND [master].[qlevel] NOT LIKE '?%'
AND [master].[ShouldQueue] = 1
AND ([master].[RestrictedAccess] = 0
	OR @RestrictedAccess = 1)
AND ([master].[worked] < CAST({ fn CURDATE() } AS DATETIME)
	OR [master].[worked] IS NULL)
AND [master].[desk] IN (SELECT [Desk] FROM @DeskTable)
AND isnull([DebtorPhone2].[BestStatus],1)=1
AND master.[number] in (
	select number from CallPreferences WITH (NOLOCK)
	WHERE [CallPreferences].[When] = 'Today' AND [CallPreferences].DoNotCall = 0 AND [CallPreferences].AllowedToday = 1
)

SET ROWCOUNT 0;

RETURN 0;

GO
