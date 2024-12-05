SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[AIM_SelectDBAccountDetails] 
(
	@number int
)

AS
	SELECT
		m.current0 as [Current Balance]
		,ISNULL(sg.name,'Not a Purchased Account' ) as [Seller Group]
		,ISNULL(ig.name,'Not a Purchased Account' ) as [Investor Group]
		,ISNULL(bg.name,'Never Sold') as [Buyer Group]
		,ISNULL(pp.code,'Not a Purchased Account') as [Portfolio]
		,CASE WHEN m.purchasedportfolio IS NULL OR RTRIM(LTRIM(m.purchasedportfolio)) = '' THEN 0 ELSE m.purchasedportfolio END as portfolioid
		,ISNULL(sp.code,'Never Sold') as [Sold Portfolio]
		,CASE WHEN m.soldportfolio IS NULL OR RTRIM(LTRIM(m.soldportfolio)) = '' THEN 0 ELSE m.soldportfolio END as soldportfolioid
		,ISNULL(cast(pp.ContractDate as varchar),'Not a Purchased Account') as [Purchased On]
		,ISNULL(cast(sp.ContractDate as varchar),'Never Sold') as [Sold On]
		,ISNULL(cast(pp.costperfacedollar as varchar),'Not a Purchased Account') as [Purchased Strike Price]
		,ISNULL(cast(sp.costperfacedollar as varchar),'Never Sold') as [Sold Strike Price]

	FROM
		master m with (nolock)
		left outer join aim_portfolio pp  with (nolock) on pp.portfolioid = m.purchasedportfolio
		left outer join aim_portfolio sp  with (nolock) on sp.portfolioid = m.soldportfolio
		left outer join aim_group sg  with (nolock) on  sg.groupid = pp.sellergroupid
		left outer join aim_group ig with (nolock)  on ig.groupid = pp.investorgroupid
		left outer join aim_group bg with (nolock)  on bg.groupid = sp.buyergroupid
	WHERE
		m.number = @number
	
	select
		l.ledgerid
		,lt.name as [Ledger Type]
		,l.Status
		,dateentered as [Date Entered]
		,datecleared as [Date Cleared]
		,Credit
		,Debit
		,Comments
	from
		aim_ledger l with (nolock)
		join aim_ledgertype lt on l.ledgertypeid = lt.ledgertypeid
	where
		number = @number


	select
		lm.*
	from aim_ledger l with (Nolock) join aim_ledgermedia lm with (NOLOCK) on l.ledgerid = lm.ledgerid
	where number = @number

GO
