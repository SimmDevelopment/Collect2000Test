SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroupLtrSeries_Delete*/
CREATE Procedure [dbo].[sp_CustomCustGroupLtrSeries_Delete]
(
	@CustomCustGroupLtrSeriesID INT
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_Delete
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	--delete record
	DELETE FROM CustomCustGroupLtrSeries
	WHERE CustomCustGroupLtrSeriesID = @CustomCustGroupLtrSeriesID
GO
