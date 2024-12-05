SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: February 5, 2018
-- Description:	Export Deceased file that has checked Internal Deceased Table
-- Export out 2 query results, one that hit the internal table and one that does not hit.
-- Service 5037 in Test, TLO Deceased 5024, Lexis 5010
-- Changed query to only pull DOB and DOD from deceased table, the rest will come from the debtors table.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Simm_Export_DEC_All]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
--setup GUID for batchID in Service History Table
DECLARE @guid UNIQUEIDENTIFIER
SET @guid = NEWID()

--Check if incoming account has already been sent for scrubbing process on current date (prevent duplicate sending)
IF EXISTS (SELECT m.number
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = '0000000' AND m.closed IS NULL AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5037, 5024, 5010) AND dbo.date(requestingdate) = dbo.date(GETDATE()))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK)))

begin

--Insert into Service Batch request table
INSERT INTO dbo.ServiceBatch_REQUESTS
        ( BatchID , ServiceID , ManifestID , ProfileID , PresetID , DateRequested , RequestedBy , RequestedProgram , 
			imgRequest , xmlRequest)
SELECT @guid, 5037, '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000',
	GETDATE(), 'Job Manager', 'Job Manager', '0x00', ''

--Insert Note on account stating checked against internal database
INSERT INTO dbo.notes
        ( number , ctl , created , user0 , action , result , comment)
SELECT DISTINCT m.number, 'ctl', GETDATE(), 'SIMM', 'INT', 'SRCH', 'SIMM Internal Deceased Data Checked ' + CONVERT(VARCHAR(10), GETDATE(), 101)
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = '0000000' AND m.closed IS NULL AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5037, 5024, 5010) AND dbo.date(requestingdate) = dbo.date(GETDATE()))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK))


--insert into Service History Table
INSERT INTO dbo.ServiceHistory
 ( AcctID , DebtorID , CreationDate , ServiceID , RequestedBY , RequestedProgram , Processed , SystemYear , SystemMonth ,
     BatchId , RequestingDate , RequestedDate)
        
--Values for insert into the Service history table
SELECT distinct m.number, d.DebtorID, GETDATE(), 5037, 'Job Manager', 'Job Manager', 1, DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE()),
	 @guid AS batchid, GETDATE(), GETDATE()
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = '0000000' AND m.closed IS NULL AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5037, 5024, 5010) AND dbo.date(requestingdate) = dbo.date(GETDATE()))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK))


--Get information to go into the Exported Text file
--SELECT 'requestid' AS requestid, 'firstname' AS firstName, 'lastname' AS lastName, 'SSN' AS SSN, 'state' AS State, 'zipcode' AS Zipcode,
--	'dob' AS dob, 'DOD' AS DOD, 'ClaimDeadline' AS ClaimDeadline, 'DateFiled' AS DateFiled, 'CaseNumber' as CaseNumber,
--	'Executor' AS Executor, 'ExecutorPhone' AS ExecutorPhone, 'ExecutorFax' AS ExecutorFax, 'ExecutorStreet1' AS ExecutorStreet1,
--	'ExecutorStreet2' AS ExecutorStreet2, 'ExecutorState' AS ExecutorState, 'ExecutorCity' AS ExecutorCity, 'ExecutorState' AS ExecutorState, 
--	'ExecutorZipcode' AS ExecutorZipcode, 'CourtCity' AS CourtCity, 'CourtDistrict' AS CourtDistrict, 'CourtDivision' AS CourtDivision,
--	'CourtPhone' AS CourtPhone, 'CourtStreet1' AS CourtStreet1, 'CourtStreet2' AS CourtStreet2, 'CourtState' AS CourtState, 'CourtZipcode' AS CourtZipcode
	
	
--Return Primary Debtor Hit
select DISTINCT sh.requestid, dbo.fnAlphaOnly(d.firstName) AS firstName, dbo.fnAlphaOnly(d.lastName) AS lastName, d.SSN, 
REPLACE(d.State, ',', ' ') AS State, REPLACE(d.Zipcode, ',', ' ') AS Zipcode, d2.dob, d2.DOD
--, d2.ClaimDeadline, d2.DateFiled, d2.CaseNumber,
--d2.Executor, d2.ExecutorPhone, d2.ExecutorFax, d2.ExecutorStreet1, d2.ExecutorStreet2, d2.ExecutorCity, d2.ExecutorState,
--d2.ExecutorZipcode, d2.CourtDistrict, d2.CourtDivision, d2.CourtPhone, d2.CourtStreet1, d2.CourtStreet2, d2.CourtCity, d2.CourtState,
--d2.CourtZipcode
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5037 AND d.debtorid = sh.DebtorID
INNER JOIN Deceased d2 WITH (NOLOCK) ON dbo.StripNonDigits(d.ssn) = dbo.StripNonDigits(d2.SSN)
WHERE desk = '0000000' AND m.closed IS NULL AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK)) AND d.ssn <> ''

UNION

--Return Co-Debtor Hit
select DISTINCT sh.requestid, dbo.fnAlphaOnly(d.firstName) AS firstName, dbo.fnAlphaOnly(d.lastName) AS lastName, d.SSN, 
REPLACE(d.State, ',', ' ') AS State, REPLACE(d.Zipcode, ',', ' ') AS Zipcode, d2.dob, d2.DOD
--, d2.ClaimDeadline, d2.DateFiled, d2.CaseNumber,
--d2.Executor, d2.ExecutorPhone, d2.ExecutorFax, d2.ExecutorStreet1, d2.ExecutorStreet2, d2.ExecutorCity, d2.ExecutorState,
--d2.ExecutorZipcode, d2.CourtDistrict, d2.CourtDivision, d2.CourtPhone, d2.CourtStreet1, d2.CourtStreet2, d2.CourtCity, d2.CourtState,
--d2.CourtZipcode
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 1 
INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5037 AND d.debtorid = sh.DebtorID
INNER JOIN Deceased d2 WITH (NOLOCK) ON dbo.StripNonDigits(d.ssn) = dbo.StripNonDigits(d2.SSN)
WHERE desk = '0000000' AND m.closed IS NULL AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK)) AND d.ssn <> ''

--Return non-hits for Primary Debtor
SELECT  DISTINCT  sh.requestid, 'ACCOUNT RECEIVED' AS comment
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5037 AND d.debtorid = sh.DebtorID
WHERE desk = '0000000' AND m.closed IS NULL AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK))
AND (dbo.StripNonDigits(d.ssn) NOT IN (SELECT dbo.StripNonDigits(ssn) FROM Deceased d WITH (NOLOCK)) OR d.ssn = '')

UNION

--Return non-hits for Co-Debtor
SELECT  DISTINCT  sh.requestid, 'ACCOUNT RECEIVED' AS comment
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 1 
INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5037 AND d.debtorid = sh.DebtorID
WHERE desk = '0000000' AND m.closed IS NULL AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5037)
AND m.number NOT IN (SELECT accountid FROM dbo.Deceased WITH (NOLOCK))
AND (dbo.StripNonDigits(d.ssn) NOT IN (SELECT dbo.StripNonDigits(ssn) FROM Deceased d WITH (NOLOCK)) OR d.ssn = '')

end

END
GO
