SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE         procedure [dbo].[AIM_InserMediaOrder]
(
	@ledgerTypeId int
	,@totalCost money
	,@number int
)
AS
DECLARE @ledgerId int
	DECLARE @currentdate datetime
	SET @currentdate = getdate()

	DECLARE @ledgerName varchar(50)
	SELECT
		@ledgerName = name
	FROM
		aim_ledgertype
	WHERE
		ledgertypeid = @ledgerTypeId

	DECLARE @purchasedPortfolioId int
	DECLARE @purchasedContractDate datetime
	SELECT
		@purchasedPortfolioId = portfolioid
		,@purchasedContractDate = p.contractdate
	FROM
		aim_portfolio p WITH (NOLOCK)
		join master m  WITH (NOLOCK) on m.purchasedportfolio = p.portfolioid
	WHERE
		m.number = @number
	
	DECLARE @soldPortfolioId int
	DECLARE @soldContractDate datetime
	SELECT
		@soldPortfolioId = portfolioid
		,@soldContractDate = p.contractdate
	FROM
		aim_portfolio p WITH (NOLOCK)
		join master m WITH (NOLOCK) on m.soldportfolio = p.portfolioid
	WHERE
		m.number = @number

	
	IF (@ledgerTypeId = -1)
	BEGIN
		IF(@soldPortfolioID is not null)
		BEGIN
			SET @ledgerTypeId = 28
		END
		ELSE
		BEGIN
			SET @ledgerTypeId = 27
		END

	END
	--IF MEDIA
	IF(@ledgerTypeId =  28 )
		BEGIN
			--IF REQUEST FROM BUYER
				
			INSERT INTO aim_ledger (comments) VALUES (null)
			SELECT @ledgerId = @@identity
			SELECT @ledgerId AS [RETURNLEDGERID]
			UPDATE aim_ledger SET soldportfolioid = CASE WHEN @soldPortfolioID is null or @soldPortfolioID = '' THEN -1 ELSE @soldPortfolioID END,portfolioid = @purchasedPortfolioId WHERE ledgerid = @ledgerid
			UPDATE aim_ledger
			SET [status]='Pending',ledgertypeid = @ledgerTypeId,comments = null,credit = @totalCost,debit = 0,dateentered = @currentdate,datecleared = null,portfolioid = @purchasedPortfolioId,number = @number,TOGroupId = p.investorgroupid, FromGroupId = p.sellergroupid
			FROM AIM_Ledger l WITH (NOLOCK) JOIN AIM_Portfolio P WITH (NOLOCK)
			ON l.portfolioid = p.portfolioid AND l.ledgerid = @ledgerid
			

			EXEC AIM_AddAimNote 1013, @number, @ledgerName, @totalCost
		END			
	ELSE IF(@ledgerTypeId = 27)
		BEGIN
			INSERT INTO aim_ledger (comments) VALUES (null)
			SELECT @ledgerId = @@identity
			SELECT @ledgerId AS [RETURNLEDGERID]
			UPDATE aim_ledger SET soldportfolioid =  CASE WHEN @soldPortfolioID is null or @soldPortfolioID = '' THEN -1 ELSE @soldPortfolioID END,portfolioid = @purchasedPortfolioId WHERE ledgerid = @ledgerid
			UPDATE aim_ledger
			SET [status]='Pending',ledgertypeid = @ledgerTypeId,comments = null,credit = 0,debit = @totalCost,dateentered = @currentdate,datecleared = null,portfolioid = @purchasedPortfolioId,number = @number,TOGroupId = p.sellergroupid, FromGroupId = p.investorgroupid
			FROM AIM_Ledger l WITH (NOLOCK) JOIN AIM_Portfolio P WITH (NOLOCK)
			ON l.portfolioid = p.portfolioid AND l.ledgerid = @ledgerid
			

			EXEC AIM_AddAimNote 1013, @number, @ledgerName, @totalCost
		END
		
	--SKIP TRACE OR CREDIT BUREAU LEDGER ENTRY
	ELSE
	BEGIN
		DECLARE @debitAmount money
		SELECT 	@debitAmount = isnull(calculationamount,0) FROM aim_ledgerdefinition WHERE	ledgertypeid = @ledgertypeid
		EXEC AIM_UpdateLedgerEntry 0, @ledgerTypeId, null, null, @debitAmount, @currentdate, null, @purchasedPortfolioId, @number
		EXEC AIM_AddAimNote 1013, @number, @ledgerName, @debitAmount
	END

GO
