SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE View [dbo].[CbrReportCycleUpdatesSummary]
as
------> v00001
	select cbrchangetype,datapoint,count(*) as Changed from [CbrDataCycleUpdates] group by cbrchangetype,datapoint    
            
GO
