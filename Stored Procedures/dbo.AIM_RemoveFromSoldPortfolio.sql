SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     procedure [dbo].[AIM_RemoveFromSoldPortfolio]
(
	@number int
)

AS

	declare @soldPortfolioId int
	declare @current0 money
	select
		@soldPortfolioId = SoldPortfolio
		,@current0 = current0
	from
		master
	where
		number = @number

	declare @portfolioTypeid int
	declare @soldName varchar(50)
	select
		@portfolioTypeid = portfoliotypeid,
		@soldName = Code
	from
		aim_portfolio
	where
		portfolioid = @soldPortfolioId

	update 
		master
	set 
		soldportfolio = null
	where
		number = @number

  INSERT INTO Notes (created,utccreated,number,user0,action,result,comment)
  VALUES (getdate(),getutcdate(),@number,'PM','+++++','+++++','This account has been removed from portfolio ' + isnull(@soldName,''))

	if(@portfolioTypeId = 1)
	begin
		update 
			master
		set 
			restrictedaccess = 0
			,soldportfolio = null
			,status = 'ACT'
			,qlevel = '015'
			,qdate = dbo.makeqdate(getdate())
			
		where
			number = @number
	
		declare @costperfacedollar float
		select
			@costperfacedollar = costperfacedollar
		from
			aim_portfolio
		where
			portfolioid = @soldPortfolioId
	
		if(@costPerfacedollar > 0)
		begin
				-- reverse the sale of this account
				insert into
					aim_ledger
				(
					ledgertypeid
					,comments
					,credit
					,dateentered
					,portfolioid
					,number
				)
				values
				(
					13
					,'The reverse of the sale of this account.'
					,@costperfacedollar * @current0 * -1
					,getdate()
					,@soldPortfolioId
					,@number
				)
		
				-- management fee
				declare @saleCommission float
				select
					@saleCommission = calculationamount
				from
					aim_ledgerdefinition
				where
					portfolioid = @soldPortfolioId
					and ledgertypeid = 9
			
				if(@saleCommission is not null and @saleCommission > 0)
				begin
					insert into
						aim_ledger
					(
						ledgertypeid
						,comments
						,debit
						,dateentered
						,portfolioid
						,number
					)
					values
					(
						9
						,'The reverse of the commission charge for this account.'
						,@costperfacedollar * @current0 * -1 * (@saleCommission)
						,getdate()
						,@soldPortfolioId
						,@number
					)
				end
		end
	end

GO
