SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  User Defined Function dbo.AIM_CalculateTotalRecovery    */

CREATE     FUNCTION [dbo].[AIM_CalculateTotalRecovery]
	(
		@batchid int
		,@agencyid int
	)
returns money
as
	begin
		declare @totalRecovery money
		select
			@totalRecovery = sum(pv.totalpaid)
		from
			AIM_batch b
			join AIM_batchfilehistory bfh on bfh.batchid = b.batchid
			join AIM_accounttransaction atr on atr.batchfilehistoryid = bfh.batchfilehistoryid
			join AIM_accountreference ar on atr.accountreferenceid = ar.accountreferenceid
			join AIM_PaymentView pv on pv.number = ar.referencenumber
		where
			pv.entered > b.completeddatetime
			and b.batchid = @batchid
			and atr.agencyid = @agencyid

		return @totalRecovery
			

	end






GO
