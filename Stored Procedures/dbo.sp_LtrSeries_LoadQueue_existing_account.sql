SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[sp_LtrSeries_LoadQueue_existing_account]
(
	@LtrSeriesID int,
	@AccountID int,
	@UserID int = null,
	@loaddate datetime
)
AS
-- Name:		sp_LtrSeries_LoadQueue_existing_acocunt
-- Function:		This procedure will load letter series queue from letter series 
--			for an account using input parameters.

	--set default userid if one not passed
	if @UserID is null set @UserID = 0

	-- initialize local variables


	-- declare variables used in error checking.
	declare @error_var int, @rowcount_var int

	--load letter series config item into LtrSeriesQueue
	INSERT INTO LtrSeriesQueue
	(
	LtrSeriesConfigID,
	DateToRequest,
	AccountID,
	DebtorID,
	PrimaryDebtorID
	)
	select lsc.ltrseriesconfigid, dateadd(d, lsc.DaysToWait, @LoadDate), m.number, d.debtorid, priDebtor.debtorid from ltrseriesconfig lsc
	inner join LtrSeries ls on ls.ltrseriesid = lsc.LtrSeriesID
	inner join LtrSeriesFact lsf on lsf.LtrSeriesID = ls.ltrseriesid
 	inner join customer c on c.ccustomerid = lsf.customerid 
	inner join master m on m.customer = c.customer
	inner join debtors d ON d.number = m.number and 
		case 
			when (lsc.ToPrimaryDebtor = 1 and lsc.ToCoDebtors = 0) then 0
			else d.seq 
		end = d.seq
	inner join debtors priDebtor ON priDebtor.number = m.number and priDebtor.seq = 0
	inner join letter l on l.letterid = lsc.letterid
	inner join CustLtrAllow cla on m.customer = cla.CustCode and cla.LtrCode = l.code
	where m.number = @AccountID
	and m.received is not null
	and 
		case
			when lsf.minbalance = 0 then lsf.minbalance
			else isnull(m.Current0,0) 
		end >= lsf.minbalance
	and
		case
			when lsf.maxbalance = 0 then lsf.maxbalance
			else isnull(m.Current0,0) 
		end <= lsf.maxbalance
	and m.number not in (select isnull(pdc.number,0) from pdc where pdc.active = '1' and pdc.number = @accountid)
	and m.number not in (select isnull(debtorcreditcards.number,0) from debtorcreditcards where debtorcreditcards.isactive = '1' and debtorcreditcards.number = @accountid)
	and m.number not in (select isnull(promises.AcctID,0) from promises where promises.active = '1' and promises.acctid = @accountid)
	and lsc.letterid not in 
		(
			select isnull(lr.letterid,0) from letterrequest lr 
			where lr.accountid = m.number 
			and lr.deleted = 0
			and lr.suspend = 0
			and lr.addeditmode = 0
		)
	and	
		case 
			when (lsc.ToPrimaryDebtor = 0 and lsc.ToCoDebtors = 1) then d.seq
			else 1
		end <> 0
	order by lsc.DaysToWait asc

	-- Save the @@ERROR and @@ROWCOUNT values in local 
	-- variables before they are cleared.
	select @error_var = @@error, @rowcount_var = @@rowcount
	if (@error_var != 0) goto ErrHandler
	else if @rowcount_var <= 0 goto cuExit	
	Return(0)	

cuExit:
	Return(0)
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_LtrSeries_LoadQueue_Existing_Account.')
	Return(1)
GO