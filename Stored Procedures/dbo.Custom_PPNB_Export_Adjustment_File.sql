SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/15/2020
-- Description:	Create balance file by comparing current database inforamtion to current inventory file placed.
-- Changes:
--			08/05/2021 BGM added that an account be open for an adjustment to be checked.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_PPNB_Export_Adjustment_File]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--	SELECT m.account, CASE WHEN CAST(ABS(cpiaa.CONFIRMED_BALANCE) AS MONEY) - (m.current1 + ABS(paid)) < 0 THEN 'DA' ELSE 'DAR' END AS paytype, ABS(CAST(ABS(cpiaa.CONFIRMED_BALANCE) AS MONEY) - (m.current1 + ABS(paid))) AS amount, 'Balance adjustment from file' AS comment
--FROM Custom_PPNB_Import_Active_Accounts cpiaa WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON cpiaa.CUSTOMER_ACCOUNT_ID = m.account
--Where customer IN ('0002337','0002338')
--AND ABS(cpiaa.CONFIRMED_BALANCE) <> m.current1 + ABS(paid)

SELECT account, CASE WHEN ROUND((ABS(CONFIRMED_BALANCE) - current0), 4) < 0 THEN 'DA' ELSE 'DAR' END AS paytype, 
ROUND(CAST (ABS( (current0 - ABS(CONFIRMED_BALANCE) ) )  AS MONEY), 4) AS amount,
'Balance adjustment from file' AS comment
FROM Custom_PayPal_NB_Inbound_File cpiaa WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON cpiaa.CUSTOMER_ACCOUNT_ID = m.account
WHERE m.customer IN ('0002337','0002338') AND current0 <> ABS(CONFIRMED_BALANCE) AND closed IS NULL
AND status <> 'pif' AND lastpaid IS NULL

END
GO
