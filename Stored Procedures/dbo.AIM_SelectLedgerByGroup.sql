SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create                    procedure [dbo].[AIM_SelectLedgerByGroup] --2,'1/1/2003','1/1/2006'
	@GroupId int,
	@startdate datetime,
	@enddate datetime
AS
	select	--l.Ledgerid
		--,l.ledgertypeid
		cast(l.portfolioid as varchar(10)) +' - '+ p.code as [Portfolio]
		,lt.name as Type
		,l.Dateentered as [Date Entered]
		,l.datecleared as [Date Cleared]
		,l.Number
		,l.Credit
		,l.Debit
		,l.Comments		
		,m.Name
		,m.Account
	from	aim_portfolio p with (nolock)
		join aim_ledger l with (nolock) on p.portfolioid = l.portfolioid
		left outer join aim_ledgertype lt on l.ledgertypeid = lt.ledgertypeid
		left outer join master m with (nolock) on l.number = m.number
	where	(p.buyergroupid = @groupId or p.sellergroupid = @groupId or p.investorgroupid = @groupId)
		and l.datecleared is null
		and l.dateentered between @startdate and @enddate
	order by l.dateentered desc




GO
