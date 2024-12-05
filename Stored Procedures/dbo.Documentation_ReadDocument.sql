SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Documentation_ReadDocument] @DocumentID UNIQUEIDENTIFIER, @TextPtr BINARY(16) OUTPUT, @Length INTEGER OUTPUT
AS
SET NOCOUNT ON;

SELECT @Length = DATALENGTH([Image]),
	@TextPtr = TEXTPTR([Image])
FROM [dbo].[Documentation]
WHERE [UID] = @DocumentID;

RETURN 0;

GO