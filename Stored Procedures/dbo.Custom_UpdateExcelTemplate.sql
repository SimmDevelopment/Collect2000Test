SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_UpdateExcelTemplate]
@name varchar(250),
@description varchar(250),
@filename varchar(250),
@details image,
@templateid int
AS

UPDATE Custom_ExcelTemplate
SET
Name = @name,
Description = @description,
FileName = @filename,
Details = @details
WHERE 
TemplateID = @templateid


GO
