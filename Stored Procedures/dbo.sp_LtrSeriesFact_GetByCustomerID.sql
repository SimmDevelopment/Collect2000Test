SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LtrSeriesFact_GetByCustomerID*/
CREATE Procedure [dbo].[sp_LtrSeriesFact_GetByCustomerID]
(
	@CustomerID int
)
AS
-- Name:		sp_LtrSeriesFact_GetByCustomerID
-- Creation:		01/14/2004 jc
--			Used by Letter Console.
-- Change History:	

	SELECT * FROM LtrSeriesFact
	WHERE CustomerID = @CustomerID
GO
