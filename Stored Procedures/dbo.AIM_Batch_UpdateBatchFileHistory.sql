SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE       procedure [dbo].[AIM_Batch_UpdateBatchFileHistory]
(
	@batchFileHistoryId int
	,@rawfile image = null
	,@dataset text = null
	,@datasetdatadiff text = null
)
as
begin

	UPDATE  AIM_batchfilehistory 
	SET rawfile = @rawfile,dataset = @dataset,datasetdatadiff = @datasetdatadiff
	WHERE batchFileHistoryId = @batchFileHistoryId


end




GO
