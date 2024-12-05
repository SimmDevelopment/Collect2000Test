SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeries_GetAll*/
CREATE Procedure [dbo].[sp_LtrSeries_GetAll]
AS
-- Name:		sp_LtrSeries_GetAll
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT *
	FROM LtrSeries
GO
