SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Future_GetByID*/
CREATE Procedure [dbo].[sp_Future_GetByID]
@Uid INT
AS

SELECT *
FROM future
WHERE uid = @Uid

GO
