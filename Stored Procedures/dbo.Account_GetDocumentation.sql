SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE      PROCEDURE [dbo].[Account_GetDocumentation] @AccountID INTEGER, @DocumentID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

SELECT [Documentation].[UID] AS [DocumentID], [Documentation_Attachments].[Category], [Documentation_Attachments].[Name], [Documentation_Attachments].[Index], [Documentation_Attachments].[AttachedBy], [Documentation_Attachments].[AttachedDate], [Documentation].[FileName], [Documentation].[FileSize], [Documentation].[Location] AS [Location]
FROM [dbo].[Documentation]
INNER JOIN [dbo].[Documentation_Attachments]
ON [Documentation_Attachments].[DocumentID] = [Documentation].[UID]
WHERE [Documentation_Attachments].[AccountID] = @AccountID
AND ([Documentation].[UID] = @DocumentID
	OR @DocumentID IS NULL)
ORDER BY [Documentation_Attachments].[Category], [Documentation_Attachments].[Name], [Documentation_Attachments].[Index];

RETURN 0;






GO
