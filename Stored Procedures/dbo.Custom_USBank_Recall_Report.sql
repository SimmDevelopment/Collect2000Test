SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Recall_Report]
	-- Add the parameters for the stored procedure here
	@date datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- Insert statements for procedure here

    
    
	SELECT 'SIMM' AS Agency, c.customtext1 AS recoverycode, returned, COUNT(*) AS accounts, SUM(current1 + current2) AS balance
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 139) AND returned = dbo.date(@date)
GROUP BY c.customtext1, m.returned

END
GO
