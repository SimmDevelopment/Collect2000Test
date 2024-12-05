SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Documentation_GetDocumentByFileNumberAndFileName]
@number int,
@fileName varchar(260)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT d.[UID],
	d.[FileName],
	da.[AccountID],
	m.[Account],	
	da.[Category],
	da.[Index],
	da.[AttachedBy],
	da.[AttachedDate],
	ISNULL(d.[Location],'') as [Location]
	FROM [dbo].[Documentation] d WITH (NOLOCK)
	INNER JOIN [dbo].[Documentation_Attachments] da WITH (NOLOCK)
	ON da.[DocumentId] = d.[UID]
	INNER JOIN [dbo].[Master] m WITH (NOLOCK)
	ON m.[number] = da.[AccountID]
	WHERE m.[number] = @number AND d.[FileName] = @fileName
	ORDER BY da.[AccountId], da.[Index]

	RETURN 0;
END
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

GO
