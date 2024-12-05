SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_GetExcelTemplates]
AS

SELECT
TemplateID,
Name,
Description,
FileName,
DateSaved
FROM Custom_ExcelTemplate
ORDER BY Name


GO
