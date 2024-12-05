SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[WorkForm_GetQueueProviders] @UserID INTEGER
AS
SET NOCOUNT ON;

SELECT [TypeName]
FROM [dbo].[WorkForm_QueueProviders]
WHERE [Enabled] = 1
ORDER BY [Order], [Name];

RETURN 0;


GO
