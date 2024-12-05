SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE    procedure [dbo].[Custom_UpdateBatchCompleted]
(
	@batchId int
	,@rawSource image
	,@rawSourceFileName varchar(100)
	,@mappingXml text
	,@mappingOutput text
	,@mappingOutputWithDisposition text
	,@sourceXml text = null
)
as
begin

	update Custom_BatchHistory 
	set 
		rawsource = @rawSource
		,rawSourceFileName = @rawSourceFileName
		,mappingxml = @mappingxml
		,mappingoutput = @mappingoutput
		,mappingoutputwithdisposition = @mappingoutputwithdisposition
		,endeddatetime = getdate()
		,sourceXml = @sourcexml
	where
		batchhistoryid = @batchid


end



GO
