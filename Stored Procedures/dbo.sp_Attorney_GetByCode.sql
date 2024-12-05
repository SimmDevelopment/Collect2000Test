SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Attorney_GetByCode*/
CREATE Procedure [dbo].[sp_Attorney_GetByCode]
@Code varchar(5)
AS

SELECT *
FROM attorney
WHERE Code = @Code

GO
