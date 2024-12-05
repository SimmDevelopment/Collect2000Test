SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*View dbo.cbr_EffectiveConfiguration*/
CREATE VIEW [dbo].[cbr_EffectiveConfiguration]
WITH SCHEMABINDING
AS
SELECT [customer].[ccustomerid] AS [customerID],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NULL THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [Inherited],
	ISNULL(ISNULL([CustomerConfiguration].[ID], [ClassConfiguration].[ID]), [DefaultConfiguration].[ID]) AS [InheritedSource],
 	ISNULL(ISNULL([CustomerConfiguration].[enabled], [ClassConfiguration].[enabled]), [DefaultConfiguration].[enabled]) AS [enabled],
 	ISNULL(ISNULL([CustomerConfiguration].[portfolioType], [ClassConfiguration].[portfolioType]), [DefaultConfiguration].[portfolioType]) AS [portfolioType],
	ISNULL(ISNULL([CustomerConfiguration].[accountType], [ClassConfiguration].[accountType]), [DefaultConfiguration].[accountType]) AS [accountType],
	ISNULL(ISNULL([CustomerConfiguration].[minBalance], [ClassConfiguration].[minBalance]), [DefaultConfiguration].[minBalance]) AS [minBalance],
	ISNULL(ISNULL([CustomerConfiguration].[waitDays], [ClassConfiguration].[waitDays]), [DefaultConfiguration].[waitDays]) AS [waitDays],
	ISNULL(ISNULL([CustomerConfiguration].[creditorClass], [ClassConfiguration].[creditorClass]), [DefaultConfiguration].[creditorClass]) AS [creditorClass],
	ISNULL(ISNULL([CustomerConfiguration].[originalCreditor], [ClassConfiguration].[originalCreditor]), [DefaultConfiguration].[originalCreditor]) AS [originalCreditor],
	ISNULL(ISNULL([CustomerConfiguration].[useAccountOriginalCreditor], [ClassConfiguration].[useAccountOriginalCreditor]), [DefaultConfiguration].[useAccountOriginalCreditor]) AS [useAccountOriginalCreditor],
	ISNULL(ISNULL([CustomerConfiguration].[useCustomerOriginalCreditor], [ClassConfiguration].[useCustomerOriginalCreditor]), [DefaultConfiguration].[useCustomerOriginalCreditor]) AS [useCustomerOriginalCreditor],
	ISNULL(ISNULL([CustomerConfiguration].[principalOnly], [ClassConfiguration].[principalOnly]), [DefaultConfiguration].[principalOnly]) AS [principalOnly],
	ISNULL(ISNULL([CustomerConfiguration].[includeCodebtors], [ClassConfiguration].[includeCodebtors]), [DefaultConfiguration].[includeCodebtors]) AS [includeCodebtors],
	ISNULL(ISNULL([CustomerConfiguration].[deleteReturns], [ClassConfiguration].[deleteReturns]), [DefaultConfiguration].[deleteReturns]) AS [deleteReturns]
FROM [dbo].[customer]
LEFT OUTER JOIN [dbo].[cbr_Configuration] AS [ClassConfiguration]
ON [ClassConfiguration].[Class] = SUBSTRING([customer].[cob], 1, CHARINDEX(' - ', [customer].[cob]) - 1)
AND [ClassConfiguration].[CustomerID] IS NULL
LEFT OUTER JOIN [dbo].[cbr_Configuration] AS [CustomerConfiguration]
ON [customer].[ccustomerid] = [CustomerConfiguration].[CustomerID]
AND [CustomerConfiguration].[Class] IS NULL
INNER JOIN [dbo].[cbr_Configuration] AS [DefaultConfiguration]
ON [DefaultConfiguration].[CustomerID] IS NULL
AND [DefaultConfiguration].[Class] IS NULL
GO
