SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_GetSoldPortfolioDescription]
	@AccountID INTEGER,
	@Description VARCHAR(250) OUTPUT,
	@Stage TINYINT = NULL OUTPUT
AS
SET NOCOUNT ON;
DECLARE @SoldPortfolio VARCHAR(7);

SELECT @SoldPortfolio = [SoldPortfolio]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

IF ISNUMERIC(@SoldPortfolio) = 1 BEGIN
	IF EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE [id] = OBJECT_ID(N'[dbo].[AIM_Portfolio]') AND OBJECTPROPERTY([id], N'IsUserTable') = 1) BEGIN
		IF EXISTS (SELECT * FROM [dbo].[AIM_Portfolio] WHERE [AIM_Portfolio].[PortfolioID] = CAST(@SoldPortfolio AS INTEGER)) BEGIN
			SELECT @Description = 'Code: ' + ISNULL([AIM_Portfolio].[code], '') + CHAR(13) + CHAR(10) + 'Description: ' + ISNULL(CAST(SUBSTRING([AIM_Portfolio].[Description], 1, 250) AS VARCHAR(250)), ''),
				@Stage = [AIM_Portfolio].[PortfolioTypeId]
			FROM [dbo].[AIM_Portfolio]
			WHERE [AIM_Portfolio].[PortfolioID] = CAST(@SoldPortfolio AS INTEGER);

			RETURN 0;
		END;
	END;
END;
SET @Description = 'Portfolio code: ' + @SoldPortfolio;
SET @Stage = 1;
RETURN 0;


GO
