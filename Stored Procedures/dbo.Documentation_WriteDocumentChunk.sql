SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Documentation_WriteDocumentChunk] @DocumentID UNIQUEIDENTIFIER, @Chunk IMAGE
AS
SET NOCOUNT ON;

DECLARE @TextPtr BINARY(16);

SELECT TOP 1 @TextPtr = TEXTPTR([Documentation].[Image])
FROM [dbo].[Documentation]
WHERE [Documentation].[UID] = @DocumentID;

IF @TextPtr IS NULL BEGIN
	RAISERROR('Document with that ID does not exist.', 16, 1);
	RETURN 1;
END;

UPDATETEXT [dbo].[Documentation].[Image] @TextPtr NULL NULL @Chunk;

RETURN 0;


GO
