SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_ApprovePromise] @id INTEGER, @approvedBy VARCHAR(20)
AS
SET NOCOUNT ON;

UPDATE [dbo].[Promises]
SET [ApprovedBy] = @approvedBy
WHERE [ID] = @id;

RETURN 0;

GO
