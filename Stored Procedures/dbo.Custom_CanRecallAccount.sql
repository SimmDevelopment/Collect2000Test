SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[Custom_CanRecallAccount]
(
	@number int		
)
as
begin
	
	select	dbo.Receiver_HasAValidPromise(@number, getdate()) as haspromises
		,dbo.Receiver_HasPostDatedChecks(@number, getdate()) as haspdcs
		

end







GO
