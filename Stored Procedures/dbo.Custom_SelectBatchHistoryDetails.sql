SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








create     procedure [dbo].[Custom_SelectBatchHistoryDetails]
	@batchHistoryId int
as
begin

	select 
		*
	from
		custom_batchhistory
	where
		batchHistoryId = @batchHistoryId
end





GO
