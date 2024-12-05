SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_DebtorAttorney_Delete*/
CREATE Procedure [dbo].[sp_DebtorAttorney_Delete]
@ID INT
AS

DELETE FROM DebtorAttorneys
WHERE ID = @ID

GO
