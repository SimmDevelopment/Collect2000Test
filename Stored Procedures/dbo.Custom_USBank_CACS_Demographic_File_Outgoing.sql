SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 10/07/2019
-- Description:	Export Demographic file for US Bank CACS system
-- Changes: BGM 01/09/2020 Updated phone changes to not pull duplicates
-- 01/09/2020 Updated email so that all are set to preferred type.
-- 07/13/2022 Updated Address Chnages to show all changes even when coming from EXG and USBank
-- 03/08/2023 Test created for new changes to how Address/Phone/Emails are sent to CACS
-- 04/04/2023 BGM Prepared for Email Express Consent Changes
-- 10/10/2023 BGM Added for Email Consent Update
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Demographic_File_Outgoing] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test	
/*

exec Custom_USBank_CACS_Demographic_File_Outgoing_Test '20230420', '20230420'

*/
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT @startDate AS FileDate

--New Added BGM 07/13/2022
--Address Changes Preferred Addresses
--Update new address information and send as a change action code, current status, and maintain original external key
SELECT DISTINCT m.number, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '2' AS ContactRecordType, d.SpouseJobName AS ExternalKey,--'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), ah.ID) AS ExtKeyPT3,
'C' AS ActionCode, '' AS NickName, '1' AS AddressRelation, 'C' AS AddressStatus, '' AS SeasonalFrom, '' AS SeasonalTo, 'N' AS AddressBlock, '1' AS PrefAddressInd,
'Y' AS CBRAddress, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS CBRAddressDateUpdated, ah.NewStreet1 AS Address1, ISNULL(ah.newstreet2, '') AS Address2, '' AS Address3, ah.NewCity AS City, ah.NewState AS [State],
ah.NewZipcode AS PostalCode, '' AS County, 'US' AS Country, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS ChangeDate, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN AddressHistory ah WITH (NOLOCK) ON ah.DebtorID = d.DebtorID
OUTER APPLY (
    SELECT  TOP 1 *
    FROM    AddressHistory ah2
    WHERE   ah2.AccountID = m.Number
    AND ah2.debtorid = d.DebtorID
    AND ah2.DateChanged BETWEEN @startDate AND @endDate
    ORDER BY ah2.DateChanged DESC
    ) AS ahh
WHERE ah.DateChanged BETWEEN @startDate AND @endDate
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)
AND ah.id = ahh.ID AND ahh.debtorid = d.debtorid
AND (closed IS NULL OR closed BETWEEN @startDate AND @endDate)

UNION ALL	

--Create Add address for old address that was updated and send as an add type, previous status, preferred status as 0 and a new external key
SELECT DISTINCT m.number, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '2' AS ContactRecordType, 'SIMM    ' + CONVERT(VARCHAR(19), m.account) + CONVERT(VARCHAR(9), ah.ID) AS newExternalKey, --'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), ah.ID) AS ExtKeyPT3,
'A' AS ActionCode, '' AS NickName, '1' AS AddressRelation, 'P' AS AddressStatus, '' AS SeasonalFrom, '' AS SeasonalTo, 'N' AS AddressBlock, '0' AS PrefAddressInd,
'' AS CBRAddress, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS CBRAddressDateUpdated, ah.oldstreet1 AS Address1, ISNULL(ah.oldstreet2, '') AS Address2, '' AS Address3, ah.oldcity AS City, ah.oldstate AS [State],
ah.oldzipcode AS PostalCode, '' AS County, 'US' AS Country, CONVERT(VARCHAR(8), ah.DateChanged, 112) AS ChangeDate, '' AS Filler
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN AddressHistory ah WITH (NOLOCK) ON ah.DebtorID = d.DebtorID
OUTER APPLY (
    SELECT  TOP 1 *
    FROM    AddressHistory ah2
    WHERE   ah2.AccountID = m.Number
    AND ah2.debtorid = d.DebtorID
    AND ah2.DateChanged BETWEEN @startDate AND @endDate
    --AND ah2.UserChanged NOT IN ('USBANK', 'EXG')
    ORDER BY ah2.DateChanged DESC
    ) AS ahh
WHERE ah.DateChanged BETWEEN @startDate AND @endDate
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)
--AND ah.UserChanged NOT IN ('USBANK', 'EXG')
AND ah.id = ahh.ID AND ahh.debtorid = d.debtorid
AND (closed IS NULL OR closed BETWEEN @startDate AND @endDate)
ORDER BY CONVERT(VARCHAR(25), d.DebtorMemo)


