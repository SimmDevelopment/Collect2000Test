SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: April 10, 2012
-- Description:	Export Deceased file to send to TLO
-- service 5025 test 5024 live
-- =============================================
CREATE PROCEDURE [dbo].[Custom_TLO_Export_DEC_All]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
--setup GUID for batchID in Service History Table
DECLARE @guid UNIQUEIDENTIFIER
SET @guid = NEWID()

IF EXISTS (SELECT m.number, 'ctl', GETDATE(), 'TLO', 'Send', 'Send', 'TLO Deceased data ordered ' + CONVERT(VARCHAR(10), GETDATE(), 101)
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = 'NOBKCY' AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5025, 5010))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5025)
)
begin

--Insert into Service Batch request table
INSERT INTO dbo.ServiceBatch_REQUESTS
        ( BatchID , ServiceID , ManifestID , ProfileID , PresetID , DateRequested , RequestedBy , RequestedProgram , 
			imgRequest , xmlRequest)
SELECT @guid, 5025, '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000',
	GETDATE(), 'Job Manager', 'Job Manager', '0x00', ''

--Insert Note on account stating sent to TLO service
INSERT INTO dbo.notes
        ( number , ctl , created , user0 , action , result , comment)
SELECT DISTINCT m.number, 'ctl', GETDATE(), 'TLO', 'Send', 'Send', 'TLO Deceased data ordered ' + CONVERT(VARCHAR(10), GETDATE(), 101)
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = 'NOBKCY' AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5025, 5010))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5025)

--insert into Service History Table
INSERT INTO dbo.ServiceHistory
 ( AcctID , DebtorID , CreationDate , ServiceID , RequestedBY , RequestedProgram , Processed , SystemYear , SystemMonth ,
     BatchId , RequestingDate , RequestedDate)
        
--Values for insert into the Service history table
SELECT distinct m.number, d.DebtorID, GETDATE(), 5025, 'Job Manager', 'Job Manager', 1, DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE()),
	 @guid AS batchid, GETDATE(), GETDATE()
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = 'NOBKCY' AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5025, 5010))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5025)


--Get information to go into the Exported Text file
SELECT 'requestid' AS requestid, 'debtorid' AS debtorid, 'number' AS number, 'firstname' AS firstName, 'middlename' AS middleName,
	'lastname' AS lastName, 'SSN' AS SSN, 'street1' AS Street1, 'street2' AS Street2, 'city' AS City, 'state' AS State, 'zipcode' AS Zipcode,
	'contractdate' AS ContractDate, 'filetype' AS filetype

select DISTINCT sh.requestid, d.debtorid, m.number, d.firstName, d.middleName, d.lastName, d.SSN, d.Street1, d.Street2, d.City, d.State, d.Zipcode, dbo.date(ISNULL(m.ContractDate, '19000101')) AS ContractDate, 'DC' AS filetype
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5025 AND d.debtorid = sh.DebtorID
WHERE desk = 'NOBKCY' AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5025)
UNION
select DISTINCT sh.requestid, d.debtorid, m.number, d.firstName, d.middleName, d.lastName, d.SSN, d.Street1, d.Street2, d.City, d.State, d.Zipcode, dbo.date(ISNULL(m.ContractDate, '19000101')) AS ContractDate, 'DC' AS filetype
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 1 INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID AND sh.serviceid = 5025 AND d.debtorid = sh.DebtorID
WHERE desk = 'NOBKCY' AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5025)


end

END
GO
