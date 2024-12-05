SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[AIM_SelectLedgerEntry]
(
	@ledgerId int
)
AS



	select
		ledgertypeid 
		,Status
		,comments 
		,credit 
		,debit 
		,dateentered 
		,datecleared 
		,portfolioid 
		,number
	from
		aim_ledger
	where
		ledgerid = @ledgerId



GO
