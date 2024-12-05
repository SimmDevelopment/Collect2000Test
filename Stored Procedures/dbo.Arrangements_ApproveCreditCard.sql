SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_ApproveCreditCard] @id INTEGER, @approvedBy VARCHAR(20)
AS
SET NOCOUNT ON;

UPDATE [dbo].[DebtorCreditCards]
SET [ApprovedBy] = @approvedBy,
	[Approved] = { fn CURDATE() }
WHERE [ID] = @id;

RETURN 0;

GO
