SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE      procedure [dbo].[Custom_InsertBatchHistory]
	@batchTypeId int
	,@customerreferenceid int
as
begin

	insert into Custom_BatchHistory (StartedDatetime,BatchTypeId,customerreferenceid)values(getdate(),@batchTypeId,@customerreferenceid)

	select SCOPE_IDENTITY()
end






GO
