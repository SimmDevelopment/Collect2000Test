SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[cbr_EffectiveSetup]
WITH SCHEMABINDING
AS
SELECT [c].[ccustomerid] AS [customerID],
	CASE
		WHEN [ccc].[cbr_config_id] IS NULL THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [IsDefault],
	COALESCE([cc].[id], [dcc].[id], [unconfig].[id]) AS [SourceId],
 	COALESCE([cc].[enabled], [dcc].[enabled], [unconfig].[enabled]) AS [enabled],
	COALESCE([cc].[BaseIdNumber], [dcc].[BaseIdNumber], [unconfig].[BaseIdNumber]) AS [BaseIdNumber],
	COALESCE([cc].[EquifaxID], [dcc].[EquifaxID], [unconfig].[EquifaxID]) AS [EquifaxID],
	COALESCE([cc].[ExperianID], [dcc].[ExperianID], [unconfig].[ExperianID]) AS [ExperianID],
	COALESCE([cc].[InnovisID], [dcc].[InnovisID], [unconfig].[InnovisID]) AS [InnovisID],
	COALESCE([cc].[TransUnionID], [dcc].[TransUnionID], [unconfig].[TransUnionID]) AS [TransUnionID],
	COALESCE([cc].[IndustryCode], [dcc].[IndustryCode], [unconfig].[IndustryCode]) AS [IndustryCode],
	COALESCE([cc].[lastEvaluated], [dcc].[lastEvaluated], [unconfig].[lastEvaluated]) AS [lastEvaluated],
	COALESCE([cc].[ReporterAddress], [dcc].[ReporterAddress], [unconfig].[ReporterAddress]) AS [ReporterAddress],
	COALESCE([cc].[ReporterName], [dcc].[ReporterName], [unconfig].[ReporterName]) AS [ReporterName],
	COALESCE([cc].[ReporterPhone], [dcc].[ReporterPhone], [unconfig].[ReporterPhone]) AS [ReporterPhone]
FROM [dbo].[customer] AS [c]
	INNER JOIN [dbo].[cbr_config] AS [unconfig]
		ON [unconfig].[id] = (SELECT MIN([x].[id]) FROM [dbo].[cbr_config] [x] WHERE [x].[enabled] = 1)
	LEFT OUTER JOIN [dbo].[cbr_config_customer] AS [ccc] 
		ON [ccc].[Id] = (SELECT MIN([y].[id]) FROM [dbo].[cbr_config_customer] AS [y] WHERE [y].[CustomerId] = [c].[CCustomerID] AND [y].[Enabled] = 1)
	LEFT OUTER JOIN [dbo].[cbr_config] AS [cc] 
		ON [ccc].[cbr_config_id] = [cc].[id] AND [cc].[enabled] = 1 
	LEFT OUTER JOIN [dbo].[cbr_config_customer] AS [dccc] 
		ON [dccc].[Id] = (SELECT MIN([z].[id]) FROM [dbo].[cbr_config_customer] AS [z] WHERE [z].[CustomerId] IS NULL AND [z].[Enabled] = 1)
	LEFT OUTER JOIN [dbo].[cbr_config] AS [dcc] 
		ON [dccc].[cbr_config_id] = [dcc].[id] AND [dcc].[enabled] = 1
GO
