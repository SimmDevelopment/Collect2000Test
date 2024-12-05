SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create  procedure [dbo].[Lib_PurgeAccount] 
@NUMBER   int
as

	delete from master where number = @number
	delete from debtors where number = @number
	delete from miscextra where number = @number
	delete from bankruptcy where accountid = @number
	delete from notes where number = @number
	delete from extradata where number = @number
	delete from payhistory where number = @number
	delete from addresshistory where accountid = @number
	delete from phonehistory where accountid = @number
	delete from cbr where number = @number
	delete from hotnotes where number = @number
	delete from earlystagedata where accountid = @number

	delete from future where number = @number
	delete from pdc where number = @number
	delete from letterrequest where accountid = @number
	delete from customernotes where number = @number
	delete from bignotes where number = @number

GO
