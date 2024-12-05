SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_ProcessSoldPortfolio]
(
	@portfolioId int
)

AS
	
	declare @saleamount money
	declare @costperfacedollar float
	declare @currentFaceValue money
	declare @purchaserId int
	select	@costperfacedollar = max(costperfacedollar)
		,@saleAmount = max(costperfacedollar) * sum(current1)
		,@currentFaceValue = sum(current1)
		,@purchaserId = max(buyergroupid)
		
	from	aim_portfolio p WITH (NOLOCK)
		join master m WITH (NOLOCK) on m.soldportfolio = p.portfolioid 
	where	p.portfolioid = @portfolioid	

	update	aim_ledgerdefinition
	set	calculationamount = @costperfacedollar
	where	portfolioid = @portfolioid and ledgertypeid in (4,5)
	update	aim_portfolio
	set	amount = @saleamount
		,originalfacevalue = @currentFaceValue
	where	portfolioid = @portfolioId

	declare @purchasedPortfolios table (purchasedportfolioid int)
	insert into @purchasedPortfolios
	select	m.purchasedportfolio from master m  WITH(NOLOCK) join aim_portfolio p with (nolock) on m.purchasedportfolio = p.portfolioid and p.portfoliotypeid = 0
	where soldportfolio = @portfolioId and m.purchasedportfolio is not null and m.purchasedportfolio <> ''
	group by purchasedportfolio

	declare @purchasedportfolioid int
	declare purchases cursor for
		select * from @purchasedPortfolios
	open purchases
	fetch next from purchases into @purchasedPortfolioId
	
	while @@fetch_status = 0
	begin

		if(@costperfacedollar > 0 and @purchasedPortfolioId is not null and @purchasedPortfolioId <> '')
		begin
			
			declare @saleportion money		
			select	@saleportion = sum(current1) * @costperfacedollar
			from	master  WITH (NOLOCK)
			where	purchasedportfolio = @purchasedPortfolioId and soldportfolio = @portfolioId
	
			--get investor to apply the correct ledger entry
			declare @investorgroupid int
			select @investorgroupid = investorgroupid from aim_portfolio  WITH(NOLOCK) where portfolioid = @purchasedPortfolioId

			--delete from aim_ledger where ledgertypeid in (13,9) and comments like 'Sold Portfolio Id:'+cast(@portfolioId as varchar(10))
			
			-- sales of accounts
			insert into aim_ledger(ledgertypeid,credit,fromgroupid,dateentered,portfolioid,comments,togroupid,soldportfolioid)
			values(13,@saleportion,@purchaserId,getdate(),@purchasedPortfolioId,'Sold Portfolio Id:'+cast(@portfolioId as varchar(10)),@investorgroupid,@portfolioId)
	
			-- management fee
			declare @saleCommission float
			select	@saleCommission = calculationamount
			from	aim_ledgerdefinition  WITH(NOLOCK)
			where	portfolioid = @portfolioid and ledgertypeid = 9
		
			if(@saleCommission is not null and @saleCommission > 0)
			begin
				insert into aim_ledger(ledgertypeid,debit,dateentered,portfolioid,comments,soldportfolioid)
				values(9,@saleportion * (@saleCommission)
					,getdate(),@purchasedPortfolioId,'Sold Portfolio Id:'+cast(@portfolioId as varchar(10)),@portfolioId)
			end
		end

		fetch next from purchases into @purchasedPortfolioId
	end
	
	CLOSE purchases
	DEALLOCATE purchases

	INSERT INTO AIM_PortfolioSoldAccounts(Number,SoldFaceValue)
	SELECT master.Number,master.Current1 FROM Master master WITH (NOLOCK) WHERE soldportfolio = @portfolioId


GO
