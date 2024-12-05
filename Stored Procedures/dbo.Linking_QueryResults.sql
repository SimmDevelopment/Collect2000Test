SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Linking_QueryResults] @StartDate DATETIME = NULL, @EndDate DATETIME = NULL, @Linked BIT = NULL, @CurrentlyLinked BIT = NULL
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

DECLARE @Tests TABLE (
	[LinkID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY NONCLUSTERED
);

INSERT INTO @Tests ([LinkID])
SELECT [Linking_Results].[LinkID]
FROM [Linking_Results]
INNER JOIN [master] AS [SourceMaster]
ON [Linking_Results].[Number] = [SourceMaster].[number]
INNER JOIN [master] AS [TargetMaster]
ON [Linking_Results].[Target] = [TargetMaster].[number]
WHERE [Linking_Results].[Evaluated] BETWEEN ISNULL(@StartDate, '1753-01-01') AND ISNULL(@EndDate, '2999-01-01')
AND ([Linking_Results].[Linked] = @Linked
		OR @Linked IS NULL)
AND ((@CurrentlyLinked = 0
		AND ([SourceMaster].[link] <> [TargetMaster].[link]
			OR [SourceMaster].[link] = 0))
	OR (@CurrentlyLinked = 1
		AND [SourceMaster].[link] = [TargetMaster].[link]
		AND [SourceMaster].[link] <> 0)
	OR @CurrentlyLinked IS NULL)
AND [Linking_Results].[LinkID] IN (
	SELECT TOP 1 [LastScore].[LinkID]
	FROM [dbo].[Linking_Results] AS [LastScore]
	WHERE [LastScore].[Number] = [Linking_Results].[Number]
	AND [LastScore].[Target] = [Linking_Results].[Target]
	ORDER BY [LastScore].[Evaluated] DESC);

SELECT [Tests].[LinkID],
	[Linking_Results].[Number],
	[Linking_Results].[Target],
	[Linking_Results].[Score],
	[Linking_Results].[Threshold],
	[Linking_Results].[Evaluated],
	[Linking_Results].[Linked],
	[SourceMaster].[link] AS [SourceLink],
	[SourceMaster].[desk] AS [SourceDesk],
	[SourceMaster].[customer] AS [SourceCustomer],
	[SourceMaster].[account] AS [SourceAccount],
	[SourceDebtors].[SSN] AS [SourceSSN],
	[SourceDebtors].[Name] AS [SourceName],
	[SourceDebtors].[HomePhone] AS [SourcePhone],
	[SourceDebtors].[Street1] AS [SourceStreet],
	[SourceDebtors].[City] AS [SourceCity],
	[SourceDebtors].[ZipCode] AS [SourceZipCode],
	[SourceDebtors].[DOB] AS [SourceDOB],
	[SourceDebtors].[DLNum] AS [SourceDLNum],
	[SourceMaster].[ID1] AS [SourceID1],
	[SourceMaster].[ID2] AS [SourceID2],
	[TargetMaster].[link] AS [TargetLink],
	[TargetMaster].[desk] AS [TargetDesk],
	[TargetMaster].[customer] AS [TargetCustomer],
	[TargetMaster].[account] AS [TargetAccount],
	[TargetDebtors].[SSN] AS [TargetSSN],
	[TargetDebtors].[Name] AS [TargetName],
	[TargetDebtors].[HomePhone] AS [TargetPhone],
	[TargetDebtors].[Street1] AS [TargetStreet],
	[TargetDebtors].[City] AS [TargetCity],
	[TargetDebtors].[ZipCode] AS [TargetZipCode],
	[TargetDebtors].[DOB] AS [TargetDOB],
	[TargetDebtors].[DLNum] AS [TargetDLNum],
	[TargetMaster].[ID1] AS [TargetID1],
	[TargetMaster].[ID2] AS [TargetID2]
FROM [dbo].[Linking_Results]
INNER JOIN @Tests AS [Tests]
ON [Linking_Results].[LinkID] = [Tests].[LinkID]
INNER JOIN [master] AS [SourceMaster]
ON [Linking_Results].[Number] = [SourceMaster].[number]
INNER JOIN [Debtors] AS [SourceDebtors]
ON [SourceMaster].[number] = [SourceDebtors].[number]
INNER JOIN [master] AS [TargetMaster]
ON [Linking_Results].[Target] = [TargetMaster].[number]
INNER JOIN [Debtors] AS [TargetDebtors]
ON [TargetMaster].[number] = [TargetDebtors].[number]
WHERE [SourceDebtors].[Seq] = 0
AND [TargetDebtors].[Seq] = 0;

SELECT [Linking_ResultTests].[TestID],
	[Tests].[LinkID],
	[Linking_ResultTests].[Test],
	[Linking_ResultTests].[Score],
	[Linking_ResultTests].[SourceData],
	[Linking_ResultTests].[TargetData]
FROM [dbo].[Linking_ResultTests]
INNER JOIN @Tests AS [Tests]
ON [Linking_ResultTests].[LinkID] = [Tests].[LinkID];

RETURN 0;

GO
