SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/13/2021
-- Description: Retrieves payments entered by payment portal only.
-- Changes:
--				08/13/2021 updated code to account for some payemnts to not have a batchpmtcreatedby payweb and instead to look at the approved by field on the post date tables.
--		07/03/2023 Updated to customer group 382
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_WebPayments]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = @CustGroupID --Production
SET @CustGroupID = 113 --Test	

    -- Insert statements for procedure here
SELECT dbo.GetMonthName(systemmonth) AS [Month], systemyear AS [Year], 'SIMM' AS [Vendor Name], COUNT(*) AS [Number of web portal payments], SUM(totalpaid) AS [Dollar Volume] 
FROM payhistory p WITH (NOLOCK) LEFT OUTER JOIN pdc pdc WITH (NOLOCK) ON p.PostDateUID = pdc.UID AND p.number = pdc.number
LEFT OUTER JOIN DebtorCreditCards dcc WITH (NOLOCK) ON p.PostDateUID = dcc.ID AND p.number = dcc.Number
WHERE (dcc.ApprovedBy = 'payweb' OR pdc.ApprovedBy = 'payweb' OR p.BatchPmtCreatedBy = 'payweb')
AND p.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
GROUP BY systemmonth, systemyear
ORDER BY systemyear, systemmonth

END
GO
