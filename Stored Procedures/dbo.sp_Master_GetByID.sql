SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_Master_GetByID*/
CREATE Procedure [dbo].[sp_Master_GetByID]
@Number INT
AS

SELECT *
FROM master
WHERE Number = @Number
GO
