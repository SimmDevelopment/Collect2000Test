SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[Linking_EffectiveConfiguration]
WITH SCHEMABINDING
AS
SELECT [customer].[customer],
	CASE
		WHEN [CustomerConfiguration].[ID] IS NULL THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [Inherited],
	COALESCE([CustomerConfiguration].[ID], [ClassConfiguration].[ID], [DefaultConfiguration].[ID]) AS [InheritedSource],
 	COALESCE([CustomerConfiguration].[LinkMode], [ClassConfiguration].[LinkMode], [DefaultConfiguration].[LinkMode]) AS [LinkMode],
 	COALESCE([CustomerConfiguration].[CustomGroupID], [ClassConfiguration].[CustomGroupID], [DefaultConfiguration].[CustomGroupID]) AS [CustomGroupID],
	COALESCE([CustomerConfiguration].[DeskLinkingMode], [ClassConfiguration].[DeskLinkingMode], [DefaultConfiguration].[DeskLinkingMode]) AS [DeskLinkingMode],
	COALESCE([CustomerConfiguration].[CrossBranch], [ClassConfiguration].[CrossBranch], [DefaultConfiguration].[CrossBranch]) AS [CrossBranch],
	COALESCE([CustomerConfiguration].[LinkThreshold], [ClassConfiguration].[LinkThreshold], [DefaultConfiguration].[LinkThreshold]) AS [LinkThreshold],
	COALESCE([CustomerConfiguration].[PossibleLinkThreshold], [ClassConfiguration].[PossibleLinkThreshold], [DefaultConfiguration].[PossibleLinkThreshold]) AS [PossibleLinkThreshold],
	COALESCE([CustomerConfiguration].[LastNameScore], [ClassConfiguration].[LastNameScore], [DefaultConfiguration].[LastNameScore]) AS [LastNameScore],
	COALESCE([CustomerConfiguration].[FullNameScore], [ClassConfiguration].[FullNameScore], [DefaultConfiguration].[FullNameScore]) AS [FullNameScore],
	COALESCE([CustomerConfiguration].[SSNScore], [ClassConfiguration].[SSNScore], [DefaultConfiguration].[SSNScore]) AS [SSNScore],
	COALESCE([CustomerConfiguration].[PhoneScore], [ClassConfiguration].[PhoneScore], [DefaultConfiguration].[PhoneScore]) AS [PhoneScore],
	COALESCE([CustomerConfiguration].[DLNumScore], [ClassConfiguration].[DLNumScore], [DefaultConfiguration].[DLNumScore]) AS [DLNumScore],
	COALESCE([CustomerConfiguration].[DOBScore], [ClassConfiguration].[DOBScore], [DefaultConfiguration].[DOBScore]) AS [DOBScore],
	COALESCE([CustomerConfiguration].[StreetScore], [ClassConfiguration].[StreetScore], [DefaultConfiguration].[StreetScore]) AS [StreetScore],
	COALESCE([CustomerConfiguration].[CityScore], [ClassConfiguration].[CityScore], [DefaultConfiguration].[CityScore]) AS [CityScore],
	COALESCE([CustomerConfiguration].[ZipCodeScore], [ClassConfiguration].[ZipCodeScore], [DefaultConfiguration].[ZipCodeScore]) AS [ZipCodeScore],
	COALESCE([CustomerConfiguration].[AccountScore], [ClassConfiguration].[AccountScore], [DefaultConfiguration].[AccountScore]) AS [AccountScore],
	COALESCE([CustomerConfiguration].[ID1Score], [ClassConfiguration].[ID1Score], [DefaultConfiguration].[ID1Score]) AS [ID1Score],
	COALESCE([CustomerConfiguration].[ID2Score], [ClassConfiguration].[ID2Score], [DefaultConfiguration].[ID2Score]) AS [ID2Score],
	COALESCE([CustomerConfiguration].[EvaluateDriver], [ClassConfiguration].[EvaluateDriver], [DefaultConfiguration].[EvaluateDriver]) AS [EvaluateDriver],
	COALESCE([CustomerConfiguration].[LinkDriverMode], [ClassConfiguration].[LinkDriverMode], [DefaultConfiguration].[LinkDriverMode]) AS [LinkDriverMode],
	COALESCE([CustomerConfiguration].[FavorCollectorDesk], [ClassConfiguration].[FavorCollectorDesk], [DefaultConfiguration].[FavorCollectorDesk]) AS [FavorCollectorDesk],
	COALESCE([CustomerConfiguration].[FavorPDCs], [ClassConfiguration].[FavorPDCs], [DefaultConfiguration].[FavorPDCs]) AS [FavorPDCs],
	COALESCE([CustomerConfiguration].[FavorPromises], [ClassConfiguration].[FavorPromises], [DefaultConfiguration].[FavorPromises]) AS [FavorPromises],
	COALESCE([CustomerConfiguration].[DriverQueueLevel], [ClassConfiguration].[DriverQueueLevel], [DefaultConfiguration].[DriverQueueLevel]) AS [DriverQueueLevel],
	COALESCE([CustomerConfiguration].[FollowerQueueLevel], [ClassConfiguration].[FollowerQueueLevel], [DefaultConfiguration].[FollowerQueueLevel]) AS [FollowerQueueLevel],
	COALESCE([CustomerConfiguration].[ShuffleAccounts], [ClassConfiguration].[ShuffleAccounts], [DefaultConfiguration].[ShuffleAccounts]) AS [ShuffleAccounts],
	COALESCE([CustomerConfiguration].[MoveInventoryToCollectorDesk], [ClassConfiguration].[MoveInventoryToCollectorDesk], [DefaultConfiguration].[MoveInventoryToCollectorDesk]) AS [MoveInventoryToCollectorDesk],
	COALESCE([CustomerConfiguration].[DeskConflictSupervisorQueueLevel], [ClassConfiguration].[DeskConflictSupervisorQueueLevel], [DefaultConfiguration].[DeskConflictSupervisorQueueLevel]) AS [DeskConflictSupervisorQueueLevel],
	COALESCE([CustomerConfiguration].[MovePromisesToNewDriver], [ClassConfiguration].[MovePromisesToNewDriver], [DefaultConfiguration].[MovePromisesToNewDriver]) AS [MovePromisesToNewDriver]
FROM [dbo].[customer]
INNER JOIN [dbo].[vCustomerCOB]
ON [customer].[customer] = [vCustomerCOB].[customer]
LEFT OUTER JOIN [dbo].[Linking_Configuration] AS [ClassConfiguration]
ON [ClassConfiguration].[Class] = [vCustomerCOB].[COB]
AND [ClassConfiguration].[Customer] IS NULL
LEFT OUTER JOIN [dbo].[Linking_Configuration] AS [CustomerConfiguration]
ON [customer].[customer] = [CustomerConfiguration].[Customer]
AND [CustomerConfiguration].[Class] IS NULL
INNER JOIN [dbo].[Linking_Configuration] AS [DefaultConfiguration]
ON [DefaultConfiguration].[Customer] IS NULL
AND [DefaultConfiguration].[Class] IS NULL
GO
