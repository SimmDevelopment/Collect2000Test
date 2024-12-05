SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesQueue_DoExistByCustomer*/
CREATE Procedure [dbo].[sp_LtrSeriesQueue_DoExistByCustomer]
(
	@CustomerID int,
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeriesQueue_DoExistByCustomer
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	IF EXISTS
	(
		SELECT lsq.LtrSeriesQueueID
		FROM LtrSeriesQueue lsq
		INNER JOIN LtrSeriesFact lsf ON lsf.CustomerID = @CustomerID
		INNER JOIN LtrSeriesConfig lsc ON lsc.LtrSeriesConfigID = lsq.LtrSeriesConfigID
		WHERE lsf.LtrSeriesID = @LtrSeriesID 
		AND lsq.DateRequested = '1/1/1753 12:00:00'
	)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO
