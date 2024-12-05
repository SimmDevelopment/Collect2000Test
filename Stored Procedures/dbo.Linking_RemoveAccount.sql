SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_RemoveAccount]
	@AccountID INTEGER,
	@PreventLinking BIT = 0
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF @AccountID IS NULL BEGIN
	RAISERROR('Invalid account number.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AccountID) BEGIN
	RAISERROR('Account #%d does not exist.', 16, 1, @AccountID);
	RETURN 1;
END;

DECLARE @LinkID INTEGER;

SELECT @LinkID = [master].[link]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

IF @LinkID IS NULL OR @LinkID = 0 BEGIN
	-- The account is not linked, do nothing
	RETURN 0;
END;

-- Insert records for the account to the other accounts in the current link to prevent the account from automatically relinking to those accounts
INSERT INTO [dbo].[Linking_DoNotLink] ([Source], [Target])
SELECT @AccountID, [master].[number]
FROM [dbo].[master]
LEFT OUTER JOIN [dbo].[Linking_DoNotLink]
ON ([Linking_DoNotLink].[Source] = @AccountID
	AND [Linking_DoNotLink].[Target] = [master].[number])
OR ([Linking_DoNotLink].[Source] = [master].[number]
	AND [Linking_DoNotLink].[Target] = @AccountID)
WHERE [master].[link] = @LinkID
AND [master].[number] <> @AccountID
AND [Linking_DoNotLink].[Source] IS NULL;

-- Remove the link ID from the master record
UPDATE [dbo].[master]
SET [link] = CASE COALESCE(@PreventLinking, [master].[PreventLinking])
		WHEN 1 THEN 0
		ELSE NULL
	END,
	[PreventLinking] = CASE COALESCE(@PreventLinking, 0)
		WHEN 1 THEN 1
		ELSE [master].[PreventLinking]
	END
WHERE [master].[number] = @AccountID;

RETURN 0;
	

GO
