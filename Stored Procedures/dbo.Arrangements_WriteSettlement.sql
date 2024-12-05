SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_WriteSettlement] @AccountID INTEGER, @SettlementAmount MONEY, @ExpirationDays INTEGER,  @SettlementTotalAmount MONEY
AS
SET NOCOUNT ON;

DECLARE @SettlementID INTEGER;

SELECT @SettlementID = [Settlement].[ID]
FROM [dbo].[master] WITH (ROWLOCK, UPDLOCK)
INNER JOIN [dbo].[Settlement] WITH (ROWLOCK, UPDLOCK)
ON [master].[number] = [Settlement].[AccountID]
AND [master].[SettlementID] = [Settlement].[ID]
WHERE [master].[number] = @AccountID;

IF @SettlementAmount IS NOT NULL 
BEGIN
	IF @SettlementID IS NOT NULL 
	BEGIN
		EXEC [dbo].[Arrangements_UpdateMasterSettlementId] @AccountID, @SettlementID
	END;

	DECLARE @CreatedBy VARCHAR(10);

	SELECT @CreatedBy = [CurrentUser].[LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]() AS [CurrentUser];

	INSERT INTO [dbo].[Settlement] ([AccountID], [SettlementAmount], [SettlementTotalAmount], [ExpirationDays], [CreatedBy], [Created], [Updated])
	VALUES (@AccountID, @SettlementAmount, @SettlementTotalAmount, COALESCE(@ExpirationDays, 0), @CreatedBy, GETDATE(), GETDATE());

	SET @SettlementID = SCOPE_IDENTITY();

	UPDATE [dbo].[master]
	SET [SettlementID] = @SettlementID
	WHERE [number] = @AccountID;

	SELECT [Settlement].[ID],
			[Settlement].[AccountID],
			[Settlement].[SettlementAmount],
			[Settlement].[ExpirationDays],
			[Settlement].[CreatedBy],
			[Settlement].[Created],
			[Settlement].[Updated],
			[Settlement].[SettlementTotalAmount]
	FROM [dbo].[Settlement]
	WHERE [ID] = @SettlementID;
END;
ELSE IF @SettlementID IS NOT NULL BEGIN
	EXEC [dbo].[Arrangements_UpdateMasterSettlementId] @AccountID, NULL
END;

RETURN 0;
GO
