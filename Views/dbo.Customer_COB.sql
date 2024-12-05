SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Customer_COB]
AS
SELECT [vCustomerCOB].[COB] AS [CobCode],
	[COB].[Description] AS [CobDesc],
	[vCustomerCOB].[customer] AS [customer],
	[customer].[name] AS [name],
	[customer].[status] AS [status],
	[customer].[mtdpdccollections] AS [mtdpdccollections],
	[customer].[cob] AS [cob],
	[customer].[company] AS [company],
	[customer].[CCustomerID] AS [CCustomerID],
	[customer].[CustomerGroup] AS [CustomerGroup]
FROM [dbo].[vCustomerCOB] WITH (NOLOCK)
INNER JOIN [dbo].[customer] WITH (NOLOCK)
ON [vCustomerCOB].[customer] = [customer].[customer]
INNER JOIN [dbo].[COB] WITH (NOLOCK)
ON [vCustomerCOB].[COB] = [COB].[code]

GO
