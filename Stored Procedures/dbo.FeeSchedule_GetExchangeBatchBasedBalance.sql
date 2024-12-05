SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
[dbo].[FeeSchedule_GetExchangeBatchBasedBalance] 100323
[dbo].[FeeSchedule_GetExchangeBatchBasedBalance] 100328
*/
CREATE PROCEDURE [dbo].[FeeSchedule_GetExchangeBatchBasedBalance]
    @Number INT,
	@BatchBalance money OUTPUT
AS 
BEGIN
	DECLARE @ExchangeBatchId int
	
	IF EXISTS(	SELECT [master].[number] FROM [dbo].[master] WITH (NOLOCK)
				WHERE [master].[number] = @Number AND ISNULL([master].[link],0) != 0 AND ISNULL([master].[ExchangeBatchId],0) != 0)
	BEGIN
		SELECT @ExchangeBatchId = [master].[ExchangeBatchId]
		FROM [dbo].[master] WITH (NOLOCK)
		WHERE [master].[number] = @Number
		
		SELECT @BatchBalance = SUM([master].[original])
		FROM [dbo].[master] WITH (NOLOCK)
		WHERE [master].[link] IN(SELECT [master].[link] FROM [dbo].[master] WITH (NOLOCK) WHERE [master].[number] = @Number)
		AND ISNULL([master].[ExchangeBatchId],0) != 0
		AND [master].[ExchangeBatchId] = @ExchangeBatchId
		GROUP BY [master].[link],[master].[ExchangeBatchId]
	END
	ELSE
	BEGIN
		SELECT @BatchBalance = [master].[original] 
		FROM [dbo].[master] WITH (NOLOCK)
		WHERE [master].[number] = @Number
	END
END
SET ANSI_NULLS ON
GO
