SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE         procedure [dbo].[Custom_InsertFormReference]
AS

DECLARE @formId int

	insert into custom_formreference (name)  values(null)
	select @formId = SCOPE_IDENTITY()

	SELECT @formId








GO
