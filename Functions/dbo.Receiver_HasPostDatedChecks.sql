SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    FUNCTION [dbo].[Receiver_HasPostDatedChecks]
	(
		@number int
		,@curDate datetime
	)
returns int
as
	begin
		
		if EXISTS 
			(
				SELECT pdc.number
				FROM [pdc] 
				WHERE [pdc].[number] = @number 
				AND [pdc].[deposit] >= @curDate
				AND [pdc].[onhold] IS NULL 
				AND [pdc].[Active] = 1
				UNION
				SELECT dcc.number
				FROM [debtorcreditcards] dcc WITH (NOLOCK)
				WHERE dcc.number = @number
				and dcc.depositdate >= @curDate
				and dcc.onholddate is null
				and dcc.isactive = 1
			)

			return 1
		return 0

	end
GO
