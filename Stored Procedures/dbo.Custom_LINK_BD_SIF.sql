SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_SIF] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    
SELECT m.id1 AS [AccountID],  m.account AS [ClientAccountID], 'SAI' AS [VendorID], 'SIF' AS [SIFCode], m.current0 AS [SIFAmount], FORMAT(sh.DateChanged , 'MM/dd/yyyy')AS [SIFDate]
FROM master m WITH (NOLOCK) 
INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
WHERE sh.DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
--AND closed IS NOT null
AND status = 'SIF'

END

GO
