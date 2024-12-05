SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroupLtrSeries_Update*/
CREATE Procedure [dbo].[sp_CustomCustGroupLtrSeries_Update]
(
	@CustomCustGroupLtrSeriesID int,
	@CustomCustGroupID int,
	@LtrSeriesID int,
	@MinBalance money,
	@MaxBalance money
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_Update
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	--Start a transaction
	BEGIN TRAN T1
	
	--UPDATE all of the customer letter series that are in this group
	UPDATE LtrSeriesFact
	SET
		MinBalance = @MinBalance,
		MaxBalance = @MaxBalance
	FROM Fact F
	JOIN Customer C ON C.customer = F.CustomerID
	JOIN LtrSeriesFact LSF ON C.CCustomerID = LSF.CustomerID AND F.CustomGroupID = @CustomCustGroupID
	WHERE LSF.LtrSeriesID = @LtrSeriesID
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	--Update the actual GroupLtrSeries
	UPDATE CustomCustGroupLtrSeries
	SET
	CustomCustGroupID = @CustomCustGroupID,
	LtrSeriesID = @LtrSeriesID,
	MinBalance = @MinBalance,
	MaxBalance = @MaxBalance
	WHERE CustomCustGroupLtrSeriesID = @CustomCustGroupLtrSeriesID
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	COMMIT TRAN T1
GO
