SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[AIM_SelectPortfolio]
@portfolioId int
AS

	declare @portfolioTypeId int
	select	@portfolioTypeid = portfolioTypeid
	from	aim_portfolio with (nolock)
	where	portfolioid = @portfolioId

	-- table 0
	select
		p.[PortfolioId],
		 p.[Code] as [Portfolio Code],
	     p.[CultureCode] as [CultureCode],
		 p.[GeneralLedgerID],
		 p.[SellerLotNumber],
		 p.[Description],
		 p.[ContractDate],
		 p.[Amount],
		 p.[BuyerGroupId],
		 p.[SellerGroupId],
		 p.[InvestorGroupId],
		 p.[PortfolioTypeId],
		 p.[OriginalFaceValue],
		 p.[CostPerFaceDollar] 
		,p.contractdate + mi.minrecoursedays as firstrecoursedate
		,p.contractdate + mi.maxrecoursedays as lastrecoursedate
		,p.amount + isnull(c.commissions,0) as adjtotalprice
		,adjpurchaseprice = 
			case originalfacevalue when 0 then 0
			else (p.amount + isnull(c.commissions,0)) / originalfacevalue 
			end
	from
		aim_portfolio p
		left outer join(select 	min(recourseperioddays) as minrecoursedays, 
					max(recourseperioddays) as maxrecoursedays
					,portfolioid
				from 	aim_ledgerdefinition 
				where	portfolioid = @portfolioid
				group by portfolioid) mi on mi.portfolioid = @portfolioid
		left outer join(select	sum(debit) as commissions
					,portfolioid
				from	aim_ledger
				where	portfolioid = @portfolioid
					and ledgertypeid = 6
				group by portfolioid) c on c.portfolioid = @portfolioid
	where
		p.portfolioid = @portfolioId

	-- table 1
--	select top 0
--		m.number,m.desk,m.name,m.state,m.zipcode,m.mr,m.account
--		,m.userdate1,m.userdate2,m.userdate3,m.status
--		,m.customer,m.ssn,m.current1 as balance,m.qlevel
--		,m.clidlc,m.clidlp,m.soldportfolio,m.purchasedportfolio
--		,m.originalcreditor
--	from	master m

	-- table 2
--	select	l.Ledgerid
--		,l.ledgertypeid
--		,lt.name as Type
--		,l.Dateentered as [Date Entered]
--		,l.datecleared as [Date Cleared]
--		,l.Number
--		,l.Credit
--		,l.Debit
--		,l.Comments
--		,l.portfolioid
--		,m.id1
--		,m.name
--	from	aim_ledger l
--		join aim_ledgertype lt on l.ledgertypeid = lt.ledgertypeid
--		left outer join master m with (nolock) on l.number = m.number
--	where	portfolioid = @portfolioId
--	order by l.dateentered desc

--	select i.contactid 
--		,i.name as Investor
--		,assn.ownershippercentage as [Ownership]
--		,p.amount * assn.ownershippercentage / 100 as [Investment Value]
--		,dbo.AIM_CalculatePortfolioValue(@portfolioId) * assn.ownershippercentage / 100 as [Share Value]
--		,(dbo.AIM_CalculatePortfolioValue(@portfolioId) * assn.ownershippercentage / 100) as [ROI]
--		,(dbo.AIM_CalculatePortfolioValue(@portfolioId) * assn.ownershippercentage / 100) / case when (p.amount * assn.ownershippercentage / 100) = 0 then 1 else (p.amount * assn.ownershippercentage / 100) end as [ROI Percentage]
--		,datediff(day, p.contractdate,getdate()) as [Time (days)]
--	from	aim_portfolio p
--		join aim_groupcontactassn assn on p.investorgroupid = assn.groupid
--		join aim_contact i on assn.contactid = i.contactid
--	where	p.portfolioid = @portfolioId
--
--	select	assn.ownershippercentage 
--		,i.name as Investor
--	from	aim_portfolio p
--		join aim_groupcontactassn assn on p.investorgroupid = assn.groupid		
--		join aim_contact i on assn.contactid = i.contactid
--	where	p.portfolioid = @portfolioId

	select	ledgerdefinitionid
		,portfolioid
		,ld.ledgertypeid
		,lt.name as LedgerType
		,RecoursePeriodDays
		,Condition
		,ld.calculationtypeid
		,CalculationAmount
		,ct.name as CalculationType		
	from	aim_ledgerdefinition ld
		left outer join aim_ledgertype lt on ld.ledgertypeid = lt.ledgertypeid
		left outer join aim_calculationtype ct on ct.calculationtypeid = ld.calculationtypeid
	where	ld.portfolioid = @portfolioid


	--get count of accounts
--	declare @accounts table(number int,current1 money)
--	if(@portfolioTypeId = 0) -- purchased
--	begin
--		insert into @accounts
--		select number,current1 from master with (nolock) where purchasedportfolio = @portfolioid
--	end
--	else -- sold
--	begin
--		insert into @accounts
--		select number,current1 from master with (nolock) where soldportfolio = @portfolioid
--	end
--
--	select count(*) as "Count" from @accounts
--	
--	select sum(current1) as "Sum" from @accounts
--
--	select count(*) as "Count" from @accounts m join pdc p on m.number = p.number
--	where p.active = 1 
--	
--	select count(*) as "Count" from @accounts m join promises p on p.acctid = m.number
--	where p.active = 1
--
--
--
--select count(*) from master m with (nolock) join pdc p with (nolock) on p.number = m.number
--where p.active = 1 group by m.number
--select number from pdc where active = 1






GO
