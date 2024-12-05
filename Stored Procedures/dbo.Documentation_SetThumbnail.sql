SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Documentation_SetThumbnail] @DocumentID UNIQUEIDENTIFIER, @Thumbnail IMAGE
AS
SET NOCOUNT ON;

UPDATE [dbo].[Documentation]
SET [Thumbnail] = @Thumbnail
WHERE [UID] = @DocumentID;

RETURN 0;

GO
