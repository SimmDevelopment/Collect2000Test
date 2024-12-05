SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      FUNCTION [dbo].[AIM_GetLastFileDate]
	(
		@batchFileTypeId int
		,@agencyId int
	)
returns datetime
as
	begin
		declare @lastFileDate datetime
		select
			top 1
			@lastFileDate = completeddatetime
		from
			AIM_BatchFileHistory bfh
			join aim_batch b on b.batchid = bfh.batchid
		where
			batchfiletypeid = @batchFileTypeId
			and agencyid = @agencyId
		order by
			completeddatetime desc

		return @lastFileDate
			
	end




GO
