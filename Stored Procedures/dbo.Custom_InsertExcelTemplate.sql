SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_InsertExcelTemplate]
@name varchar(250),
@description varchar(250),
@filename varchar(250),
@details image
AS

INSERT INTO Custom_ExcelTemplate
(Name,Description,FileName,Details,DateSaved)
VALUES
(@name,@description,@filename,@details,getdate())

SELECT @@identity


GO
