SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Court_GetAll*/
CREATE Procedure [dbo].[sp_Court_GetAll]
AS

SELECT *
FROM Courts

GO
