SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Documentation_FindDocument] @FileName VARCHAR(260), @FileSize BIGINT, @Hash BINARY(20), @DocumentID UNIQUEIDENTIFIER OUTPUT
AS
SET NOCOUNT ON;

SELECT @DocumentID = [UID]
FROM [dbo].[Documentation]
WHERE [FileName] = @FileName
AND [FileSize] = @FileSize
AND [SHA1Hash] = @Hash;

RETURN 0;

GO
