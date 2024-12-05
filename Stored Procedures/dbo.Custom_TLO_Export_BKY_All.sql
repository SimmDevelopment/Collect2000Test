SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: April 10, 2012
-- Description:	Export bankruptcy file to send to TLO
-- service 5024 test 5023 live
-- =============================================
CREATE PROCEDURE [dbo].[Custom_TLO_Export_BKY_All]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
--setup GUID for batchID in Service History Table
DECLARE @guid UNIQUEIDENTIFIER
SET @guid = NEWID()

--Insert into Service Batch request table
INSERT INTO dbo.ServiceBatch_REQUESTS
        ( BatchID , ServiceID , ManifestID , ProfileID , PresetID , DateRequested , RequestedBy , RequestedProgram , 
			imgRequest , xmlRequest)
SELECT @guid, 5024, '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000',
	GETDATE(), 'Job Manager', 'Job Manager', '0x00', ''

--Insert Note on account stating sent to TLO service
INSERT INTO dbo.notes
        ( number , ctl , created , user0 , action , result , comment)
SELECT DISTINCT m.number, 'ctl', GETDATE(), 'TLO', 'Send', 'Send', 'TLO Bankruptcy data ordered ' + CONVERT(VARCHAR(10), GETDATE(), 101)
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = '0000000' AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5024, 5009))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5024)
AND customer = '0001031' AND received = '20171006'

--insert into Service History Table
INSERT INTO dbo.ServiceHistory
 ( AcctID , DebtorID , CreationDate , ServiceID , RequestedBY , RequestedProgram , Processed , SystemYear , SystemMonth ,
     BatchId , RequestingDate , RequestedDate)
        
--Values for insert into the Service history table
SELECT distinct m.number, d.DebtorID, GETDATE(), 5024, 'Job Manager', 'Job Manager', 1, DATEPART(yy, GETDATE()), DATEPART(mm, GETDATE()),
	 @guid AS batchid, GETDATE(), GETDATE()
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE desk = '0000000' AND m.number not IN (SELECT AcctID FROM servicehistory WITH (NOLOCK) WHERE serviceid IN (5024, 5009))
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5024)
AND customer = '0001031' AND received = '20171006'


--Get information to go into the Exported Text file

SELECT DISTINCT m.number, d.debtorid, sh.requestid, d.firstName, d.middleName, d.lastName, d.SSN, d.Street1, d.Street2, d.City, d.State, d.Zipcode, m.ContractDate, 'BK' AS filetype
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN dbo.ServiceHistory sh WITH (NOLOCK) ON m.number = sh.AcctID
WHERE desk = '0000000' AND sh.BatchId = @guid
AND customer IN (SELECT customer FROM dbo.ServicesCustomers cs WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON cs.CustomerID = c.CCustomerID WHERE cs.serviceid = 5024)
AND customer = '0001031' AND received = '20171006'


END
GO
