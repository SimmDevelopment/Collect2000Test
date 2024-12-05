SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_CustomCustGroupLtrSeries_Add*/
CREATE   Procedure [dbo].[sp_CustomCustGroupLtrSeries_Add]
(
	@CustomCustGroupLtrSeriesID int OUTPUT,
	@CustomCustGroupID int,
	@LtrSeriesID int,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_Add
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	--Start a transaction
	BEGIN TRAN T1

	--Update existing letter series in the group
	UPDATE LtrSeriesFact
	SET MinBalance = @MinBalance,
		MaxBalance = @MaxBalance
	FROM LtrSeriesFact
	INNER JOIN Customer
	ON LtrSeriesFact.CustomerID = Customer.CCustomerID
	INNER JOIN FACT
	ON Customer.Customer = FACT.CustomerID
	WHERE FACT.CustomGroupID = @CustomCustGroupID;

	--Add this letter series to all of the customers in the group
	INSERT INTO LtrSeriesFact
	(LtrSeriesID, CustomerID, MinBalance, MaxBalance)
	SELECT @LtrSeriesID, Customer.CCustomerID, @MinBalance, @MaxBalance
	FROM FACT JOIN Customer ON Customer.customer = FACT.CustomerID
	WHERE FACT.CustomGroupID = @CustomCustGroupID
	AND NOT EXISTS (
		SELECT *
		FROM LtrSeriesFact
		WHERE LtrSeriesFact.CustomerID = Customer.CCustomerID
		AND LtrSeriesFact.LtrSeriesID = @LtrSeriesID
	);

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	--Now add the letter series to the group itself
	INSERT INTO CustomCustGroupLtrSeries
	(
	CustomCustGroupID,
	LtrSeriesID,
	MinBalance,
	MaxBalance
	)
	VALUES
	(
	@CustomCustGroupID,
	@LtrSeriesID,
	@MinBalance,
	@MaxBalance
	)
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	SET @CustomCustGroupLtrSeriesID = SCOPE_IDENTITY()
	
	COMMIT TRAN T1



GO
