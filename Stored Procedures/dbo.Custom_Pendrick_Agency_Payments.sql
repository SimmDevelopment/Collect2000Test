SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 10/30/2023
-- Description:	Export Return File to Pendrick
--   exec custom_pendrick_agency_payments 23394, '20231031', '20231102'
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Pendrick_Agency_Payments]
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
  , @startDate DATETIME
  , @endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT
	'70' AS [Record_Type]
   , m.id1 AS [DBT_Number]
   , 'TEST01' AS [Client_Code]
   , m.account  AS [Original_Account_Number]
   , REPLACE(CONVERT(VARCHAR(10), P.datepaid, 101),'/','') AS [Date_Posted]
   --, CASE WHEN batchtype LIKE '%R' THEN -(p.totalpaid) ELSE p.totalpaid END AS [Payment_Amount]
   , REPLACE(CONVERT(VARCHAR(10), CASE WHEN batchtype LIKE '%R' THEN (p.totalpaid) ELSE p.totalpaid END), '.', '') AS [Payment_Amount]
   , CASE WHEN batchtype LIKE '%R' THEN '13' ELSE '11' END AS [Payment_Code]
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
	WHERE invoice IN (SELECT string FROM dbo.customstringtoset(@invoice, '|'))

	UNION ALL

	SELECT
	'70' AS [Record_Type]
   , m.id1 AS [DBT_Number]
   , 'TEST01' AS [Client_Code]
   , m.account  AS [Original_Account_Number]
   , REPLACE(CONVERT(VARCHAR(10), P.datepaid, 101),'/','') AS [Date_Posted] 
   --, CASE WHEN batchtype LIKE '%R' THEN -(p.totalpaid) ELSE p.totalpaid END AS [Payment_Amount]
   , REPLACE(CONVERT(VARCHAR(10), CASE WHEN batchtype LIKE '%R' THEN (p.totalpaid) ELSE p.totalpaid END), '.', '') AS [Payment_Amount]
--, '' AS [Payment Code]
   , CASE WHEN status IN ('SIF') THEN '15' WHEN status = 'PIF' THEN '16' WHEN status = 'NSF' THEN '13' ELSE '11' END AS [Payment_Code]
	FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
	WHERE m.customer = '0003099'
		  AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		  --AND status NOT IN ('PIF')

END
GO
