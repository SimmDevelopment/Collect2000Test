SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesConfig_GetByID*/
CREATE Procedure [dbo].[sp_LtrSeriesConfig_GetByID]
(
	@LtrSeriesConfigID int
)
AS
-- Name:		sp_LtrSeriesConfig_GetByID
-- Creation:		01/20/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT * FROM LtrSeriesConfig
	WHERE LtrSeriesConfigID = @LtrSeriesConfigID
GO
