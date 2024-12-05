SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_POA_V34] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.client_account_number') AS [equabliAccountNumber], 
	CASE WHEN m.status = 'ATY' THEN '12' WHEN m.status IN('CCS','CCC') THEN '28' WHEN m.status IN ('B07','B11','B13','BKO','BKY') THEN '42' 
    WHEN m.status in ('POA','POO') THEN '36' WHEN m.status in ('DMC','DSA') THEN '35' END AS [contactType], D.firstName AS [firstName -Name of DSC], 
	D.middleName AS [middleName], D.lastName AS [lastName], a.Name AS [businessName], a.Addr1 AS [address1], a.Addr2 AS [address2], a.City AS [city], '' AS [country], a.State AS [stateCode], a.Zipcode AS [zip],  (Replace(REPLACE(REPLACE(REPLACE(a.phone, '-',''), '(',''), ')',''), ' ','')) AS [phoneNumber], 
	'O' AS [phoneType], '' AS [isPrimaryPhone], 'U' AS [phoneStatus], a.Email AS [emailAddress], --CASE WHEN m.closed IS NULL THEN 'Y' ELSE 'N' END AS [isConsumerActive]
	CASE WHEN a.Name = '' THEN 'N' ELSE 'Y' END AS [isConsumerActive]
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH(NOLOCK) ON m.number = d.Number
INNER JOIN dbo.DebtorAttorneys a WITH (NOLOCK) ON m.number = a.AccountID
INNER JOIN StatusHistory sh WITH(NOLOCK) ON m.number = sh.AccountID
WHERE m.status IN ('ATY','CCS','CCC','B07','B11','B13','BKO','BKY','POA','DMC','DSA','POO')
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
AND sh.DateChanged BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
