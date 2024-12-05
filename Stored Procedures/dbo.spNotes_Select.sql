SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*spNotes_Select*/
CREATE         PROCEDURE [dbo].[spNotes_Select]
	@AccountID int,
	@Linked bit = 0
AS

 /*
**Name            :spNotes_Select
**Function        :Retrieves all notes for a single account
**Creation        :8/19/2004
**Used by         :GSSNotes.dll
**Change History  :
*/

SET NoCount On

DECLARE @Link INTEGER;

SELECT @Link = [master].[link]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

IF @Linked = 1 AND @Link > 0 BEGIN
	SELECT CASE [notes].[number]
			WHEN @AccountID THEN 0
			ELSE 1
		END AS [IsLinked], [notes].*
	from Notes with(nolock)
	INNER JOIN [dbo].[master] WITH (NOLOCK)
	ON [notes].[number] = [master].[number]
	WHERE [master].[link] = @Link
	AND NOT ([master].[number] <> @AccountID
		AND [notes].[action] = 'LINK')
	ORDER BY COALESCE(UtcCreated, Created) ASC, UID ASC;
END;
ELSE BEGIN
	SELECT 0 AS [IsLinked],
		*
	from Notes with(nolock)
	WHERE Number = @AccountID
	ORDER BY COALESCE(UtcCreated, Created) ASC, UID ASC;
END;

Return @@Error










GO
