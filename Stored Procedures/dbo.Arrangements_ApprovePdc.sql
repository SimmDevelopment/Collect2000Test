SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_ApprovePdc] @id INTEGER, @approvedBy VARCHAR(20)
AS
SET NOCOUNT ON;

UPDATE [dbo].[pdc]
SET [ApprovedBy] = @approvedBy
WHERE [UID] = @id;

RETURN 0;

GO