--Revisit phones
--Phone Changes
SELECT DISTINCT CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '3' AS ContactRecordType, pm.PhoneName AS ExternalKey,--'SIMM    ' AS ExtKeyPT1, CONVERT(VARCHAR(19), m.account) AS ExtKeyPT2, CONVERT(VARCHAR(9), ph.ID) AS ExtKeyPT3,
CASE WHEN ph.NewNumber = '' AND pm.PhoneStatusID = 1 THEN 'D' --existing number marked bad
WHEN ph.NewNumber = '' AND (pm.PhoneStatusID = 2 OR pm.PhoneStatusID IS NULL) AND CAST(ph.DateChanged AS DATE) <> CAST(pm.DateAdded AS DATE) THEN 'C' --existing number previously deleted changed from bad to good or unknown
WHEN pm.DateAdded BETWEEN @startDate AND @endDate AND (pm.PhoneStatusID = 2 OR pm.PhoneStatusID IS NULL) THEN 'A' --non-existing number added to account
ELSE 'C' END  AS ActionCode, 
'' AS NickName, COALESCE(ph.OldNumber, pm.PhoneNumber) AS PhoneNumber, '' AS Extension, 
CASE COALESCE(ph.Phonetype, pm.PhoneTypeID) WHEN 1 THEN 'P' WHEN 2 THEN 'E' WHEN 3 THEN 'C' WHEN 4 THEN 'X' WHEN 14 THEN 'F' WHEN 60 THEN 'G' ELSE 'O' END AS PhoneType, '01' AS PhoneFormat, 
CASE WHEN pm.PhoneStatusID IS NULL THEN 'Z' WHEN pm.phonestatusid = 1 THEN 'X' WHEN pm.phonestatusid = 2 THEN 'V' ELSE 'Z' END AS PhoneAvail, 

			--if only 1 phone number exists for debtor then it is preferred by default
CASE WHEN (SELECT COUNT(*) FROM Phones_Master WITH (NOLOCK) WHERE DebtorID = d.debtorid) = 1 THEN 1 
	--if more than 1 number on account is good and reported number is bad then return not preferred
	WHEN Pm.PhoneStatusID = 1 and (SELECT COUNT(*) FROM Phones_Master WITH (NOLOCK) WHERE DebtorID = d.debtorid AND (PhoneTypeID =2 OR PhoneTypeID IS NULL)) >= 1 THEN '0' 
		--If multiple good numbers on account the top most good number is preferred based on dated entered.
		WHEN pm.phonenumber = (SELECT TOP 1 PhoneNumber FROM Phones_Master WITH (NOLOCK) WHERE DebtorID = d.debtorid AND (PhoneTypeID =2 OR PhoneTypeID IS NULL) ORDER BY DateAdded DESC) THEN '1'
			ELSE '0' END AS PrefPhoneInd,


CASE pt.PhoneTypeMapping WHEN 2 THEN 'C' WHEN 3 THEN 'F' ELSE 'L' END  AS ServiceType, 
CONVERT(VARCHAR(8), COALESCE(ph.DateChanged, pm.DateAdded), 112) AS PhoneChangeDate, 
' ' AS ChangeInd, CASE WHEN pm.PhoneStatusID = 3 THEN 'Y' ELSE 'N' END AS DoNotCont
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
LEFT OUTER JOIN Phones_Master pm WITH (NOLOCK) ON d.DebtorID = pm.DebtorID
INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
OUTER APPLY (
    SELECT  TOP 1 *
    FROM    PhoneHistory ph2
    WHERE   ph2.AccountID = ph.AccountID
    AND ph2.debtorid = ph.DebtorID AND ph2.OldNumber = pm.PhoneNumber
    AND (ph2.DateChanged = ph.DateChanged)
    AND ph2.UserChanged NOT IN ('USBANK', 'EXG')
    ORDER BY ph2.DateChanged DESC
    ) AS phh
WHERE (ph.DateChanged BETWEEN @startDate AND @endDate OR pm.DateAdded BETWEEN @startDate AND @endDate)
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)
AND (ph.ID = phh.ID OR ph.id IS NULL)
AND pm.loginname <> 'SYNC'
ORDER BY CONVERT(VARCHAR(25), d.DebtorMemo)


--Email Add
--Email Consent Changed
SELECT m.number, d.debtorid,
CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID, '4' AS ContactRecordType, e.comment AS ExternalKey,
CASE WHEN CAST(e.createdwhen AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND e.createdby <> 'US Bank' THEN 'A' WHEN CAST(e.modifiedwhen AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND e.modifiedby <> 'US Bank' THEN 'C' ELSE 'D' END AS ActionCode,
'' AS NickName, e.email AS Email, e.typecd AS EmailType, CASE WHEN e.consentgiven = 0 THEN 'R' WHEN e.active = 1 AND e.consentgiven = 1 THEN 'C' ELSE 'U' END AS EmailAvail,
CASE WHEN e.[primary] = 1 THEN 1 ELSE 0 END AS PrefEmailInd,
format(e.modifiedwhen, 'yyyyMMdd') AS EmailChangeDate, ' ' AS ChangeInd
FROM email e WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON e.debtorid = d.debtorid INNER JOIN master m WITH (NOLOCK)  ON d.number = m.number
WHERE ((CAST(e.createdwhen AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND e.createdby <> 'US Bank') OR (CAST(e.modifiedwhen AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND e.modifiedby <> 'US Bank'))
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)


END
GO
