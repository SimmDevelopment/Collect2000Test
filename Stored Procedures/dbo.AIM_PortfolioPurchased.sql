SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           procedure [dbo].[AIM_PortfolioPurchased] 
	@portfolioId int
AS

BEGIN

declare @rowcount int, @currentrow int, @maxid int, @sqlbatchsize int
select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

while @@rowcount>0
begin
	set rowcount @sqlbatchsize
	UPDATE Master  with (rowlock) 
	SET PurchasedPortfolio = @portfolioId 
	from AIM_TempPurchaseAccounts t
	inner join master m on t.number = m.number
	where PurchasedPortfolio <> @portfolioId or PurchasedPortfolio is null
end
set rowcount 0

DECLARE @amount MONEY
DECLARE @faceValue MONEY
DECLARE @costperfacedollar FLOAT

SELECT	@costperfacedollar = costperfacedollar FROM aim_portfolio WHERE	portfolioid = @portfolioid
SELECT	@facevalue = sum(current1) FROM	master WITH (NOLOCK) WHERE purchasedportfolio = @portfolioid

IF(@facevalue > 0)
	SET @amount = @costperfacedollar * @facevalue

UPDATE	aim_portfolio
SET	originalfacevalue = @facevalue
	,amount = @amount
WHERE	portfolioid = @portfolioid

DELETE FROM aim_ledger WHERE ledgertypeid in (1,6) and portfolioid = @portfolioid
INSERT INTO aim_ledger(	ledgertypeid,comments,debit,dateentered,portfolioid)
VALUES(	1,'Initial purchase amount.',@amount,getdate(),@portfolioId)

DECLARE @initialPurchaseCommission FLOAT
SELECT	@initialPurchaseCommission = calculationamount FROM aim_ledgerdefinition WHERE portfolioid = @portfolioid and ledgertypeid = 6

IF( @initialPurchaseCommission > 0 )
BEGIN
	DECLARE @commissionableAmount MONEY
	SELECT	@commissionableAmount = sum(commissionableamount)
	FROM	aim_portfolioinvestor
	WHERE	portfolioid = @portfolioId
	IF(@commissionableAmount is null or @commissionableAmount = 0)
		SET @commissionableAmount = @amount
	INSERT INTO aim_ledger(ledgertypeid,comments,debit,dateentered,portfolioid)
	VALUES(6,'Our charge for managing the purchase.',
		@commissionableAmount * (@initialPurchaseCommission),getdate(),@portfolioId)
END		

UPDATE	aim_ledgerdefinition
SET	calculationamount = @costperfacedollar
WHERE	portfolioid = @portfolioid and ledgertypeid in (4,5)


END

GO
