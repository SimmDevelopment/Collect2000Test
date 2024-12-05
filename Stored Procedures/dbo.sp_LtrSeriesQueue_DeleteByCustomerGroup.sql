SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_LtrSeriesQueue_DeleteByCustomerGroup*/
CREATE Procedure [dbo].[sp_LtrSeriesQueue_DeleteByCustomerGroup]
(
	@CustomCustGroupID int,
	@LtrSeriesID int
)
AS
-- Name:		sp_LtrSeriesQueue_DeleteByCustomerGroup
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	DELETE lsq
	FROM LtrSeriesQueue lsq
	INNER JOIN LtrSeriesConfig lsc ON lsc.LtrSeriesConfigID = lsq.LtrSeriesConfigID
	INNER JOIN CustomCustGroupLtrSeries ccg ON ccg.LtrSeriesID =  lsc.LtrSeriesID
	WHERE ccg.CustomCustGroupID = @CustomCustGroupID
	AND ccg.LtrSeriesID =  @LtrSeriesID
	AND lsq.DateRequested = '1/1/1753 12:00:00'
GO
