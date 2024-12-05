SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesConfig_Delete*/
CREATE Procedure [dbo].[sp_LtrSeriesConfig_Delete]
(
	@LtrSeriesConfigID INT
)
AS
-- Name:		sp_LtrSeriesConfig_Delete
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	DELETE FROM LtrSeriesConfig
	WHERE LtrSeriesConfigID = @LtrSeriesConfigID
GO
