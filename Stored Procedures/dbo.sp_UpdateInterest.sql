SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateInterest]
	@AcctID INTEGER,
	@NewInterest MONEY OUTPUT
AS
DECLARE @ReturnValue INTEGER;

EXEC @ReturnValue = [dbo].[spInterest_Update] @AccountID = @AcctID, @AllAccounts = 0, @NewInterest = @NewInterest OUTPUT;

RETURN @ReturnValue;

GO
