SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroupLtrSeries_GetByID*/
CREATE Procedure [dbo].[sp_CustomCustGroupLtrSeries_GetByID]
(
	@CustomCustGroupLtrSeriesID int
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_GetByID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT *
	FROM CustomCustGroupLtrSeries
	WHERE CustomCustGroupLtrSeriesID = @CustomCustGroupLtrSeriesID
GO
