SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE     PROCEDURE [dbo].[Documentation_WriteDocument] @FileName VARCHAR(260), @Extension VARCHAR(15), @FileSize BIGINT, @Hash BINARY(20), @Location VARCHAR(260), @DocumentID UNIQUEIDENTIFIER OUTPUT
AS
SET NOCOUNT ON;

SET @DocumentID = NEWID();

INSERT INTO [dbo].[Documentation] ([UID], [FileName], [FileSize], [SHA1Hash], [Extension], [Location], [Image])
VALUES (@DocumentID, @FileName, @FileSize, @Hash, @Extension, @Location, 0x);

RETURN 0;




GO
