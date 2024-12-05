SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes: Add that SIF/PIF will remain on report until recalled by US Bank via 910 sent 14 days after SIF date.  Then exclude if returned date is on the account.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Daily_Inventory_Report]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Account #], m.current0 AS [Current Balance], c.CustomText1 AS [Agency Code], SUBSTRING(c.customtext1, 1, 3) + 'R' AS [Payment Stream],
m.received AS [Date Assigned], m.status AS [Agency Status Code], ISNULL(CONVERT(VARCHAR(10), m.lastpaid, 101), '') AS [Last Payment Date], m.lastpaidamt AS [Last Payment Amount],
m.ChargeOffDate AS [Charge-off Date], '' AS [Status]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE customgroupid = 113) AND (closed IS NULL
OR (m.status IN ('SIF', 'PIF') AND returned IS NULL))


END
GO
