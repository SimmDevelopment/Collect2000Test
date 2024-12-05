SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_SetInterestDeferral] @AccountID INTEGER, @DeferInterest BIT = 1
AS
SET NOCOUNT ON;

UPDATE [dbo].[master]
SET [IsInterestDeferred] = @DeferInterest
WHERE [number] = @AccountID;

RETURN 0;

GO
