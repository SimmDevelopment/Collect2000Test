SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*  AIM_dbo.AIM_Batch_InsertHeader     */

CREATE  procedure [dbo].[AIM_Batch_InsertHeader]
@batchDescription varchar(250) = null
as
begin

	insert into AIM_batch (StartedDateTime,CompletedDateTime,SystemMonth,SystemYear,[Description])
	SELECT 	TOP 1 getdate(),null,currentmonth,currentyear,@batchDescription FROM ControlFile
		
	select @@identity
end

GO
