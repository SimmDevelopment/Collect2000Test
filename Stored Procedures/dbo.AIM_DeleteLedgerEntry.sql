SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_DeleteLedgerEntry    */




create     procedure [dbo].[AIM_DeleteLedgerEntry]
(
	@ledgerId int
)
AS


	delete
		aim_ledger
	where
		ledgerid = @ledgerId



GO
