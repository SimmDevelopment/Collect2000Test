SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Letter_GetByCode*/
CREATE Procedure [dbo].[sp_Letter_GetByCode]
	@Code varchar(5)
AS

select * from letter where code  = @Code

GO
