SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/03/2023
-- Description:	Exports final file to ship to Equabli with deceased dates.
-- Changes:		
--		05/24/2023 BGM removed Co debtor fields as they are not used in the file.
--		11/o1/2023 BGM Added new way to return primary borrower birth date when source has multiple formats sent to us.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Deceased_Return_File]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
 cedssd.prifirstname AS [Primary Borrower First Name]
, cedssd.prilastname AS [Primary Borrower Last Name]
, cedssd.prissn AS [Primary Borrower SSN]
, CAST(cedssd.pridob AS DATE) AS [Primary Borrower Birth Date] --Default Return Method for weekly Deceased File
--Alternate return method for AdHoc requests
--, CAST(CASE WHEN SUBSTRING(RIGHT(cedssd.PriDOB, 3), 1, 1) IN ('9','0') THEN pridob 
--	ELSE SUBSTRING(cedssd.PriDOB, 4, 2) + '/' + SUBSTRING(cedssd.PriDOB, 1, 2) + 
--		CASE WHEN SUBSTRING(cedssd.PriDOB, 7, 1) in ('0', '0') THEN '/20' ELSE '/19' END + RIGHT(cedssd.PriDOB, 2) END AS DATE) AS [Primary Borrower Birth Date]
, cedssd.priaddr1 AS [Primary Borrower Address]
, cedssd.pricity AS [Primary Borrower City]
, cedssd.pristate AS [Primary Borrower State]
, cedssd.prizip AS [Primary Borrower Zip]
--, cedssd.cofirstname AS [Co Borrower First Name]
--, cedssd.colastname AS [Co Borrower Last Name]
--, cedssd.cossn AS [Co Borrower SSN]
--, cedssd.codob AS [Co Borrower Birth Date]
--, cedssd.coaddr1 AS [Co Borrower Address]
--, cedssd.cocity AS [Co Borrower City]
--, cedssd.costate AS [Co Borrower State]
--, cedssd.cozip AS [Co Borrower Zip]
, cedssd.acctnumber AS [Acct Number]
--, cedssd.Creditor AS [Creditor]
--, CAST(cedssd.currbalance AS DECIMAL(9,2)) AS [Current Balance]
, ISNULL(pr.ssn, '') AS [Primary Borrower SSN Returned]
, ISNULL(FORMAT(CASE WHEN SUBSTRING(pr.dob, 3, 1) = '/' THEN FORMAT(CAST(pr.dob AS DATE), 'yyyy-MM-dd') 
WHEN LEN(pr.dob) = 8 THEN RIGHT(pr.dob, 4) + '-' + LEFT(pr.dob, 2) + '-' + SUBSTRING(pr.dob, 3, 2)
WHEN ISNULL(SUBSTRING(pr.dob, 1, 1), '') LIKE '[A-Z]%' THEN CAST(pr.dob AS DATE)
ELSE pr.dob END, 'yyyy-MM-dd'), '') AS [Primary Borrower DOB Returned]
, ISNULL(FORMAT(CASE WHEN SUBSTRING(pr.dod, 3, 1) = '/' THEN FORMAT(CAST(pr.dod AS DATE), 'yyyy-MM-dd') 
WHEN LEN(pr.dod) = 8 THEN RIGHT(pr.dod, 4) + '-' + LEFT(pr.dod, 2) + '-' + SUBSTRING(pr.dod, 3, 2)
WHEN ISNULL(SUBSTRING(pr.dod, 1, 1), '') LIKE '[A-Z]%' THEN CAST(pr.dod AS DATE)
ELSE pr.dod END, 'yyyy-MM-dd'), '') AS [Primary Borrower DOD Returned]
--, ISNULL(cr.ssn, '') AS [Co Borrower SSN Returned]
--, ISNULL(cr.dob, '') AS [Co Borrower DOB Returned]
--, ISNULL(cr.dod, '') AS [Co Borrower DOD Returned]
FROM custom_equabli_dec_scrub_seed_data cedssd LEFT OUTER JOIN custom_equabli_deceased_returned pr ON cedssd.prissn = pr.ssn AND cedssd.acctnumber = pr.loanid 
--LEFT OUTER JOIN custom_equabli_deceased_returned cr ON cedssd.cossn = cr.ssn AND cedssd.acctnumber = cr.loanidEND

END
GO
