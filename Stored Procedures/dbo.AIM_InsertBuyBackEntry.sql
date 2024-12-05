SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE             procedure [dbo].[AIM_InsertBuyBackEntry]
(
	@ledgerTypeId int	
	,@number int
)
AS

	declare @currentdate datetime
	set @currentdate = getdate()
	declare @purchasedportfolio int
	declare @soldPortfolioId int
	declare @soldContractDate datetime
	declare @acctPRNbalance money
	select	@soldPortfolioId = portfolioid
		,@soldContractDate = p.contractdate
		,@acctPRNbalance = psa.SoldFaceValue
	from	aim_portfolio p
		join master m with (nolock) on m.soldportfolio = p.portfolioid
		join AIM_PortfolioSoldAccounts psa with (nolock) on psa.Number = m.number
	where	m.number = @number
	
	select @purchasedportfolio = purchasedportfolio from master with (nolock) where number = @number

	if(@soldPortfolioId is not null and @soldPortfolioId <> 0 )
 	begin	
	
		declare @creditAmount money,@costperdollarcredit money
		declare @buyerGroupName varchar(30)
		select	@creditAmount = (costperfacedollar * @acctPRNbalance)
			,@costperdollarcredit = costperfacedollar
		from	aim_portfolio p
			join aim_group g on p.buyergroupid = g.groupid
		where	portfolioid = @soldportfolioid

		exec AIM_UpdateLedgerEntry 0, @ledgerTypeId, null,null, @creditAmount, @currentdate, null, @purchasedportfolio, @number
		exec AIM_AddAimNote 1015, @number, @creditAmount, @costperdollarcredit, @buyerGroupName
 	end

--	UPDATE master
--	SET  soldportfolio = null
--	WHERE number = @number







GO
