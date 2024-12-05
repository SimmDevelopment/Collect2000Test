SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE        procedure [dbo].[Receiver_InsertHistoryDetail]
	@historyId int
	,@rawData text
	,@file_number int
	,@resultId int
	,@comment text = NULL
AS

	declare @receiverNumber int
	select @receivernumber = receivernumber from receiver_reference where sendernumber = @file_number
-- 	if(@receivernumber is null)
-- 	begin
-- 		RAISERROR ('15001', 16, 1)
-- 		return
-- 	end

	insert into 
		receiver_historydetail(historyId,rawData,number,resultId,comment) 
		values(@historyId,@rawData,@receiverNumber,@resultId,@comment)
	select Scope_Identity()

GO
