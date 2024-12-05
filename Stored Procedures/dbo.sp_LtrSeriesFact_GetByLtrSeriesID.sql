SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesFact_GetByLtrSeriesID*/
CREATE Procedure [dbo].[sp_LtrSeriesFact_GetByLtrSeriesID]
(
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeriesFact_GetByLtrSeriesID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT * FROM LtrSeriesFact
	WHERE LtrSeriesID = @LtrSeriesID
GO
