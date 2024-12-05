SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







CREATE         procedure [dbo].[Custom_SelectFormReference]
	@formId int
AS
	select
		fr.*
		
	from		
		Custom_FormReference fr
		
	where
		fr.formId = @formId




GO
