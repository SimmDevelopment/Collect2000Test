SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









create     procedure [dbo].[Custom_DeleteFormReference]
	@formId int
AS
	delete from Custom_FormReference where Formid = @formId






GO
