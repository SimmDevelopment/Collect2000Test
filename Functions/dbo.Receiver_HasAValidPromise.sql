SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    FUNCTION [dbo].[Receiver_HasAValidPromise]
	(
		@number int
		,@curDate datetime
	)
returns int
as
	begin
		
		if EXISTS 
			(
				SELECT * 
				FROM [Promises] WITH (NOLOCK) 
				WHERE [Promises].[AcctID] = @number 
				AND [Promises].[DueDate] >= @curDate
				AND ([Promises].[Suspended] = 0 or [Promises].[Suspended] is null)
				AND [Promises].[Active] = 1
			)

			return 1
		return 0

	end
GO
