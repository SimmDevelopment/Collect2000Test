SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE               procedure [dbo].[AIM_InsertRecourseEntry]
(
	@ledgerTypeId int	
	,@number int
)
AS

	declare @currentdate datetime
	set @currentdate = getdate()

	declare @purchasedPortfolioId int
	declare @purchasedContractDate datetime
	declare @acctPRNbalance money, @costPrice money
	declare @soldportfolioId int, @sellerGroupName varchar(30), @debitAmount money
	select	@purchasedPortfolioId = portfolioid
		,@purchasedContractDate = p.contractdate
		,@acctPRNbalance = m.current1
		,@soldportfolioId = soldportfolio
		,@sellerGroupName = g.name
		,@debitAmount = (costperfacedollar * @acctPRNbalance)
		,@costPrice = costperfacedollar
	from	aim_portfolio p
		join aim_group g on p.sellergroupid = g.groupid
		join master m with (nolock) on m.purchasedportfolio = p.portfolioid
	where	m.number = @number
 		
	exec AIM_UpdateLedgerEntry 0, @ledgerTypeId, null,  @debitAmount,null, @currentdate, null, @purchasedPortfolioId, @number
	exec AIM_AddAimNote 1014, @number, @debitAmount, @costPrice, @sellerGroupName

	--UPDATE master
	--SET closed = @currentdate, returned = @currentdate--,purchasedportfolio = null
	--WHERE number = @number

--	if(@soldPortfolioId is not null and @soldPortfolioId <> 0 )
-- 	begin	
--	
--		declare @soldContractDate datetime, @creditAmount money,@costperdollarcredit money
--		declare @buyerGroupName varchar(30)
--		select	@soldContractDate = p.contractdate
--			,@creditAmount = (costperfacedollar * @acctPRNbalance)
--			,@costperdollarcredit = costperfacedollar
--		from	aim_portfolio p
--			join aim_group g on p.buyergroupid = g.groupid
--		where	portfolioid = @soldportfolioid
--
--		exec AIM_UpdateLedgerEntry 0, @ledgerTypeId, null,  null,@creditAmount, @currentdate, null, @soldPortfolioId, @number
--		exec AIM_AddAimNote 1015, @number, @creditAmount, @costperdollarcredit, @buyerGroupName
-- 	end


GO
