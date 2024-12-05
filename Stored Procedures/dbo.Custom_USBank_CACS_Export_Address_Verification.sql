SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 06/05/2023
-- Description:	Gets addresses that do not match what US bank sent in their file
-- Changes:
--		07/03/2023 Updated to customer group 382
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Export_Address_Verification]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CustGroupID INT
	--SET @CustGroupID = 382 --Production
	SET @CustGroupID = 113 --Test	

	SELECT m.number, d.name, CASE d.seq WHEN 0 THEN 'Primary' WHEN 1 THEN 'Secondary' END AS Debtor 
, D.street1 AS Latitude_Street1
, D.street2 AS Latitude_Street2
--, D.city AS Latitude_City
--, D.state AS Latitude_State
--, D.zipcode AS Latitude_Zip
, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.addressline1'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.address1')) AS US_Bank_Addr_Line1
, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.addressline2'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.address2')) AS US_Bank_Addr_Line2
, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.addressline3'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.address3')) AS US_Bank_Addr_Line3
--, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.city'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.city')) AS Pri_US_Bank_Line1	
--, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.state'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.state')) AS Pri_US_Bank_Line2
--, ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.zip'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.zip')) AS Pri_US_Bank_Line3
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND (ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.addressline1'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.address1')) <> D.street1
AND ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = CASE WHEN D.seq = 0 THEN 'Pri' ELSE 'Sec' END + '.0.addressline1'), (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'a.0.address1')) <> D.street1 + ' ' + D.street2)
AND CAST(m.received AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND d.debtorid NOT IN (SELECT ah.debtorid FROM addresshistory ah WITH (NOLOCK) WHERE ah.debtorid = D.debtorid) 
ORDER BY m.number
END
GO
