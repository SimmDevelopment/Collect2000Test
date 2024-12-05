SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_GetExcelTemplate]
@templateid int
AS

SELECT 
TemplateID,
Name,
Description,
FileName,
DateSaved,
Details
FROM Custom_ExcelTemplate
WHERE TemplateID = @templateid


GO
