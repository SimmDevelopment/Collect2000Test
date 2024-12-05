SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create      procedure [dbo].[AIM_ClearLedgerEntry]
(
	@ledgerId int
)

AS

	update 
		aim_ledger
	set 
		datecleared = getdate()
	where
		ledgerId = @ledgerId

GO
