SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Deceased_Select] @DebtorID INTEGER
AS
SET NOCOUNT ON;

SELECT ISNULL([Deceased].[ID], 0) AS [ID],
	[Debtors].[number] AS [AccountID],
	[Debtors].[DebtorID],
	COALESCE([Deceased].[SSN], [Debtors].[SSN]) AS [SSN],
	COALESCE([Deceased].[FirstName], [Debtors].[firstName], dbo.GetFirstName([Debtors].[Name])) AS [FirstName],
	COALESCE([Deceased].[LastName], [Debtors].[lastName], dbo.GetLastName([Debtors].[Name])) AS [LastName],
	COALESCE([Deceased].[State], [Debtors].[State]) AS [State],
	COALESCE([Deceased].[PostalCode], [Debtors].[ZipCode]) AS [PostalCode],
	COALESCE([Deceased].[DOB], [Debtors].[DOB]) AS [DOB],
	[Deceased].[DOD],
	[Deceased].[MatchCode],
	[Deceased].[TransmittedDate],
	[Deceased].[ClaimDeadline],
	[Deceased].[DateFiled],
	[Deceased].[CaseNumber],
	[Deceased].[Executor],
	[Deceased].[ExecutorPhone],
	[Deceased].[ExecutorFax],
	[Deceased].[ExecutorStreet1],
	[Deceased].[ExecutorStreet2],
	[Deceased].[ExecutorCity],
	[Deceased].[ExecutorState],
	[Deceased].[ExecutorZipcode],
	[Deceased].[CourtCity],
	[Deceased].[CourtDistrict],
	[Deceased].[CourtDivision],
	[Deceased].[CourtPhone],
	[Deceased].[CourtStreet1],
	[Deceased].[CourtStreet2],
	[Deceased].[CourtState],
	[Deceased].[CourtZipcode]
FROM [dbo].[Debtors]
LEFT OUTER JOIN [dbo].[Deceased]
ON [Debtors].[DebtorID] = [Deceased].[DebtorID]
WHERE [Debtors].[DebtorID] = @DebtorID;

RETURN 0;

GO
