SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Changes:
	01/22/2021 BGM Changed from Paid1 to Totalpaid in order to capture overpays.
	11/04/2022 BGM Updated Transaction date to use the date of the orginal payment that was reversed.
	07/03/2023 BGM Updated strata Code retrieval from the ID1 field for the Union Bank Merger.
	07/03/2023 Updated to customer group 382
	10/13/2023 Setup for Language Preference Update


*/


--ALTER  the procedure.
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Export_Remit]

@invoice varchar(8000)

AS

	DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test	


SELECT CASE WHEN m.customer	IN (SELECT customerid from fact where customgroupid = 319) THEN ID1 ELSE c.CustomText3 END AS [Strata Code], m.account AS [Account Number], 
ISNULL((SELECT top 1 CONVERT(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID), (CONVERT(VARCHAR(10), p.datepaid, 101))) AS [Transaction Date],
--CONVERT(VARCHAR(10), p.datepaid, 101)  AS [Transaction Date],
CONVERT(VARCHAR(10), p.invoiced, 101) AS [Date Posted at Vendor],
CASE WHEN batchtype LIKE '%R' THEN -(p.totalpaid) ELSE p.totalpaid END AS [Gross payment Amt], 
CASE WHEN batchtype LIKE '%R' THEN -(p.totalpaid - p.CollectorFee) ELSE (p.totalpaid - p.CollectorFee) END AS [Net payment Amt], 
CASE WHEN batchtype LIKE '%R' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS [Fee],
fsd.Fee1 AS [Commission Rate],
CASE WHEN batchtype LIKE 'PC%' THEN 'Direct Payment to USB' ELSE 'Remit by Vendor' END AS [Remit Type]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number 
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID) --AND returned IS NULL AND batchtype LIKE 'P%'
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
ORDER BY CASE WHEN batchtype LIKE 'PC%' THEN 'Direct Payment to USB' ELSE 'Remit by Vendor' END
GO
