SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesFact_GetByID*/
CREATE Procedure [dbo].[sp_LtrSeriesFact_GetByID]
(
	@LtrSeriesID int,
	@CustomerID int
)
AS
-- Name:		sp_LtrSeriesFact_GetByID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT * FROM LtrSeriesFact
	WHERE LtrSeriesID = @LtrSeriesID
	AND CustomerID = @CustomerID
GO
