SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE View [dbo].[CbrReportCycleUpdates]
as
------> v00001
	select * FROM [CbrDataCycleUpdates];    

GO
