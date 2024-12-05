SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_HoldPromise] @id INTEGER, @hold BIT
AS
SET NOCOUNT ON;

UPDATE [dbo].[Promises]
SET [Suspended] = @hold
WHERE [ID] = @id;

RETURN 0;

GO
