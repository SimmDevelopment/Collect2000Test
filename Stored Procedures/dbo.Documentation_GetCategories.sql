SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Documentation_GetCategories]
AS
SET NOCOUNT ON;

SELECT [Documentation_Attachments].[Category]
FROM [dbo].[Documentation_Attachments]
WHERE [Category] IS NOT NULL
AND [Category] != ''
GROUP BY [Documentation_Attachments].[Category]

RETURN 0;

GO
