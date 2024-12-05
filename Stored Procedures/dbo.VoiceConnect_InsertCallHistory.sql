SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 02/10/2006
-- Description:	This will insert the Voice Connect call history
-- =============================================
CREATE PROCEDURE [dbo].[VoiceConnect_InsertCallHistory] 
	@rowId varchar(100),
	@ImportDate datetime,
	@CallTime datetime,
	@Result varchar(50),
	@Seconds int,
	@Charge	money
AS
BEGIN
	SET NOCOUNT ON;
	
	if not exists (select guid from VoiceConnectCallHistory where guid=@rowid)
		Insert into VoiceConnectCallHistory([Guid],[ImportDate],[CallTime],[Result],[Seconds],[Charge])
		Values( @rowId,@ImportDate,@CallTime,@Result,@Seconds,@Charge)

END
GO
