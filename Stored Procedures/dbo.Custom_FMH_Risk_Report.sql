SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMH_Risk_Report]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT DISTINCT TOP 100 PERCENT
	[Debtors].[name] AS [Name],
	[status].[code] + ' - ' + [status].[Description] AS [Status],
	[master].[account] AS [Customer Account Number],
	[Bankruptcy].[CaseNumber] AS [CaseNumber],
	[Bankruptcy].[Chapter] AS [Chapter],
	[Bankruptcy].[DateFiled] AS [DateFiled],
	[Bankruptcy].[CourtCity] AS [CourtCity],
	[Bankruptcy].[CourtState] AS [CourtState],
	[Bankruptcy].[Status] AS [Status],
	[DebtorAttorneys].[Name] AS [Debtor Attorney Name],
	[DebtorAttorneys].[Phone] AS [Debtor Attorney Phone],
	[deceased].[DOD] AS [Deceased Date]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN [Debtors] AS [Debtors] WITH (NOLOCK)
ON [master].[number] = [Debtors].[number]
INNER JOIN [status] AS [status] WITH (NOLOCK)
ON [master].[status] = [status].[code]
LEFT OUTER JOIN [dbo].[Bankruptcy] AS [Bankruptcy] WITH (NOLOCK)
ON [master].[number] = [Bankruptcy].[AccountID]
LEFT OUTER JOIN [dbo].[DebtorAttorneys] AS [DebtorAttorneys] WITH (NOLOCK)
ON [Debtors].[DebtorID] = [DebtorAttorneys].[DebtorID]
LEFT OUTER JOIN [deceased] AS [deceased] WITH (NOLOCK)
ON [Debtors].[DebtorID] = [deceased].[DebtorID]
INNER JOIN [Fact] AS [Fact] WITH (NOLOCK)
ON [master].[customer] = [Fact].[CustomerID]
INNER JOIN [CustomCustGroups] AS [CustomCustGroups] WITH (NOLOCK)
ON [Fact].[CustomGroupID] = [CustomCustGroups].[ID]
WHERE ([Fact].[CustomGroupID] IN (134)
AND ((SELECT TOP 1 [StatusHistory].[DateChanged] FROM [StatusHistory] WITH (NOLOCK) WHERE [StatusHistory].[AccountID] = [master].[number] ORDER BY [StatusHistory].[DateChanged] DESC) >= { fn CURDATE() } AND (SELECT TOP 1 [StatusHistory].[DateChanged] FROM [StatusHistory] WITH (NOLOCK) WHERE [StatusHistory].[AccountID] = [master].[number] ORDER BY [StatusHistory].[DateChanged] DESC) < DATEADD(DAY, 1, { fn CURDATE() }))
AND [master].[status] IN ('RSK'))



END
GO
