SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_DeletePdc] @id INTEGER
AS
SET NOCOUNT ON;

UPDATE [dbo].[pdc]
SET [Active] = 0
WHERE [UID] = @id;

RETURN 0;

GO
