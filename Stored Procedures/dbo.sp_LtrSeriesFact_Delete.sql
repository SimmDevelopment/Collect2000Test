SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesFact_Delete*/
CREATE Procedure [dbo].[sp_LtrSeriesFact_Delete]
(
	@LtrSeriesID int,
	@CustomerID int
)
AS
-- Name:		sp_LtrSeriesFact_Delete
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	DELETE FROM LtrSeriesFact
	WHERE LtrSeriesID = @LtrSeriesID
	AND CustomerID = @CustomerID
GO
