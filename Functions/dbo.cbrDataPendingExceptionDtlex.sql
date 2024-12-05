SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[cbrDataPendingExceptionDtlex](@Accountid int)
returns table as
return

	with cbrdfx as
		(select number, debtorID, debtordob, debtorssn, IsAuthorizedAccountUser , seq,
				debtorstreet1, debtorcity, debtorstate,
				debtorlastname, debtorfirstname, DebtorZipCode, 
			    DelinquencyDate, ReceivedDate, ContractDate, originalCreditor, 
			    useaccountoriginalcreditor, usecustomeroriginalcreditor, DefaultOriginalCreditor, 
			    CustomerOriginalCreditor,  ConsumerAccountNumber, HasChargeOffRecord, 
			    SecondaryAgencyIdenitifier, SecondaryAccountNumber, ChargeOffAmount, 
			    IsValidAccountType , DefaultCreditorClass, IsChargeOffData, PortfolioType ,
			    Originalbalance  from cbrdatafex(@Accountid) where @Accountid is not null
			    
			    union all
			    select number, debtorID, debtordob, debtorssn, IsAuthorizedAccountUser , seq,
				debtorstreet1, debtorcity, debtorstate,
				debtorlastname, debtorfirstname, DebtorZipCode, 
			    DelinquencyDate, ReceivedDate, ContractDate, originalCreditor, 
			    useaccountoriginalcreditor, usecustomeroriginalcreditor, DefaultOriginalCreditor, 
			    CustomerOriginalCreditor,  ConsumerAccountNumber, HasChargeOffRecord, 
			    SecondaryAgencyIdenitifier, SecondaryAccountNumber, ChargeOffAmount, 
			    IsValidAccountType , DefaultCreditorClass, IsChargeOffData, PortfolioType ,
			    Originalbalance  from cbrdatafex(@Accountid) where @Accountid is null
		),
	
		metrox as
		(
		select 
		f.number, x.*, isnull(x.debtorexceptions,0) + isnull(x.primarydebtorexception,0) as cbrexception
		from cbrdfx f
		cross apply
		[dbo].[cbrDataMetroExceptionex]
			( f.debtorID, '19000201', f.debtordob, f.debtorssn, f.IsAuthorizedAccountUser , f.seq,
				f.debtorstreet1, f.debtorcity, f.debtorstate, '19000101'
				) x
				
		where isnull(x.debtorexceptions,0) <> 0 or isnull(x.primarydebtorexception,0) <> 0),


		debtrx as
		(
		select 
		f.number, f.debtorid, x.*, isnull(x.debtorexceptions,0) + isnull(x.primarydebtorexception,0) as cbrexception
		from cbrdfx f
		cross apply
		[dbo].[cbrDataDebtorExceptionex]
			( f.debtorlastname, f.debtorfirstname, f.IsAuthorizedAccountUser, f.DebtorZipCode , f.Seq, 
			  f.debtordob, f.DebtorSSN 
			) x
		where isnull(x.debtorexceptions,0) <> 0 or isnull(x.primarydebtorexception,0) <> 0),


		acctx as 
		(
		select 
		f.number, f.debtorid, x.*
		from cbrdfx f
		cross apply
		[dbo].[cbrDataMasterExceptionex]
			( f.DelinquencyDate, f.ReceivedDate, f.ContractDate, f.originalCreditor, 
			  f.useaccountoriginalcreditor, f.usecustomeroriginalcreditor, f.DefaultOriginalCreditor, 
			  f.CustomerOriginalCreditor,  f.ConsumerAccountNumber, f.HasChargeOffRecord, 
			  f.SecondaryAgencyIdenitifier, f.SecondaryAccountNumber, f.ChargeOffAmount, 
			  f.IsValidAccountType , f.DefaultCreditorClass, f.IsChargeOffData, f.PortfolioType ,
			  f.Originalbalance) x
		 where isnull(x.cbrexception,0) <> 0),
		 
		 cbrx as
		(
		 select m.number, m.debtorid, m.cbrexception from metrox m
		 union 
		 select d.number, d.debtorid, d.cbrexception from debtrx d
		 union 
		 select a.number, a.debtorid, a.cbrexception from acctx a
		 )     select * from cbrx	;
		 
GO
