SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Documentation_ReadDocumentChunk] @TextPtr BINARY(16), @Offset INTEGER, @Length INTEGER
AS
SET NOCOUNT ON;

READTEXT [dbo].[Documentation].[Image] @TextPtr @Offset @Length;

RETURN 0;

GO
