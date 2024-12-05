SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







Create procedure [dbo].[GetServerTime]
	@returnSts varchar (30) output
as 

set @returnSts = current_timestamp
Return @ReturnSts







GO
