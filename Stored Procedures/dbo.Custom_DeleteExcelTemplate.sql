SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_DeleteExcelTemplate]
@templateid int 
AS
 
DELETE
FROM Custom_ExcelTemplate
WHERE TemplateID = @templateid


GO
