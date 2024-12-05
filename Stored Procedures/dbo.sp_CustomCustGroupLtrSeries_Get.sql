SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_CustomCustGroupLtrSeries_Get*/
CREATE Procedure [dbo].[sp_CustomCustGroupLtrSeries_Get]
(	
	@KeyID int
)
AS
-- Name:		sp_CustomCustGroupLtrSeries_Get
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT *
	FROM CustomCustGroupLtrSeries
	WHERE CustomCustGroupID = @KeyID
GO
