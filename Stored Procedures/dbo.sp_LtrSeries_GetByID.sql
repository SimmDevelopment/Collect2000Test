SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeries_GetByID*/
CREATE Procedure [dbo].[sp_LtrSeries_GetByID]
(
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeries_GetByID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT * FROM LtrSeries
	WHERE LtrSeriesID = @LtrSeriesID
GO
