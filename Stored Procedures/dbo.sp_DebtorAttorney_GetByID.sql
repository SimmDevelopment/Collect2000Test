SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_DebtorAttorney_GetByID*/
CREATE Procedure [dbo].[sp_DebtorAttorney_GetByID]
@ID INT
AS

SELECT *
FROM DebtorAttorneys
WHERE ID = @ID

GO
