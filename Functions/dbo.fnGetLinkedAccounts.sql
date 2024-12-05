SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetLinkedAccounts] (@AccountID INTEGER, @LinkID INTEGER)
RETURNS @Accounts TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	[Linked] BIT NOT NULL
)
AS BEGIN
	IF @LinkID IS NULL BEGIN
		SELECT TOP 1 @LinkID = [master].[link]
		FROM [dbo].[master] WITH (NOLOCK)
		WHERE [master].[number] = @AccountID;
	END;

	IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN
		INSERT INTO @Accounts ([AccountID], [Linked])
		SELECT [master].[number], CASE [master].[link] WHEN @LinkID THEN 1 ELSE 0 END
		FROM [dbo].[master] WITH (NOLOCK)
		WHERE [master].[link] = @LinkID;
	END;
	ELSE BEGIN
		INSERT INTO @Accounts ([AccountID], [Linked])
		VALUES (@AccountID, 0);
	END;
	RETURN;
END
GO
