SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_UpdateMasterSettlementId] @AccountID INTEGER, @SettlementId INTEGER
AS
SET NOCOUNT ON;

UPDATE [dbo].[master]
	SET [SettlementID] = @SettlementId
	WHERE [number] = @AccountID;
	
IF (@SettlementId IS NULL)
BEGIN
	DELETE FROM [dbo].[Settlement] WHERE [AccountId] = @AccountID;
END

RETURN 0;
GO
