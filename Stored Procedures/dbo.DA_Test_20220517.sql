SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DA_Test_20220517]

--@startdate as date

as



	select top 3 * from master with (nolock) where number in (SELECT [AccountID]	
	FROM #WorkFlowAcct)
GO
