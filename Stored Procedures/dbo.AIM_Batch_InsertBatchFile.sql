SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE       procedure [dbo].[AIM_Batch_InsertBatchFile]
(
	@batchFileTypeId int
	,@batchId int
	,@agencyId int
	,@url varchar(2048)
	,@wasImport bit
	,@logMessageId int
	,@filename varchar(100) --= null
	--,@rawfile image --= ''
	--,@dataset text --= null
	--,@datasetdatadiff text --= null
	,@numrecords int --= 0
	,@numerrors int --= 0
)
as
begin

	insert into AIM_batchfilehistory 
	(	batchfiletypeid	,batchid,agencyid,fileurl
		,wasimport,logmessageid,filename,rawfile,dataset,datasetdatadiff
		,numrecords,numerrors)
	values
	(	@batchFileTypeId,@batchId,@agencyId,@url,@wasImport,@logMessageId
		,@filename,'','','',@numrecords,@numerrors
	)

	select SCOPE_IDENTITY()
end



GO
