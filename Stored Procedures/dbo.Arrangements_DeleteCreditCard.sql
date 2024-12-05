SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_DeleteCreditCard] @id INTEGER
AS
SET NOCOUNT ON;

UPDATE [dbo].[DebtorCreditCards]
SET [IsActive] = 0
WHERE [ID] = @id;

RETURN 0;

GO
