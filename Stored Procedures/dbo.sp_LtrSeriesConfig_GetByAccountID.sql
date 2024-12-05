SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_LtrSeriesConfig_GetByAccountID*/
CREATE     PROCEDURE [dbo].[sp_LtrSeriesConfig_GetByAccountID]
(
	@AccountID int
)
AS
-- Name:		sp_LtrSeriesConfig_GetByAccountID
-- Function:		This procedure will retrieve LtrSeriesConfig by account using input parameters.
-- Creation:		12/9/2003 jc
--			Used by Letter Console.
-- Change History:	

	--query letter requests
	select ls.LtrSeriesID, l.code, l.Description, lsf.minbalance, lsc.DaysToWait, m.number, m.Current0, m.received,
		case	
			when m.received is null THEN 'ERROR: Received Is Null'
			when (isnull(m.Current0,0) < lsf.minbalance) then 'locked: min bal'
			when m.number in (select pdc.number from pdc where pdc.number = m.number) then 'locked: pdc'
			when m.number in (select promises.AcctID from promises where promises.AcctID = m.number) then 'locked: promises'
			when m.number in (select payhistory.number from payhistory where payhistory.number = m.number and payhistory.batchtype in ('PU','PC','PA')) then 'locked: payhistory'
			when lsc.letterid in (select lr.letterid from letterrequest lr 
						where lr.accountid = m.number 
						and lr.deleted = 0
						and lr.suspend = 0
						and lr.addeditmode = 0) then 'complete'
			when getdate() < dateadd(d, lsc.DaysToWait, m.received) then 'pending'
			else 'active'
		end as [Status]
	from master m 
	inner join customer c on c.customer = m.customer
	inner join LtrSeriesFact lsf on lsf.customerid = c.ccustomerid
	inner join LtrSeries ls on ls.LtrSeriesID = lsf.LtrSeriesID
	inner join LtrSeriesConfig lsc on lsc.LtrSeriesID = ls.LtrSeriesID 
	inner join letter l on l.letterid = lsc.letterid
	where m.number = @AccountID
	order by lsc.DaysToWait asc

	if (@@error != 0) goto ErrHandler
	Return(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_LtrSeriesConfig_GetByAccountID.')
	Return(1)
GO
