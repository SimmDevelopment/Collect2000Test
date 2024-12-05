SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Bankruptcy_GetAll*/
CREATE Procedure [dbo].[sp_Bankruptcy_GetAll]
AS

SELECT *
FROM Bankruptcy
GO
