SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesQueue_DeleteByCustomer*/
CREATE Procedure [dbo].[sp_LtrSeriesQueue_DeleteByCustomer]
(
	@CustomerID int,
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeriesQueue_DeleteByCustomer
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	DELETE lsq
	FROM LtrSeriesQueue lsq
	INNER JOIN LtrSeriesFact lsf ON lsf.CustomerID = @CustomerID
	INNER JOIN LtrSeriesConfig lsc ON lsc.LtrSeriesConfigID = lsq.LtrSeriesConfigID
	WHERE lsf.LtrSeriesID = @LtrSeriesID 
	AND lsq.DateRequested = '1/1/1753 12:00:00'
GO
