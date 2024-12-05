SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 07/01/2021
-- Description:	Close File for Suntrust
-- Changes:
--			07/29/2021 BGM Updated SIF SF code to be sent after an echoback is received for the final payment on the account.
--			10/18/2021 BGM Added customer 2510 to be picked up in SIF/PIF closures
--			10/25/2021 BGM For SIF/PIF closures, updated the code to look only for the date of the echo back from Sutrust for the final SIF/PIF payments within the ntoes entered by the import maintenance..
--			03/25/2022 BGM Updated SIF and PIF conditions to look at Notes only during the start and end date in order to eliminate placeing older sif/pif accounts in the file.
--			04/26/2022 BGM Added LCP with RSK and LIT, RFP with AEX Closed Status.
--			04/27/2022 BGM Updated code to set an account as returned when it is placed in the report.
--			04/27/2022 BGM Removed the Customer Parameter due to it not being needed any longer.
--			07/19/2022 DMA Added Location Code to temp table to correct SqlException error per Rebecca Clute 20220719 1330 email.
--			07/25/2022 DMA Added Customer Number column at end of recordset per Rebecca Clute 20220725 1134 email.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_C360_RMS_Closed] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME

	-- exec Custom_SunTrust_CACS_C360_RMS_Closed 2259

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS ( SELECT  *
	FROM    tempdb.sys.tables
	WHERE   name LIKE '#CACS_Closed%' ) 
		BEGIN
			DROP TABLE #CACS_Closed
		END



	CREATE TABLE #CACS_Closed
	([Number] INT,
	[STB Acct #] VARCHAR(30),
	[NAME] VARCHAR(30),
	[STB Close Code] VARCHAR(5),
	[DT-ASSIGN] VARCHAR(10),
	[ PN-ASSIGN] MONEY,
	[CAN DATE] VARCHAR(10),
	[CAN AMT] MONEY,
	[Notes] VARCHAR(14)
	,[LOCATION CODE] VARCHAR(16),
	[CUSTOMER NUMBER] VARCHAR(3000)
	) ON [PRIMARY]

INSERT INTO #CACS_Closed 
([Number],
[STB Acct #],
 NAME,
 [STB Close Code],
 [DT-ASSIGN],
 [ PN-ASSIGN],
 [CAN DATE],
 [CAN AMT],
 Notes,
 [Location Code],
 [CUSTOMER NUMBER] 

 )

    -- Insert statements for procedure here
SELECT m.number, m.account AS [STB Acct #], m.Name as [NAME], 
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BK' 
			WHEN m.STATUS IN  ('CAD', 'CND') THEN 'CD'
			WHEN m.STATUS IN ('WDS', 'VDS', 'DPV') THEN 'DS'
			WHEN m.STATUS IN ('FRD') THEN 'FR'
			WHEN m.STATUS IN ('OOS') THEN 'OS'
			WHEN m.STATUS IN ('RSK', 'LIT', 'LCP','CMP') THEN 'LT'
			WHEN m.STATUS IN ('AEX', 'RFP') THEN 'AX'
			WHEN m.STATUS IN ('DIP') THEN 'IC'
			WHEN m.STATUS IN ('NYC') THEN 'NY'
			WHEN m.STATUS IN ('RCL', 'CCR') THEN 'RC'
			WHEN m.STATUS IN ('DUP') THEN 'DU'
			WHEN m.STATUS IN ('DSP') THEN 'DP'
			WHEN m.STATUS IN ('DEC') THEN 'DC'
			WHEN m.STATUS IN ('VAL') THEN 'DV'
			END AS [STB Close Code] ,
	CONVERT(VARCHAR(10), m.received, 101) as [DT-ASSIGN],
	m.original1 as [ PN-ASSIGN],
	CONVERT(VARCHAR(10), m.closed, 101) as [CAN DATE],
	m.current1 as [CAN AMT], 		
	'DOD ' + CONVERT(VARCHAR(10), de.dod, 101) AS [Notes], m.id2 AS [Location Code],
	customer AS [customer number]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
	LEFT OUTER JOIN dbo.Deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
WHERE CAST(m.closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND ((customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512')) or (customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405'))) 
AND m.status NOT IN ('sif', 'pif')

UNION ALL

	SELECT m.number, m.account AS [STB Acct #], m.Name as [NAME], CASE m.STATUS WHEN 'SIF' THEN 'SF' WHEN 'PIF' THEN 'PF' END AS [STB Close Code], 
	CONVERT(VARCHAR(10), m.received, 101) as [DT-ASSIGN],
	m.original1 as [ PN-ASSIGN],
	CONVERT(VARCHAR(10), m.closed, 101) as [CAN DATE],
	m.current1 as [CAN AMT], 
	'DOD ' + CONVERT(VARCHAR(10), de.dod, 101) AS [Notes],  m.id2 AS [Location Code],
	customer AS [customer number]

FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
	LEFT OUTER JOIN dbo.Deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
WHERE 
((customer IN ('0002258','0002259','0002509', '0002510', '0002513','0002514','0002512')) or (customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND m.status = 'pif'
AND ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ((ma.customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512')) or (ma.customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405'))) AND batchtype LIKE 'p%'
AND ma.number = m.number
GROUP BY ma.number), 0) = ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ((ma.customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512')) or (ma.customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405'))) AND batchtype LIKE 'p%'
AND p.invoice IS NOT NULL
AND ma.number = m.number
GROUP BY ma.number
), 0)
AND m.number IN (SELECT n.number FROM notes n WITH (NOLOCK) WHERE n.number = m.number AND CAST(created AS DATE) >= CAST(closed AS DATE) AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND result = 'PF')

