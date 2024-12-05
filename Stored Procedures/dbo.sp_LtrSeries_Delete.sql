SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_LtrSeries_Delete*/
CREATE Procedure [dbo].[sp_LtrSeries_Delete]
(
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeries_Delete
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

BEGIN TRANSACTION

	DELETE LtrSeriesConfig
	WHERE LtrSeriesConfig.LtrSeriesID IN
	   (SELECT LtrSeries.LtrSeriesID
	   FROM LtrSeries
	   WHERE LtrSeries.LtrSeriesID = @LtrSeriesID)
	
	if (@@error != 0) goto ErrHandler
	
	DELETE FROM LtrSeries 
	WHERE LtrSeries.LtrSeriesID = @LtrSeriesID

	if (@@error != 0) goto ErrHandler
	COMMIT TRANSACTION		
	Return(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_LtrSeries_Delete.')
	ROLLBACK TRANSACTION
	Return(1)
GO
