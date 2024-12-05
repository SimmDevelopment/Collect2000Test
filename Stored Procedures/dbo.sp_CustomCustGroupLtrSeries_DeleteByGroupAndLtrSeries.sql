SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroupLtrSeries_DeleteByGroupAndLtrSeries*/
CREATE Procedure [dbo].[sp_CustomCustGroupLtrSeries_DeleteByGroupAndLtrSeries]
(
	@CustomCustGroupID int,
	@LtrSeriesID int
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_DeleteByGroupAndLtrSeries
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	--Start a transaction
	BEGIN TRAN T1
	
	--Delete this letter series from all Customers in the group
	DELETE LtrSeriesFact
	FROM Fact F
	JOIN Customer C ON C.customer = F.CustomerID
	JOIN LtrSeriesFact LSF ON C.CCustomerID = LSF.CustomerID AND F.CustomGroupID = @CustomCustGroupID
	WHERE LSF.LtrSeriesID = @LtrSeriesID
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	
	--Delete this letter series from the group itself
	DELETE FROM CustomCustGroupLtrSeries
	WHERE CustomCustGroupID = @CustomCustGroupID AND LtrSeriesID = @LtrSeriesID
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
	COMMIT TRAN T1
GO
