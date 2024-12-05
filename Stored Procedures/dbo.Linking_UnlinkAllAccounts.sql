SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Linking_UnlinkAllAccounts] @IAmSure BIT = 0, @ResetStartingLink BIT = 1, @DeleteLinkNotes BIT = 1
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF @IAmSure IS NULL OR @IAmSure = 0 BEGIN
	DECLARE @Message VARCHAR(150);
	SET @Message = 'Are you really, really sure you want to unlink all accounts?' + CHAR(13) + CHAR(10) + 'If so, pass 1 to the @IAmSure parameter.'
	RAISERROR(@Message, 16, 1);
	RETURN 1;
END;

UPDATE [dbo].[master] WITH (ROWLOCK, XLOCK)
SET [link] = NULL,
	[LinkDriver] = 0,
	[qlevel] = CASE [master].[qlevel]
			WHEN '875' THEN '100'
			ELSE [master].[qlevel]
		END,
	[ShouldQueue] = CASE [master].[qlevel]
			WHEN '875' THEN 1
			ELSE [master].[ShouldQueue]
		END;
RETURN 0;

IF @ResetStartingLink = 1 BEGIN
	UPDATE [dbo].[controlfile]
	SET [nextlink] = 1;
END;

IF @DeleteLinkNotes = 1 BEGIN
	DELETE FROM [dbo].[notes]
	WHERE [notes].[action] = 'LINK'
	AND [notes].[ctl] = 'LNK';
END;

GO
