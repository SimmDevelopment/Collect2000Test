SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[WorkFlow_EffectiveEventConfiguration]
WITH SCHEMABINDING
AS
SELECT [customer].[customer] AS [Customer],
	[WorkFlow_Events].[ID] AS [EventID],
	[WorkFlow_Events].[Name] AS [EventName],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NOT NULL
		THEN [CustomerConfiguration].[WorkFlowID]
		WHEN [ClassConfiguration].[ID] IS NOT NULL
		THEN [ClassConfiguration].[WorkFlowID]
		WHEN [DefaultConfiguration].[ID] IS NOT NULL
		THEN [DefaultConfiguration].[WorkFlowID]
		ELSE NULL
	END AS [WorkFlowID],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NOT NULL
		THEN [CustomerConfiguration].[InitialPriority]
		WHEN [ClassConfiguration].[ID] IS NOT NULL
		THEN [ClassConfiguration].[InitialPriority]
		WHEN [DefaultConfiguration].[ID] IS NOT NULL
		THEN [DefaultConfiguration].[InitialPriority]
		ELSE NULL
	END AS [InitialPriority],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NOT NULL
		THEN [CustomerConfiguration].[ActionType]
		WHEN [ClassConfiguration].[ID] IS NOT NULL
		THEN [ClassConfiguration].[ActionType]
		WHEN [DefaultConfiguration].[ID] IS NOT NULL
		THEN [DefaultConfiguration].[ActionType]
		ELSE NULL
	END AS [ActionType],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NOT NULL
		THEN [CustomerConfiguration].[Reentrance]
		WHEN [ClassConfiguration].[ID] IS NOT NULL
		THEN [ClassConfiguration].[Reentrance]
		WHEN [DefaultConfiguration].[ID] IS NOT NULL
		THEN [DefaultConfiguration].[Reentrance]
		ELSE 0
	END AS [Reentrance],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NOT NULL
		THEN [CustomerConfiguration].[WorkFlowDelay]
		WHEN [ClassConfiguration].[ID] IS NOT NULL
		THEN [ClassConfiguration].[WorkFlowDelay]
		WHEN [DefaultConfiguration].[ID] IS NOT NULL
		THEN [DefaultConfiguration].[WorkFlowDelay]
		ELSE 0
	END AS [WorkFlowDelay]
FROM [dbo].[customer]
INNER JOIN [dbo].[vCustomerCOB]
ON [customer].[customer] = [vCustomerCOB].[customer]
CROSS JOIN [dbo].[WorkFlow_Events]
LEFT OUTER JOIN [dbo].[WorkFlow_EventConfiguration] AS [ClassConfiguration]
ON [ClassConfiguration].[Class] = [vCustomerCOB].[COB]
AND [ClassConfiguration].[Customer] IS NULL
AND [ClassConfiguration].[EventID] = [WorkFlow_Events].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_EventConfiguration] AS [CustomerConfiguration]
ON [CustomerConfiguration].[Class] IS NULL
AND [CustomerConfiguration].[Customer] = [customer].[customer]
AND [CustomerConfiguration].[EventID] = [WorkFlow_Events].[ID]
LEFT OUTER JOIN [dbo].[WorkFlow_EventConfiguration] AS [DefaultConfiguration]
ON [DefaultConfiguration].[Class] IS NULL
AND [DefaultConfiguration].[Customer] IS NULL
AND [DefaultConfiguration].[EventID] = [WorkFlow_Events].[ID]
GO
