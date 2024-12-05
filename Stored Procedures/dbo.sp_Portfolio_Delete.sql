SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Portfolio_Delete*/
---------------------------------------------------------------------------------
-- Stored procedure that will delete an existing row from the table 'Portfolio'
-- using the Primary Key. 
-- Gets: @iPortfolioId int
-- Returns: @iErrorCode int
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[sp_Portfolio_Delete]
	@iPortfolioId int,
	@iErrorCode int OUTPUT
AS
SET NOCOUNT ON
-- DELETE an existing row from the table.
DELETE FROM [dbo].[Portfolio]
WHERE
	[PortfolioId] = @iPortfolioId
-- Get the Error Code for the statement just executed.
SELECT @iErrorCode=@@ERROR
GO
