SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






CREATE procedure [dbo].[Collect2000AddLog] 
@theUser char(10),
@ProgramName char(15), 
@LogCode char(4), 
@LogWhen DateTime, 
@logMessage char(50) 
as 
Insert into Collect2000Log (TheUser,ProgramName,LogCode,LogWhen,LogMessage) values (@TheUser,@programname,@LogCode,@LogWhen,@LogMessage)
GO
