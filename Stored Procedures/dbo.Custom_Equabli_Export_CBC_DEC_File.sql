SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian Meehan
-- Create date: 05/01/2023
-- Description:	Export Deceased file to send to Innovis for Equabli after checking Simm Internal Deceased DB
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_CBC_DEC_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
INSERT INTO custom_equabli_deceased_returned 
(loanid, ssn, dod, dob)

SELECT DISTINCT df.acctnumber, z.ssn, z.dod, z.dob
FROM custom_equabli_dec_scrub_seed_data df	WITH (NOLOCK) 
OUTER APPLY (SELECT  TOP 1 d.id, d.ssn, dod, d.dob
		FROM    deceased AS d 
		WHERE   D.ssn = df.prissn
		ORDER BY D.id DESC, d.dob DESC
		) AS z 
WHERE df.prissn IN (SELECT ssn FROM deceased d WITH (NOLOCK) )
AND df.prissn NOT IN (SELECT ssn FROM custom_equabli_deceased_returned cedr)
AND prissn NOT IN ('', '0') 


--Get information to go into the Exported Text file
SELECT 'requestid' AS requestid, 'debtorid' AS debtorid, 'number' AS number, 'firstname' AS firstName, 'middlename' AS middleName,
	'lastname' AS lastName, 'SSN' AS SSN, 'street1' AS Street1, 'street2' AS Street2, 'city' AS City, 'state' AS State, 'zipcode' AS Zipcode,
	'contractdate' AS ContractDate, 'filetype' AS filetype

--Select accounts that were not found during the internal scrub process
SELECT df.acctnumber AS requestid, df.acctnumber AS debtorid, df.acctnumber AS number, dbo.fnAlphaOnly(df.prifirstname) AS firstName, '' AS middleName, 
dbo.fnAlphaOnly(df.prilastname) AS lastName, df.prissn AS SSN, CASE WHEN df.priaddr1 LIKE '%,%' THEN REPLACE(SUBSTRING(df.priaddr1, 1, CHARINDEX(',', df.priaddr1) -1), ',', '') ELSE df.priaddr1 END AS Street1, 
'' AS Street2, CASE WHEN df.pricity LIKE '%,%' THEN REPLACE(SUBSTRING(df.pricity, 1, CHARINDEX(',', df.pricity) -1), ',', '') ELSE df.pricity END AS City, df.pristate AS State, df.prizip AS Zipcode, CAST('19000101' AS DATE) AS ContractDate, 'DC' AS filetype
FROM custom_equabli_dec_scrub_seed_data df	WITH (NOLOCK) 

UNION ALL

SELECT df.acctnumber AS requestid, df.acctnumber AS debtorid, df.acctnumber AS number, dbo.fnAlphaOnly(df.cofirstname) AS firstName, '' AS middleName, 
dbo.fnAlphaOnly(df.colastname) AS lastName, df.cossn AS SSN, CASE WHEN df.coaddr1 LIKE '%,%' THEN REPLACE(SUBSTRING(df.coaddr1, 1, CHARINDEX(',', df.coaddr1) -1), ',', '') ELSE df.coaddr1 END AS Street1, 
'' AS Street2, CASE WHEN df.cocity LIKE '%,%' THEN REPLACE(SUBSTRING(df.cocity, 1, CHARINDEX(',', df.cocity) -1), ',', '') ELSE df.cocity END AS City, df.costate AS State, df.cozip AS Zipcode, CAST('19000101' AS DATE) AS ContractDate, 'DC' AS filetype
FROM custom_equabli_dec_scrub_seed_data df	WITH (NOLOCK) 
WHERE df.cossn <> ''

END
GO