UNION ALL

	SELECT m.number, m.account AS [STB Acct #], m.Name as [NAME], CASE m.STATUS WHEN 'SIF' THEN 'SF' WHEN 'PIF' THEN 'PF' END AS [STB Close Code], 
	CONVERT(VARCHAR(10), m.received, 101) as [DT-ASSIGN],
	m.original1 as [ PN-ASSIGN],
	CONVERT(VARCHAR(10), m.closed, 101) as [CAN DATE],
	m.current1 as [CAN AMT], 
	'DOD ' + CONVERT(VARCHAR(10), de.dod, 101) AS [Notes],  m.id2 AS [Location Code],
	customer AS [customer number]

FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
	LEFT OUTER JOIN dbo.Deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
WHERE 
((customer IN ('0002258','0002259','0002509', '0002510', '0002513','0002514','0002512')) or (customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))
AND m.status = 'SIF'
AND ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ((ma.customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512')) or (ma.customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405'))) AND batchtype LIKE 'p%'
AND ma.number = m.number
GROUP BY ma.number), 0) = ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ((ma.customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512')) or (ma.customer in ('0001280','0001281')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405'))) AND batchtype LIKE 'p%'
AND p.invoice IS NOT NULL
AND ma.number = m.number
GROUP BY ma.number
), 0)
AND m.number IN (SELECT n.number FROM notes n WITH (NOLOCK) WHERE n.number = m.number AND CAST(created AS DATE) >= CAST(closed AS DATE) AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND result = 'SF')

	-- We need to update master to be returned and create a note
	UPDATE master
	SET Qlevel = '999', returned = FORMAT(GETDATE(), 'MM/dd/yyyy')
	WHERE number IN (SELECT number from #CACS_Closed)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number,getdate(),'EXG','+++++','+++++','Account was sent in a Suntrust Close Report'--'Account was returned to Toyota during the Maintenance Export process.'
	FROM #CACS_Closed t 

	-- Note: Per Kia email 20220725 12:25, the customer number should not be included in the final file sent back to LS.  
    SELECT [STB Acct #], NAME, [STB Close Code], [DT-ASSIGN], [ PN-ASSIGN], [CAN DATE], [CAN AMT], Notes, [LOCATION CODE], [CUSTOMER NUMBER]
    FROM #CACS_Closed

	DROP TABLE #CACS_Closed


END

GO
