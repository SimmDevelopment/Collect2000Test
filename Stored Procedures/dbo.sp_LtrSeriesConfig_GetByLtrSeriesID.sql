SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesConfig_GetByLtrSeriesID*/
CREATE Procedure [dbo].[sp_LtrSeriesConfig_GetByLtrSeriesID]
(
	@LtrSeriesID INT
)
AS
-- Name:		sp_LtrSeriesConfig_GetByLtrSeriesID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT lsc.*, l.code, l.Description 
	FROM LtrSeriesConfig lsc
	INNER JOIN letter l ON l.letterid = lsc.letterid
	WHERE lsc.LtrSeriesID = @LtrSeriesID
	ORDER BY lsc.DaysToWait ASC
GO
