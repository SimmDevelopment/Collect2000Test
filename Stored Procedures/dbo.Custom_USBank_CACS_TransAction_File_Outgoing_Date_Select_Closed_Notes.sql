SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 10/30/2019
-- Description:	Exports main update file for US Bank CACS system using date range
-- Changes:		10/07/2019 BGM removed datecreated field from bankruptcy, does not exist in production database, for CDS BCN and Status BKY
--				10/30/2019 BGM Added uid to payments so true multiple pays on same day same account are not missed
--				11/21/2019 BGM Updated Unconfirmed BKY to look at the bankruptcy table for information, if none then it will report this code
--				11/22/2019 BGM Updated 215 to send Code K pending BK when closed BKY and no BK information entered in BK table.
--				11/22/2019 BGM Updated CDS DC1 DC2 to include unconfirmed deceased.
--				11/22/2019 BGM Updated 215 with DIN code and close DEC accounts in live stream
--				12/02/2019 BGM Updated 425 with inbound codes.
--				12/03/2019 BGM Updated CDS AGS AGT Code for 2 days in advance buffer for same day installments.
--				12/05/2019 BGM Updated CDS AGV to check if primary debtor is a business, if true then submit the name address of the codebtor.
--				12/05/2019 BGM Updated CDS DC1 and DC2 added filter to exclude business debtors
--				12/06/2019 BGM Added previously paid amounts prior to SIF amounts
--				12/10/2019 BGM Added 215 code D and dispute status code to 400 to send when status DPV is used as close due to dispute
--				12/12/2019 BGM Added Free Form comments up to 300 characters to 425 8B code
--				12/18/2019 BGM Changed original balance to use function Net Original balance
--				01/21/2020 BGM Added Action CO to be excluded from Deceased scrub notes
--				01/23/2020 BGM Adjusted 425 scrub codes to only show sending and also set innovis and tu as skips.
--				01/23/2020 BGM Added Closing status OOS to be sent as a CEE or DEE depending on stream.
--				02/07/2020 BGM Added Closing status SIF PIF 215 to be echoed back when 910 is received.
--				02/11/2020 BGM Updated CDS AGS to pick up current day SIF'd accounts
--				03/10/2020 BGM Updated Balance at settlement to account for payments made between the sif log running and the trans data file running.
--				03/10/2020 BGM Updated Settlement offered to exclude post dates paid recently.
--				03/10/2020 BGM Updated Amount Forgiven to exclude post dates paid recently
--				03/10/2020 BGM Updated Settlement start date and end date padded 5 days out.
--				03/10/2020 BGM Updated Settlement Percent of Balance to add paid post dates.
--				03/20/2020 BGM Updated 400 EXTREQ1 record to only send on payers and hot accounts that are recalled with T/R or N codes.
--				05/01/2020 BGM Updated AGS to give settlement offered amount to not include previous payments
--				05/14/2020 BGM Updated AGS percent of balance to use current queries for Balance and Settlement amount.
--				05/27/2020 BGM Updated Projected End Date to match installment1 date when the date is within 5 days of the entered date.
--				06/10/2020 BGM Updated 425 83, 84, 85, 8S to send datechanged and not received date
--				09/17/2020 BGM Updated 400 and CEA to send a CAD type verbal when note result code VCD is used.
--				09/29/2020 BGM Updated codes to not be sent on closed accounts unless closed during file dates.
--				10/12/2020 BGM Added Action codes TN, DP and result code TW.
--				11/10/2020 BGM Added new action codes per USB
--				12/18/2020 BGM Added up to 3000 characters to be returned on records 425 for notes
--				02/08/2021 BGM Added Preferred Language Update code for 425 9S
--				02/08/2021 BGM Updated Extension Request to pull accounts based on keeper import notes.
--				03/17/2021 BGM Added new AC codes from test.
--				03/22/2021 BGM Updated how the projected end date and last promise date is set to 5 days padding
--				03/25/2020 BGM Updated Settle new/pro/upd and projected end date code for all post dates.
--				03/31/2021 BGM Adjusted above code
--				04/05/2021 BGM Typo found in AGS/T records for PPA PCC Settlement type was a < changed to > to match PDCs
--				04/27/2021 BGM Added 00 to 300-2 record in the NewDebits field.
--				05/03/2021 BGM Added blank to 300 records if no commision for affect field pos. 118
--				05/05/2021 BGM Updated how Amount forgiven is calculated by removing the checking of last paid date and using master paid amount only.
--				08/05/2021 BGM Changed PDC code to not pick up recently deleted post date records and adding them to the number of pdc and duplcating them in the pdc AGS AGT records
--				08/17/2021 BGM Added result code 99 as no answer codes 95 - 98 for outbound phonetypes
--				09/10/2021 BGM Added result code AMNM as type NA
--				09/30/2021 BGM Added result codes WN and TO to inbounds to return code 8I
--				09/30/2021 BGM Added action and result codes for probate court calls to return code 8C and code DA and TD to return NA
--				10/13/2021 BGM Removed Debtor and Deceased table reference for 8T code.
--				11/22/2021 BGM Replaced collectorfee with the fuction Custom_CalculatePaymentTotalFee(P.uid)
--				05/03/2022 BGM Added code DP to No Answer trans code 95
--				09/21/2022 BGM Added result code 3PHU to inbound third party codes
--				11/04/2022 BGM Updated record 217 to send the original payment date of the reversed transaction.
--				12/08/2022 BGM removed restriction to Primary debtor only so the 400 record will send on the Co-if entered.
--				02/14/2023 BGM Changed the return code for RSK accounts to CEE or DEE for Deceased Stream
--				02/27/2023 BGM Added code to the 425 BKN, DSP and VOD parts to look at the status changes for those codes only.
--				04/05/2023 BGM Added HU and DHU for inbound hangup calls
--				04/21/2023 BGM Updated closed date range search to add a day to the end date so if an account is closed on the current day before processing it will get picked up.
--				04/24/2023 BGM Special Export to get missing notes on accounts that closed between 00 and 08:59 the following day.
--				07/03/2023 Updated to customer group 382
--				08/30/2023 Updated catch code 8B to 91 for all non comment responses
--				08/30/2023 Updated by adding missing action codes 3P, AT and TP
--				01/02/2024 BGM Update 425 outgoing and incoming action type codes for 8B and 91 to be used correctly.
--								8B = Agency Comments - General, 91 = Agency Outbound - Unknown
--								Removed Action code DT from Outbound Calling portion
--								Removed Action code TP from Outbound Calling portion
--								Added Result code TS to appropriate action codes
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_TransAction_File_Outgoing_Date_Select_Closed_Notes] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--exec Custom_USBank_CACS_TransAction_File_Outgoing_Date_Select '20200508', '20200508'
--DECLARE @startdate DATETIME
--DECLARE @endDate DATETIME

--SET @startDate = DATEADD(dd, -1, GETDATE())
--SET @endDate = DATEADD(dd, -1, GETDATE())
--SET @startDate = DATEADD(hh, 17, dbo.F_START_OF_DAY(@startDate))


SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT @startDate AS FileDate
--#region Record 425 New Accts, Addr Upd, VOD, BKN, Language

--Record 425 New accounts
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'8D' AS AgyActCode, CONVERT(VARCHAR(8), received, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIMM    ' AS ThirdPartyID,
--	'SYSTEM' AS AgyCollID, '' AS AgyHistoryTxt
--FROM master m WITH (NOLOCK)
--WHERE received BETWEEN @startDate AND @endDate
--AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

--UNION ALL

--Record 425 Address Update
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'85' AS AgyActCode, CONVERT(VARCHAR(8), ISNULL(ah.DateChanged, received), 112) AS AgyActDate, '000000' AS AgyActTime, 'SIMM    ' AS ThirdPartyID,
	'SYSTEM' AS AgyCollID, d.SpouseJobName + ', ' + d.Street1 + ', ' + d.Street2 + ', ' + d.City + ', ' + d.State + ', ' + d.Zipcode AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
LEFT OUTER JOIN AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
WHERE (received BETWEEN @startDate AND @endDate	OR ah.DateChanged BETWEEN @startDate AND @endDate)
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))

UNION ALL

----Record 425 Validation of Debt
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'83' AS AgyActCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIMM    ' AS ThirdPartyID,
--	'SYSTEM' AS AgyCollID, CONVERT(VARCHAR(10), sh.DateChanged, 101) + ', ' + d.name + ', All Available Dates'  AS AgyHistoryTxt
--FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
--INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID AND sh.NewStatus = 'DSP'
--WHERE m.status IN ('DSP') AND sh.DateChanged BETWEEN @startDate AND @endDate
--AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

--UNION ALL

----Record 425 Broken Promise
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'8S' AS AgyActCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIMM    ' AS ThirdPartyID,
--	'SYSTEM' AS AgyCollID, 'Promise Broken'  AS AgyHistoryTxt
--FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
--INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID AND sh.NewStatus = 'BKN'
--WHERE m.status IN ('BKN') AND sh.DateChanged BETWEEN @startDate AND @endDate
--AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

--UNION ALL

--Record 425 VOD Complete
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	'84' AS AgyActCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS AgyActDate, '000000' AS AgyActTime, 'SIMM    ' AS ThirdPartyID,
	'SYSTEM' AS AgyCollID, ''  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID AND sh.NewStatus = 'VOD'
WHERE m.status IN ('VOD') AND sh.DateChanged BETWEEN @startDate AND @endDate
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))
UNION ALL

--Record 425 Preferred Language Updated Primary added 02/08/2021
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'9S' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
CONVERT(VARCHAR(50), d.DebtorMemo) + ', ' +
CASE d.language	
	WHEN '0004 - ARABIC' THEN 'AR'  
	WHEN '0025 - BENGALI' THEN 'BE'  
	WHEN '0026 - CZECH' THEN 'CE'  
	WHEN '0027 - MANDARIN' THEN 'CM'  
	WHEN '0009 - GERMAN' THEN 'DE'  
	WHEN '0010 - GREEK'  THEN 'EL'  
	WHEN '0001 - ENGLISH' THEN 'EN'  
	WHEN '0028 - ESTONIAN' THEN 'ES'  
	WHEN '0008 - FRENCH' THEN 'FR'  
	WHEN '0029 - CREOLE' THEN 'HA'  
	WHEN '0012 - HINDI' THEN 'HI'  
	WHEN '0005 - ARMENIAN' THEN 'HY'  
	WHEN '0014 - ITALIAN' THEN 'IT'  
	WHEN '0015 - JAPANESE' THEN 'JP'  
	WHEN '0016 - KOREAN' THEN 'KO'  
	WHEN '0030 - LITHUANIAN' THEN 'LI'  
	WHEN '0018 - POLISH' THEN 'PO'  
	WHEN '0019 - PORTUGUESE' THEN 'PT'  
	WHEN '0031 - FARSI' THEN 'PR'  
	WHEN '0020 - RUSSIAN' THEN 'RU'  
	WHEN '0002 - SPANISH' THEN 'SP'  
	WHEN '0032 - ALBANIAN' THEN 'SQ'  
	WHEN '0021 - TAGALOG' THEN 'TG'  
	WHEN '0022 - VIETNAMESE' THEN 'VI'  
	WHEN '0033 - CANTONESE' THEN 'YU'  
	WHEN '0003 - OTHER' THEN 'ZX'  
	WHEN '0024 - NOT VERIFIED' THEN 'UN'  
	ELSE 'ZX'		 
END  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND convert(varchar(300), n.comment) LIKE 'Debtor(1) Language was:%'
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] = '+++++' AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result = '+++++'
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))

UNION ALL

--Record 425 Preferred Language Codebtor Updated added 02/08/2021
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'9S' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
CONVERT(VARCHAR(50), d.DebtorMemo) + ', ' +
CASE d.language	
	WHEN '0004 - ARABIC' THEN 'AR'  
	WHEN '0025 - BENGALI' THEN 'BE'  
	WHEN '0026 - CZECH' THEN 'CE'  
	WHEN '0027 - MANDARIN' THEN 'CM'  
	WHEN '0009 - GERMAN' THEN 'DE'  
	WHEN '0010 - GREEK'  THEN 'EL'  
	WHEN '0001 - ENGLISH' THEN 'EN'  
	WHEN '0028 - ESTONIAN' THEN 'ES'  
	WHEN '0008 - FRENCH' THEN 'FR'  
	WHEN '0029 - CREOLE' THEN 'HA'  
	WHEN '0012 - HINDI' THEN 'HI'  
	WHEN '0005 - ARMENIAN' THEN 'HY'  
	WHEN '0014 - ITALIAN' THEN 'IT'  
	WHEN '0015 - JAPANESE' THEN 'JP'  
	WHEN '0016 - KOREAN' THEN 'KO'  
	WHEN '0030 - LITHUANIAN' THEN 'LI'  
	WHEN '0018 - POLISH' THEN 'PO'  
	WHEN '0019 - PORTUGUESE' THEN 'PT'  
	WHEN '0031 - FARSI' THEN 'PR'  
	WHEN '0020 - RUSSIAN' THEN 'RU'  
	WHEN '0002 - SPANISH' THEN 'SP'  
	WHEN '0032 - ALBANIAN' THEN 'SQ'  
	WHEN '0021 - TAGALOG' THEN 'TG'  
	WHEN '0022 - VIETNAMESE' THEN 'VI'  
	WHEN '0033 - CANTONESE' THEN 'YU'  
	WHEN '0003 - OTHER' THEN 'ZX'  
	WHEN '0024 - NOT VERIFIED' THEN 'UN'  
	ELSE 'ZX'		 
END  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 1
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND convert(varchar(300), n.comment) LIKE 'Debtor(2) Language was:%'
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] = '+++++' AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result = '+++++'
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))

--#endregion
UNION ALL

--#region Record 425 Waterfall and Legal Scrubs

--Record 425 Scrubs, 300 Comment
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part2
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 301, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 300
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part3
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 601, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 600
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part4
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 901, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 900
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part5
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1201, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1200
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part6
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1501, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1500
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part7
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1801, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1800
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part8
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2101, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2100
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part9
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2401, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2400
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Scrubs, 300 Comment part10
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN user0 = 'SIMM' AND action = 'INT' AND result = 'SRCH' THEN '8X'
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'TU CPE%' THEN '81'  
 		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'Innovis RPC%' THEN '81'  
		 WHEN user0 = 'Fusion' AND action = 'SEND' AND result = 'SEND' AND CONVERT(VARCHAR(20), n.comment) LIKE 'LexisNexis Deceased%' THEN '8X'  
		 WHEN user0 = 'WEBRECON' AND action = 'SEND' AND result = '+++++' THEN '8Y'  
		 WHEN user0 = 'CBC' AND action = 'BKY' AND result = 'SEND' THEN '8W'
		 WHEN user0 = 'CBC' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'TLO' AND action = 'DEC' AND result = 'Send' THEN '8X'
		 WHEN user0 = 'SCRA' AND action = 'RQST' AND result = 'Send' THEN '8B'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2701, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
AND user0 IN ('SIMM', 'CBC', 'FUSION', 'DECDSVC', 'WEBRECON', 'SCRA', 'TLO')
AND result NOT IN ('CHNG', 'NF', 'IF')
AND action NOT IN ('RTN', 'CO', '+++++', 'REC')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2700
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


--#endregion

UNION ALL

--#region Record 425 Phone Calls - Outbound
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ') <> ''
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part2
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 301, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 300
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part3
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 601, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 600
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part4
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 901, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 900
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part5
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1201, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1200
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part6
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1501, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1500
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part7
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1801, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1800
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part8
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2101, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2100
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part9
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2401, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2400
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Outbound, 300 Comment Part10
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN action = 'TR' AND result IN ('LV', 'LM') THEN '8E'
		 WHEN action = 'TR' AND result IN ('TT') THEN '8F'
		 WHEN action = 'TR' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '95'
		 WHEN action = 'TR' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '99'
		 WHEN action = 'TR' AND result IN ('PAY', 'PP') THEN '9E'
		 WHEN action = 'TR' AND result IN ('RP') THEN '9I'
		 WHEN action = 'TR' AND result IN ('OI', 'WN') THEN '9O'
		 WHEN action = 'TR' AND result IN ('LB', 'TS') THEN '8M'		 
		  WHEN action = 'TR' AND result IN ('TW') THEN '94'
		 
		 WHEN action = 'TE' AND result IN ('TT') THEN '8H'
		 WHEN action = 'TE' AND result IN ('LV', 'LM') THEN '8L'
		 WHEN action = 'TE' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '96'
		 WHEN action = 'TE' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9B'
		 WHEN action = 'TE' AND result IN ('PAY', 'PP') THEN '9F'
		 WHEN action = 'TE' AND result IN ('RP') THEN '9J'
		 WHEN action = 'TE' AND result IN ('OI', 'WN') THEN '9P'
		 WHEN action = 'TE' AND result IN ('LB', 'TW', 'TS') THEN '8Q'
	 
		 WHEN action = 'TC' AND result IN ('LV', 'LM') THEN '8N'
		 WHEN action = 'TC' AND result IN ('TT') THEN '8O'
		 WHEN action = 'TC' AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '97'
		 WHEN action = 'TC' AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9C'
		 WHEN action = 'TC' AND result IN ('PAY', 'PP') THEN '9G'
		 WHEN action = 'TC' AND result IN ('RP') THEN '9K'
		 WHEN action = 'TC' AND result IN ('OI', 'WN') THEN '9Q'
		 WHEN action = 'TC' AND result IN ('LB', 'TW', 'TS') THEN '8P'
		 WHEN action = 'TC' AND result IN ('TS') THEN '8P'
		 
		 WHEN action IN ('TO', '3P') AND result IN ('TT') THEN '92'
		 WHEN action IN ('TO', '3P') AND result IN ('AM', 'NA', '99', 'AMNM', 'TD', 'DA', 'DP') THEN '98'
		 WHEN action IN ('TO', '3P') AND result IN ('DHU', 'DH', 'HU', '3PHU') THEN '9D'
		 WHEN action IN ('TO', '3P') AND result IN ('PAY', 'PP') THEN '9H'
		 WHEN action IN ('TO', '3P') AND result IN ('RP') THEN '9L'
		 WHEN action IN ('TO', '3P') AND result IN ('LV', 'LM') THEN '9M'
		 WHEN action IN ('TO', '3P') AND result IN ('OI', 'WN') THEN '9N'
		 WHEN action IN ('TO', '3P') AND result IN ('LB', 'TS') THEN '94'
 		 WHEN action IN ('TO', '3P') AND result IN ('TW') THEN '92'
		 WHEN action = 'TA' THEN '93'
		 WHEN action = 'AT' THEN '8J'
		 WHEN action = 'TN' THEN '91'
		 WHEN n.action IN ('COURT') THEN '8C'
		 WHEN n.result IN ('CORT1', 'CORT2', 'CORT3', 'COURT') THEN '8C'
 		 ELSE '91'
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2701, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2700
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('TR', 'TO', 'TC', 'TE', 'TN', 'TI', 'DIAL', 'CO', 'CE', 'COURT', 'PSUPP', '3P', 'AT') AND user0 NOT IN ('EXG')
AND result IN ('co', 'lb', 'dhu', 'dh', 'hu', '3PHU', 'am', 'AMNM', 'na', 'pp', 'tt', 'rp', 'oi', 'wn', 'lv', 'lm', 'pay', 'tw', '99', 'CORT1', 'CORT2', 'CORT3', 'DA', 'DP', 'TD', 'TS')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
--#endregion


UNION ALL

--#region Record 425 Phone Calls - Inbound
--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part1
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ') <> ''
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part2
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 301, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 300
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part3
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 601, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 600
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part4
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 901, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 900
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part5
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1201, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1200
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part6
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1501, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1500
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part7
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1801, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1800
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part8
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2101, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2100
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part9
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2401, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2400
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Phone Calls Inbound added 12/2/2019, 300 Comment Part10
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
	CASE WHEN result = 'CO' THEN '8B'
		 WHEN result IN  ('TW', 'ITW', 'WN', 'TO', '3PHU') THEN '8I' 
		 WHEN result IN ('PAY', 'PP') THEN '9R' 
		 WHEN result IN ('ITT', 'TT', 'RP') THEN '9R'
		 WHEN result = 'ATTY' THEN '8J'
		 WHEN result IN ('HU', 'DHU') THEN '8K'
		 --ELSE result
	END AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2701, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2700
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('IC', 'DT', 'DP') AND user0 NOT IN ('EXG')
AND result IN ('co', 'TW', 'ITW', 'PAY', 'PP', 'ITT', 'TT', 'RP', 'ATTY', 'WN', 'TO', '3PHU', 'HU', 'DHU')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

--#endregion
UNION ALL

--#region Record 425 Comments Only
--Record 425 Comments Only added 12/12/2019, 300 Comment Part1
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ') <> ''
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part2
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 301, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 300
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part3
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 601, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 600
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part4
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 901, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 900
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part5
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1201, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1200
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part6
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1501, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1500
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part7
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1801, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1800
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part8
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2101, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2100
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part9
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2401, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2400
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part10
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2701, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2700
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))

--#endregion

UNION ALL

--#region Record 425 Comments Only
--Record 425 Comments Only added 12/12/2019, 300 Comment Part1
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND replace(replace(replace(convert(varchar(300),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ') <> ''
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part2
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 301, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 300
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part3
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 601, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 600
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part4
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 901, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 900
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part5
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1201, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1200
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part6
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1501, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1500
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part7
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 1801, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 1800
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part8
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2101, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2100
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part9
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2401, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2400
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


UNION ALL

--Record 425 Comments Only added 12/12/2019, 300 Comment Part10
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
'8B' AS AgyActCode, 
CONVERT(VARCHAR(8), n.created, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), n.created, 8), ':', '') AS AgyActTime, 
'SIMM    ' AS ThirdPartyID,
'SYSTEM' AS AgyCollID, 
SUBSTRING(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 2701, 300)  AS AgyHistoryTxt
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
INNER JOIN notes n WITH (NOLOCK) on m.number = n.number
WHERE n.created BETWEEN @startDate AND @endDate 
AND LEN(replace(replace(replace(convert(varchar(3000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' ')) > 2700
AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
and [action] in ('CO') AND user0 IN (SELECT LoginName FROM users WITH (NOLOCK) WHERE ACTIVE = 1)
AND result IN ('CO')
AND (closed IS NULL OR closed BETWEEN @startDate AND DATEADD(dd, 1, @endDate))
AND m.account IN (
SELECT m.account
	FROM master m WITH (NOLOCK) 
	WHERE closed IS NOT NULL
	AND customer IN (Select customerid from fact where customgroupid = 382)
	AND DATEPART(hh, closed) BETWEEN 00 AND 08 AND DATEPART(mm, m.closed) BETWEEN 00 AND 59 AND DATEPART(ss, m.closed) >= 01
	AND CAST(m.closed AS DATE) = CAST(DATEADD(dd, 1, @endDate) AS DATE))


--#endregion

--UNION ALL

--#region Letters Sent
----Record 425 Letter Sent
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'8A' AS AgyActCode, 
--CONVERT(VARCHAR(8), lr.DateProcessed, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), lr.DateProcessed, 8), ':', '') AS AgyActTime, 
--'SIMM    ' AS ThirdPartyID,
--'SYSTEM' AS AgyCollID, lr.LetterCode + ', ' + l.Description + ' Sent to: ' + d.name  AS AgyHistoryTxt
--FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
--INNER JOIN LetterRequest lr WITH (NOLOCK) on m.number = lr.AccountID AND d.DebtorID = lr.RecipientDebtorID
--INNER JOIN Letter l WITH (NOLOCK) ON lr.LetterCode = l.code
--WHERE lr.DateProcessed BETWEEN @startDate AND @endDate 
--AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

----#endregion
--UNION ALL

----#region POC Sent
----Record 425 Sent POC on Deceased account
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'8T' AS AgyActCode, 
--CONVERT(VARCHAR(8), m.userdate2, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), m.userdate2, 8), ':', '') AS AgyActTime, 
--'SIMM    ' AS ThirdPartyID,
--'SYSTEM' AS AgyCollID, 'POC request sent: for deceased party'  AS AgyHistoryTxtfrom 
--FROM master m WITH (NOLOCK) --INNER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number INNER JOIN Deceased d WITH (NOLOCK) ON d2.DebtorID = d.DebtorID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND (status IN ('CLM') OR (SELECT TOP 1 oldstatus FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus IN ('CLM') AND DateChanged BETWEEN @startDate AND DATEADD(dd, 5, @endDate)) IN ('CLM'))
--AND m.userdate2 BETWEEN @startDate AND @endDate

----#endregion
--UNION ALL

--#region Accounts PIF
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '425' AS TransCode, CONVERT(VARCHAR(8), GETDATE(), 112) AS TransDate,
--	'8U' AS AgyActCode, 
--CONVERT(VARCHAR(8), m.closed, 112) AS AgyActDate, REPLACE(CONVERT(VARCHAR(10), m.closed, 8), ':', '') AS AgyActTime, 
--'SIMM    ' AS ThirdPartyID,
--'SYSTEM' AS AgyCollID, 'Account Paid in Full'  AS AgyHistoryTxtfrom 
--from master m WITH (NOLOCK) LEFT OUTER JOIN deceased de ON m.number = de.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND (m.closed BETWEEN @startDate AND @endDate OR m.returned BETWEEN @startDate AND @endDate)
--AND status = 'PIF' AND CONVERT(VARCHAR(8), DATEADD(dd, 20, m.lastpaid), 112) BETWEEN @startDate AND @endDate

--#endregion


--#region Payments
----Record 216 Paid Client
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '216' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
--REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt, 'SIMM    ' AS ThirdPartyID, '646' AS InputSRCcode, p.UID
--FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
--AND batchtype = 'PC' AND invoiced IS NOT NULL
--WHERE invoiced BETWEEN @startDate AND @endDate
--AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

----Record 300-2 Paid Us
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
--REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '00' AS NewDebits, '2' AS CatCode, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
--'' AS BatchInfo, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'C' ELSE '' END AS Affect, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
--FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
--AND batchtype = 'PU' AND invoiced IS NOT NULL
--WHERE invoiced BETWEEN @startDate AND @endDate
--AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

----Record 217 Paid Client Reversal
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '217' AS TransCode, ISNULL((SELECT top 1 CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID), (CONVERT(VARCHAR(8), p.datepaid, 112))) AS TransDate,
--REPLACE(CONVERT(VARCHAR(14), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt, 'SIMM    ' AS ThirdPartyID, '646' AS InputSRCcode, p.UID
--FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
--AND batchtype = 'PCR' AND invoiced IS NOT NULL
--WHERE invoiced BETWEEN @startDate AND @endDate
--AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

----Record 300-1 Paid Us Reversal (Non-NSF) aka correction.
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, (SELECT top 1 CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
--REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '1' AS NewDebits, '1' AS CatCode, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
--'' AS BatchInfo, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'C' ELSE '' END AS Affect, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
--FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
--AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 1
--WHERE invoiced BETWEEN @startDate AND @endDate
--AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

----Record 700 Paid Us Reversal (NSF)
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '700' AS TransCode, (SELECT top 1 CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
--REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
--'' AS BatchInfo, '' AS OrigTrans, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
--FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
--AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 0
--WHERE invoiced BETWEEN @startDate AND @endDate
--AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)

--#endregion

--#region Record 400 Status Changes
----Record 400 Status Changes - ATTORNEY
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), da.DateCreated, 112) AS TransDate,
--'ATTORNEY' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), GETDATE(), 112) + ' Attorney ' + da.Name + ', of ' + da.Firm + 
--' Phone: ' + da.Phone + ' or Fax ' + da.fax + CASE WHEN da.email <> '' THEN ' or Email: ' + da.Email ELSE ''  END + ' or Mail: ' + da.Addr1 + ' ' + da.Addr2 + ' ' + da.city + ', ' + da.State + 
--' ' + da.Zipcode AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON m.number = da.AccountID 
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND da.DateCreated BETWEEN @startDate AND @endDate AND m.status NOT IN ('DEC', 'BKY', 'BK7', 'B11', 'B12', 'B13', 'UBK')
--AND m.closed IS NULL

--UNION ALL

----Record 400 Status Changes - Bankruptcy
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), m.closed, 112) AS TransDate,
--CASE WHEN b.Chapter = '11' THEN 'BKCHP11' When b.Chapter =  '12' THEN 'BKCHP12' When b.Chapter = '13' THEN 'BKCHP13' When b.Chapter = '7' THEN 'BKCHP7'  END AS StatusCode, 
--'Confirmed - Chapter '  + CONVERT(VARCHAR(3), b.Chapter) + ', ' + b.CaseNumber + ', ' + d.Name + ', ' + d.ssn + ', ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ', ' + b.CourtState + ', ' + CONVERT(VARCHAR(10), b.DateTime341, 101) + ', ' + b.CourtDistrict + ', ' + b.CourtDivision  AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND m.closed BETWEEN @startDate AND @endDate AND m.status IN ('BKY', 'B07', 'B11', 'B12', 'B13')

--UNION ALL

----Record 400 Status Changes - Cease and Desist
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'CEASE' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + m.name + ', ' + m.ssn + 
--CASE WHEN m.status IN ('CAD', 'CND') AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND result = 'VCD' AND created BETWEEN @startDate AND @endDate) THEN 'Verbal' WHEN status IN ('VCD', 'HCD') THEN 'Verbal' ELSE 'Written' END  + ', Requested Cease and Desist'  AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('CND', 'CAD', 'VCD', 'HCD')

--UNION ALL

----12/08/2022 BGM removed restriction to Primary debtor only so the 400 record will send on the Co-if entered.
----Record 400 Status Changes - Debt Management Co.
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'DEBT' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + c.CompanyName AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--	INNER JOIN CCCS c WITH (NOLOCK) ON d.DebtorID = c.DebtorID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DMC')

--UNION ALL

----Record 400 Status Changes - Dispute account DPV Closed
--SELECT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'DISPUTE' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'DSP' THEN 'Debtor is disputing the balance of the account' END AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE 
--m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382) --Production
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DPV')
--AND m.closed BETWEEN @startDate AND @endDate

--UNION ALL

----Record 400 Status Changes - Request Recall Extension after recall 910 received and reopened.  Updated 2/8/2021 to pickup via keeper note
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), n.created, 112) AS TransDate,
--'EXTREQ1' AS StatusCode, 'As of ' + CONVERT(VARCHAR(8), GETDATE(), 112) + ', ' + CONVERT(VARCHAR(150), n.comment) AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND n.created BETWEEN @startDate AND @endDate AND user0 = 'USB' AND action = 'EXT' AND result = 'REQ'
----AND sh.DateChanged BETWEEN @startDate AND @endDate AND (sh.OldStatus IN ('PDC', 'PCC', 'HOT', 'PPA', 'BKN', 'NPC', 'NSF', 'DCC', 'DBD') OR lastpaid > DATEADD(dd, -90, GETDATE()))
----AND (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'recallreason') IN ('T', 'N', 'R')

--UNION ALL


----Record 400 Status Changes - Fraud
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'FRAUD' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'FRD' THEN 'Debtor is stating fraudulent charges made on account or account opened without their knowledge' END AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('FRD')
--AND m.closed BETWEEN @startDate AND @endDate

--UNION ALL

----Record 400 Status Changes - Verbal Bankuptcy
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'UNCNFBK' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + 'Debtor stated during conversation they were filing for bankruptcy' AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('BKY', 'B07', 'B11', 'B12', 'B13') 
--AND m.number NOT IN (SELECT AccountID FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number)
--AND m.closed BETWEEN @startDate AND @endDate


--UNION ALL

----Record 400 Status Changes - Validation of Debt
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '400' AS TransCode, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate,
--'VOD' AS StatusCode, 'Notified on ' + CONVERT(VARCHAR(8), sh.DateChanged, 112) + ', ' + CASE WHEN m.status = 'DSP' THEN 'Debtor requesting validation of debt for duration of account life' ELSE '' END AS StatusText
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DSP')

----Custom Data Segment - DC1 - send on closed accts on normal biz and on PCM status accounts in deceased stream
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'DC1' AS CDSID, CONVERT(VARCHAR(8), COALESCE(d2.TransmittedDate, GETDATE()), 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, d.FirstName AS DecFirstName, d.middleName AS DecMiddleName, d.LastName AS DecLastName, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID,
----ISNULL(CONVERT(VARCHAR(8), d2.DOD, 112), '') --No DOD sent in DC1
--'' AS DOD, 
----CASE WHEN d2.dod IS NULL THEN 'Phone' ELSE 'OTHR' END --No Notification Source
--'' AS NotifySrc, 
----CASE WHEN d2.dod IS NULL THEN '' ELSE 'PUBLREC' END --No Confirmation Source
--'' AS ConfSrc, 
--'A' AS ContRelation, CASE WHEN d3.seq = 1 THEN 'Y' ELSE 'N' END AS SurvCustomers,
--'' AS EstateExists, 
----ISNULL(D2.CourtState, '') --No Geographic State Needed
--'' AS GeoState, ISNULL(CONVERT(VARCHAR(8), m.userdate2, 112), '') AS POCDate, '+' AS DelqSign, REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' AS POCAmt, '' AS Notes1, '' AS Notes2, '' AS Notes3, '' AS ConfirmDate, '' AS NotifyDate, '' AS Filler
--from master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
--LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d3.Number AND d3.seq = 1
--LEFT OUTER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND ((status = 'DEC' AND closed BETWEEN @startDate AND @endDate ) OR 
--((status IN ('CLM') OR ((SELECT TOP 1 oldstatus FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus IN ('CLM') AND DateChanged BETWEEN @startDate AND @endDate) IN ('CLM'))))
--AND m.userdate2 BETWEEN @startDate AND @endDate) AND d.isBusiness <> 1
--#endregion

--UNION ALL

--#region CDS DC2
------Custom Data Segment - DC2 - send on closed accts on normal biz and on PCM status accounts in deceased stream
----SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'DC2' AS CDSID, CONVERT(VARCHAR(8), COALESCE(d2.TransmittedDate, GETDATE()), 112) AS TransDate, 'Y' AS ProcessFlag,
----'A' AS FunctionCode, d.FirstName AS DecFirstName, d.middleName AS DecMiddleName, d.LastName AS DecLastName, CONVERT(VARCHAR(25), d.DebtorMemo) AS ContactID,
------ISNULL(CONVERT(VARCHAR(8), d2.DOD, 112), '') --No DOD sent in DC12
----'' AS DOD, 
------CASE WHEN d2.dod IS NULL THEN 'Phone' ELSE 'OTHR' END --No Notification Source
----'' AS NotifySrc, 
------CASE WHEN d2.dod IS NULL THEN '' ELSE 'PUBLREC' END --No Confirmation Source
----'' AS ConfSrc, 
----'B' AS ContRelation, CASE WHEN d3.seq = 0 THEN 'Y' ELSE 'N' END AS SurvCustomers,
----'' AS EstateExists, 
------ISNULL(D2.CourtState, '') --No Geographic State Needed
----'' AS GeoState, 
----ISNULL(CONVERT(VARCHAR(8), m.userdate2, 112), '') AS POCDate, '+' AS DelqSign, REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' AS POCAmt, '' AS Notes1, '' AS Notes2, '' AS Notes3, '' AS ConfirmDate, '' AS NotifyDate, '' AS Filler
----from master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 1
----LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d3.Number AND d3.seq = 0
----LEFT OUTER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
----WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
----AND ((status = 'DEC' AND closed BETWEEN @startDate AND @endDate ) OR 
----((status in ('CLM') OR ((SELECT TOP 1 oldstatus FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND OldStatus IN ('clm') AND DateChanged BETWEEN @startDate AND @endDate) IN ('clm'))))
----AND m.userdate2 BETWEEN @startDate AND @endDate) AND d.isBusiness <> 1
----#endregion


----#region AGS PDC
----Custom Data Segment - AGS PDC, Start Date, 1st installment date
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGS' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, 'SIMM      ' AS AgencyId,


----BALANCE AT SETTLEMENT added payhistory lookup for payments made prior to running of Trans Data File to match SIF Log
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + ABS(m.paid)), '.', '')
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') 
--	ELSE REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') END + '0000' 
--	AS BalAtSettle, 

----SETTLEMENT OFFERED
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- ), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND active = 1 AND printed = 0) END AS SettlementOffered, 

----SETTLEMENT IN LIMIT
--CASE WHEN m.STATUS = 'SIF' AND ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
--WHEN  ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 

----AGENCY MANAGER APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate ORDER BY deposit DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
-- WHERE d.code = p.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 

----SETTLEMENT NEEDS USB APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate  ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate ORDER BY deposit DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number AND created BETWEEN @startdate AND @enddate AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

----SETTLEMENT START DATE
--(select TOP 1 CONVERT(VARCHAR(8), entered, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate ORDER BY deposit ASC) AS SettlementStartDate, 

----NUMBER OF PAYMENTS
----(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate)) AS NumofPayments, 
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))) AS NumofPayments, 

----PROJECTED END DATE
--dbo.fnGetEndDatePDCUSB(p.number, @startDate, @endDate) AS ProjEndDate,


----DATE SETTLEMENT TAKEN
--CONVERT(VARCHAR(8), datecreated, 112) AS DateSettlementTaken,

----SETTLEMNT PERCENT OF BALANCE PDC
--LEFT(CONVERT(VARCHAR(14), 
--REPLACE( 
--ROUND( 
--CAST( 
--(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM pdc WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND active = 1 AND printed = 0) END) 
-- AS DECIMAL (9,3))
-- / 
--CAST(
--(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
--	ELSE m.current0 END) 
--AS DECIMAL (9,3))
--, 4)  * 100
--, '.', '')
--)
--, 8)
--AS SettlementPercOfBalance,

----AMOUNT FORGIVEN
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - ABS(m.paid)), '.', '') + '0000'
--	ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 dbo.NetOriginalRnd(m.number) - (SUM(amount) + ABS(m.paid)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) AND ACTIVE = 1 AND printed = 0)), '.', '') + '0000' END AS AmountForgiven, 

----SETTLEMENT NEW, UPDATE, PRO
--	--SETTLNEW - New Settlement 
--			-- Created date in date range, and does not exist in history table
--	--SETTLPRO - Settlement Promise Data Update.  Promise date or amount is being changed, 
--	-- but total settlement amount and expiration date will remain the same.
--			--Created date in date range, and exists in history table but Settlement amount and Projected End Date are same.
--	--SETTLUPD - Updated Settlement.  Promise end date or SIF offer amount is being changed
	
----Created date in date range and exists in history table and Settlement amount or Projected End Date are different.
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePDCUSB(p.number, @startDate, @endDate)
--		= (SELECT TOP 1  projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM pdc WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND active = 1 AND printed = 0) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,

----SSN VERIFIED
--CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
----ADDRESS VERIFIED
--CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE Number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
--'Settlement Offered' AS SettlementNotes,
----INSTALLMENT INFORMATION
--'+' AS DelqSign,

--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC), '') AS Installment1Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC), 0) AS Installment1Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (p.Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (p.Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment2Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment2Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment3Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))   ORDER BY deposit ASC)), '0') AS Installment3Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment4Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment4Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment5Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment5Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment6Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment6Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment7Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment7Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment8Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment8Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment9Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment9Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment10Date,
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment10Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment11Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment11Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startdate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment12Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment12Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment13Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment13Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment14Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment14Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment15Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment15Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment16Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startdate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment16Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment17Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment17Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment18Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment18Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startdate  AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment19Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment19Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment20Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment20Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment21Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment21Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment22Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment22Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment23Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment23Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '') AS Installment24Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY deposit ASC)), '0') AS Installment24Amt,
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.entered BETWEEN @startDate AND @endDate
--AND p.PromiseMode IN (6,7) 
--AND p.onhold IS NULL
--AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))

----#endregion

--UNION ALL

----#region AGS PCC
----Custom Data Segment - AGS PCC -ACCOUNT GENERAL INFORMATION
--SELECT DISTINCT   id2 AS LocationCode, m.account AS Acctnumber, 'AGS' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, 'SIMM      ' AS AgencyId, 
----BALANCE AT SETTLEMENT
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + ABS(m.paid)), '.', '')
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') 
--	ELSE REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') END + '0000' 
--	AS BalAtSettle,

----SETTLEMENT OFFERED
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000' ELSE 
--(select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
----ABS(m.paid)
--), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) AND IsActive = 1 AND Printed IN ('0', 'N')) END AS SettlementOffered, 


----SETTLEMENT IN LIMIT
--CASE WHEN m.STATUS = 'SIF' AND ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
--WHEN  ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate )) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 
----AGENCY MANAGER APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) ORDER BY DepositDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) ORDER BY DepositDate DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
-- WHERE d.code = m.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 
----SETTLEMENT NEEDS USB APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) ORDER BY DepositDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) ORDER BY DepositDate DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number AND created BETWEEN @startdate AND @enddate AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

----SETTLEMENT START DATE
--(select TOP 1 CONVERT(VARCHAR(8), DateEntered, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) ORDER BY DepositDate ASC) AS SettlementStartDate,

----NUMBER OF PAYMENTS
----(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate )) AS NumofPayments, 
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) ) AS NumofPayments, 

----PROJECTED END DATE
--dbo.fnGetEndDatePCCUSB(p.number, @startDate, @endDate) AS ProjEndDate,

----DATE SETTLEMENT TAKEN
--CONVERT(VARCHAR(8), datecreated, 112) AS DateSettlementTaken,

----SETTLEMNT PERCENT OF BALANCE PCC
--LEFT(CONVERT(VARCHAR(14), 
--REPLACE( 
--ROUND( 
--CAST( 
--(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM DebtorCreditCards WITH (NOLOCK) WHERE m.number = Number AND DateCreated BETWEEN @startDate AND @endDate AND IsActive = 1 AND Printed IN ('0', 'N')) END) 
-- AS DECIMAL (9,3))
-- / 
--CAST(
--(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
--	ELSE m.current0 END) 
--AS DECIMAL (9,3))
--, 4)  * 100
--, '.', '')
--)
--, 8)
-- AS SettlementPercOfBalance, 

----AMOUNT FORGIVEN
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - ABS(m.paid)), '.', '') + '0000'
----WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - 
----	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') 
--ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 dbo.NetOriginalRnd(m.number) - (SUM(amount) + ABS(m.paid)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate ) AND IsActive = 1 AND Printed IN ('0', 'N'))), '.', '') + '0000' END AS AmountForgiven, 

----SETTLEMENT NEW, UPDATE, PRO
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePCCUSB(p.number, @startDate, @endDate)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.DebtorCreditCards WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND IsActive = 1 AND Printed = 'N') END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,

----SSN VERIFIED
--CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
----ADDRESS VERIFIED
--CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE Number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
--'Settlement Offered' AS SettlementNotes,
----INSTALLMENT INFORMATION
--'+' AS DelqSign,

----Set first installment 2 days into future if due date is same date as file header date
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC), '') AS Installment1Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC), 0) AS Installment1Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment2Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment2Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment3Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment3Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment4Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment4Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment5Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment5Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment6Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment6Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment7Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment7Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment8Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment8Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment9Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment9Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment10Date,
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment10Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment11Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment11Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment12Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment12Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment13Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment13Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment14Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment14Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment15Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment15Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment16Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment16Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment17Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment17Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment18Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment18Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment19Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment19Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment20Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment20Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment21Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment21Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment22Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment22Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment23Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment23Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment24Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment24Amt,
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.DateEntered BETWEEN @startDate AND @endDate
--AND p.PromiseMode IN (6,7) AND p.OnHoldDate IS NULL
--AND (p.IsActive = 1 OR (p.IsActive = 0 AND m.status = 'sif'))

----#endregion
--UNION ALL

--#region AGS PPA
----Custom Data Segment - AGS PPA
----Updated 11/12/2019
--SELECT DISTINCT   
--id2 AS LocationCode, 
--m.account AS Acctnumber, 
--'AGS' AS CDSID, 
--CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 
--'Y' AS ProcessFlag,
--'A' AS FunctionCode, 
--'SIMM      ' AS AgencyId, 
----BALANCE AT SETTLEMENT
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + ABS(m.paid)), '.', '')
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') 
--	ELSE REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') END + '0000' 
--	AS BalAtSettle,

----SETTLEMENT OFFERED
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000' ELSE 
--(select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(amount) + ISNULL((SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
--), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) AND active = 1) END AS SettlementOffered, 

----SETTLEMENT IN LIMIT
--CASE WHEN m.STATUS = 'SIF' AND ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
--WHEN ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100) < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate )) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 
----AGENCY MANAGER APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) AND active = 1 ORDER BY DueDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) AND active = 1 ORDER BY DueDate DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
-- WHERE d.code = m.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 
----SETTLEMENT NEEDS USB APPROVAL
--CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) ORDER BY DueDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) ORDER BY DueDate DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number AND created BETWEEN @startdate AND @enddate AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

----SETTLEMENT START DATE
--(select TOP 1 CONVERT(VARCHAR(8), Entered, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) ORDER BY DueDate ASC) AS SettlementStartDate, 

----NUMBER OF PAYMENTS
----(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) ) AS NumofPayments, 
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))) AS NumofPayments, 

----PROJECTED END DATE
--dbo.fnGetEndDatePromisesUSB(m.number, @startDate, @endDate) AS ProjEndDate, 


----DATE SETTLEMENT TAKEN
--CONVERT(VARCHAR(8), datecreated, 112) AS DateSettlementTaken,

----SETTLEMNT PERCENT OF BALANCE PPA
--LEFT(CONVERT(VARCHAR(14), 
--REPLACE( 
--ROUND( 
--CAST( 
--(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM Promises WITH (NOLOCK) WHERE m.number = AcctID AND DateCreated BETWEEN @startDate AND @endDate AND active = 1) END) 
-- AS DECIMAL (9,3))
-- / 
--CAST(
--(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
--	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
--	ELSE m.current0 END) 
--AS DECIMAL (9,3))
--, 4)  * 100
--, '.', '')
--)
--, 8)
--AS SettlementPercOfBalance, 

----AMOUNT FORGIVEN
--CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - ABS(m.paid)), '.', '') + '0000'
----WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - 
----	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') + '0000'
--ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 dbo.NetOriginalRnd(m.number) - (SUM(amount) + ABS(m.paid)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (DateCreated BETWEEN @startDate AND @endDate ) AND active = 1)), '.', '') + '0000' END AS AmountForgiven, 

----SETTLEMENT NEW, UPDATE, PRO
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate	) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePromisesUSB(m.number, @startDate, @endDate)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.Promises WITH (NOLOCK) WHERE m.number = AcctID AND DateCreated BETWEEN @startDate AND @endDate AND Active = 1) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,

----SSN VERIFIED
--CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
----ADDRESS VERIFIED
--CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
--'Settlement Offered' AS SettlementNotes,
----INSTALLMENT INFORMATION
--'+' AS DelqSign,

--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY DueDate ASC), '') AS Installment1Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY DueDate ASC), 0) AS Installment1Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment2Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment2Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment3Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment3Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment4Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment4Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment5Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment5Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment6Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment6Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment7Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment7Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment8Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment8Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment9Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment9Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment10Date,
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment10Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment11Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment11Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment12Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment12Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment13Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment13Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment14Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment14Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment15Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment15Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment16Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment16Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment17Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment17Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment18Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment18Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment19Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment19Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment20Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment20Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment21Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment21Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment22Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment22Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment23Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment23Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment24Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment24Amt,
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN Promises p WITH (NOLOCK) ON m.number = p.acctid
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.Entered BETWEEN @startDate AND @endDate
--AND p.PromiseMode IN (6,7) 
--AND (p.Suspended = 0 OR p.Suspended IS NULL)
--AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))

----#endregion

----#region AGT PDC
----Custom Data Segment - AGT PDC
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGT' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode,

--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePDCUSB(p.number, @startDate, @endDate)
--		= (SELECT TOP 1  projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM pdc WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND active = 1 AND printed = 0) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,
 
--'+' AS DelqSign,
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 24 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment25Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 24 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment25Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 25 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment26Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 25 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment26Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 26 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment27Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 26 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment27Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 27 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment28Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 27 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment28Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 28 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment29Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 28 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment29Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 29 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment30Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 29 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment30Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 30 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment31Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 30 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment31Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 31 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment32Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 31 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment32Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 32 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment33Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 32 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment33Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 33 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment34Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 33 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment34Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 34 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment35Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 34 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment35Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 35 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment36Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 35 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment36Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 36 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment37Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 36 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment37Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 37 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment38Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 37 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment38Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 38 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment39Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 38 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment39Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 39 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment40Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 39 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment40Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 40 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment41Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 40 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment41Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 41 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment42Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 41 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment42Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 42 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment43Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 42 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment43Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 43 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment44Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 43 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment44Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 44 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment45Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 44 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment45Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 45 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment46Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 45 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment46Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 46 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment47Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 46 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment47Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 47 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment48Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 47 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment48Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 48 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment49Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 48 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment49Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 49 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment50Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 49 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment50Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 50 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment51Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 50 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment51Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 51 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment52Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 51 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment52Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 52 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment53Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 52 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment53Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 53 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment54Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 53 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment54Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 54 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment55Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 54 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment55Amt, 
--ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 55 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '') AS Installment56Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  AND uid NOT IN (SELECT TOP 55 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND onhold IS NULL AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY deposit ASC)), '0') AS Installment56Amt, 
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.entered BETWEEN @startDate AND @endDate
--AND (SELECT COUNT(*) FROM pdc WITH (NOLOCK) WHERE number = m.number AND p.entered BETWEEN @startDate AND @endDate) >= 25
--AND p.PromiseMode IN (6,7) AND p.onhold IS NULL

----#endregion
--UNION ALL

--#region AGT PCC
----Custom Data Segment - AGT PCC
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGT' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, 

----SETTLEMENT NEW, UPDATE, PRO
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePCCUSB(p.number, @startDate, @endDate)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.DebtorCreditCards WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND IsActive = 1 AND Printed = 'N') END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,

--'+' AS DelqSign,
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 24 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment25Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 24 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment25Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 25 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment26Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 25 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment26Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 26 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment27Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 26 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment27Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 27 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment28Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 27 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment28Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 28 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment29Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 28 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment29Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 29 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment30Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 29 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment30Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 30 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment31Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 30 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment31Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 31 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment32Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 31 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment32Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 32 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment33Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 32 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment33Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 33 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment34Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 33 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment34Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 34 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment35Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 34 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment35Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 35 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment36Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 35 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment36Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 36 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment37Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 36 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment37Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 37 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment38Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 37 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment38Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 38 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment39Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 38 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment39Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 39 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment40Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 39 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment40Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 40 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment41Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 40 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment41Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 41 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment42Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 41 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment42Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 42 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment43Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 42 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment43Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 43 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment44Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 43 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment44Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 44 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment45Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 44 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment45Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 45 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment46Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 45 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment46Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 46 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment47Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 46 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment47Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 47 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment48Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 47 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment48Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 48 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment49Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 48 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment49Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 49 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment50Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 49 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment50Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 50 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment51Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 50 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment51Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 51 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment52Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 51 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment52Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 52 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment53Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 52 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment53Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 53 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment54Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 53 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment54Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 54 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment55Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 54 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment55Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 55 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment56Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 55 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment56Amt, 
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.DateEntered BETWEEN @startDate AND @endDate
--AND (SELECT COUNT(*) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = m.number AND p.DateEntered BETWEEN @startDate AND @endDate) >= 25
--AND p.PromiseMode IN (6,7) AND p.OnHoldDate IS NULL

----#endregion
--UNION ALL

----#region AGT PPA
----Custom Data Segment - AGT for Promises
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGT' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, 

--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate	) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePromisesUSB(m.number, @startDate, @endDate)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.Promises WITH (NOLOCK) WHERE m.number = AcctID AND DateCreated BETWEEN @startDate AND @endDate AND Active = 1) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,

--'+' AS DelqSign,
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 24 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment25Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 24 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment25Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 25 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment26Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 25 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment26Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 26 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment27Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 26 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment27Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 27 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment28Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 27 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment28Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 28 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment29Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 28 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment29Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 29 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment30Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 29 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment30Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 30 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment31Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 30 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment31Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 31 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment32Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 31 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment32Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 32 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment33Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 32 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment33Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 33 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment34Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 33 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment34Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 34 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment35Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 34 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment35Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 35 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment36Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 35 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment36Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 36 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment37Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 36 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment37Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 37 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment38Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 37 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment38Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 38 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment39Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 38 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment39Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 39 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment40Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 39 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment40Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 40 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment41Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 40 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment41Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 41 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment42Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 41 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment42Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 42 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment43Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 42 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment43Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 43 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment44Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 43 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment44Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 44 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment45Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 44 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment45Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 45 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment46Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 45 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment46Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 46 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment47Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 46 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment47Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 47 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment48Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 47 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment48Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 48 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment49Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 48 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment49Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 49 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment50Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 49 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment50Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 50 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment51Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 50 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment51Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 51 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment52Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 51 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment52Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 52 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment53Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 52 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment53Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 53 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment54Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 53 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment54Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 54 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment55Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 54 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment55Amt, 
--ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, @startDate, @endDate) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 55 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment56Date, 
--ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 55 ID  FROM Promises WITH (NOLOCK) WHERE number = p.acctid AND Entered BETWEEN @startDate AND @endDate AND PromiseMode IN (6,7) 
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment56Amt, 
--'' AS Filler
--from master m WITH (NOLOCK) INNER JOIN promises p WITH (NOLOCK) ON m.number = p.acctid	
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND p.Entered BETWEEN @startDate AND @endDate
--AND p.PromiseMode IN (6,7) 
--AND (SELECT COUNT(*) FROM Promises WITH (NOLOCK) WHERE AcctID = m.number AND p.Entered BETWEEN @startDate AND @endDate) >= 25
--AND (p.Suspended = 0 OR p.Suspended IS NULL)
--AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))

--#endregion

--Custom Data Segment - BCN
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'BCN' AS CDSID, CONVERT(VARCHAR(8), m.closed, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, ISNULL(b.CaseNumber, '') AS CaseNumber, ISNULL(b.Chapter, '') AS Chapter, ISNULL(CONVERT(VARCHAR(8), b.DateFiled, 112), '') AS FilingDate, ISNULL(d.Name, '') AS FilerName1, ISNULL(d2.Name, '') AS FilerName2,
--'U' AS ProSe, 'U' AS MaritalStatus, CASE WHEN b.BankruptcyID IS NULL THEN 'N' ELSE 'U' END AS BKConfirmed, '' AS Filler
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
--LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.Number AND d2.seq = 1
--LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON m.number  = b.AccountID 
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND m.closed BETWEEN @startDate AND @endDate AND m.status IN ('BKY', 'B07', 'B11', 'B12', 'B13')

----Custom Data Segment - CEA C10 = Verbal D10 = Written
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'CEA' AS CDSID, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, CASE WHEN m.id2 IN ('040101', '040102') THEN 'A10' ELSE 'B10' END AS SystemOfRecord, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS CandDReceived, 
--CASE WHEN status IN ('CAD', 'CND') AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND result = 'VCD' AND created BETWEEN @startDate AND @endDate) THEN 'C10' WHEN status IN ('VCD', 'HCD') THEN 'C10' ELSE 'D10' END AS TypeIndicator, '' AS AnyAll, CASE WHEN m.status = 'HCD' THEN 'SECCH' ELSE 'PRIMCH' END AS ContactRequesting,
--'' AS RescindDate, '' AS P3Name, '' AS CDRecallDate, '' AS Filler
--FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq =0
--LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d.seq = 1
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('CND', 'CAD', 'VCD', 'HCD')

----Custom Data Segment - CDE
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, 'CDE' AS CDSID, CONVERT(VARCHAR(8), n.created, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, m.account AS Acctnumber1, 
--CASE n.result WHEN 'D1' THEN d.firstName + ' ' + d.lastname WHEN 'D2' THEN d2.firstName + ' ' + d2.lastname WHEN 'D3' THEN d3.firstName + ' ' + d3.lastname END AS CustomerName, 
--''  AS PhoneNumber, '' AS BestCallBack, 'See complaint log' AS DetailOfComplaint,
--'See complaint log' AS DesiredResolution, CONVERT(VARCHAR(8), n.created, 112) AS DateCompRecvd, '' AS DateCompResolve, '' AS ComplaintStatus,
--'' AS ErroneousDisclosure, '' AS Filler
--FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
--INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq =0
--LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d2.seq = 1
--LEFT OUTER JOIN Debtors d3 WITH (NOLOCK) ON m.number = d3.number AND d3.seq = 2
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND n.created BETWEEN @startDate AND @endDate AND n.action = 'CP' AND closed IS NULL

----Custom Data Segment - AGV
--SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGV' AS CDSID, CONVERT(VARCHAR(8), sh.DateChanged, 112) AS TransDate, 'Y' AS ProcessFlag,
--'A' AS FunctionCode, 'SIMM      ' AS AgencyID, 'CONS'  AS RequestParty, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.firstname ELSE d.firstName END, d.firstname) AS FirstName, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.lastName ELSE d.lastname END, d.lastname) AS LastName, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.street1 ELSE d.street1 END, d.street1) AS Address1, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.street2 ELSE d.street2 END, d.street2) AS Address2,
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.city ELSE d.city END, d.city) AS City, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.State ELSE d.State END, d.state) AS State, 
--ISNULL(CASE WHEN d.isBusiness = 1 THEN d2.Zipcode ELSE d.Zipcode END, d.Zipcode) AS ZipCode, 
--CONVERT(VARCHAR(8), sh.DateChanged, 112) AS DateVODRequested, '' AS DateVODFiled, '' AS StatementRequestRange,
--'' AS Notes2, '' AS Notes3, '' AS Filler
--FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
--LEFT OUTER JOIN debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d2.seq = 1
--	INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND sh.DateChanged BETWEEN @startDate AND @endDate AND status IN ('DSP')



----Record 215 - Confirm Account Recalled - Appendix L in Manual
----DEC no Case Number = Pending Deceased
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '215' AS TransCode, CONVERT(VARCHAR(8), COALESCE(returned, closed), 112) AS TransDate, 'SIMM    ' AS ThirdPartyID,
--CASE WHEN m.status = 'RCL' THEN ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'RecallReason'), 'R')
--WHEN m.STATUS IN ('BKY', 'B07', 'B11', 'B13', 'B12') AND m.number NOT IN (SELECT AccountID FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number) THEN 'K' 
--WHEN m.STATUS IN ('BKY', 'B07', 'B11', 'B13', 'B12') THEN CASE WHEN (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number AND user0 = 'BankoSvc' AND Action = 'CO' AND created BETWEEN @startDate AND @endDate) = 'BK' THEN '6' ELSE 'B' END
--WHEN status = ('DEC') AND m.customer <> '0001749' THEN 'G'
--WHEN status = ('DIN') THEN '9'
--WHEN status = 'DEC' AND (de.CaseNumber IS NULL OR de.CaseNumber = '') THEN 'J' 
--WHEN status = 'DPV' THEN 'D'
--WHEN m.STATUS IN ('CAD', 'CND') THEN 'L'
--WHEN m.STATUS = 'FRD' THEN 'F'
--WHEN status = 'CCS' THEN 'C' 
--WHEN status IN ('LCP', 'ATY') THEN 'E' 
----Updated to send CEE or DEE for Deceased for RSK accts 02/14/2023
--WHEN status = 'RSK' THEN CASE WHEN customer = '0001749' THEN '9' ELSE '8' END 

--WHEN status = 'AEX' THEN CASE WHEN customer = '0001749' THEN '9' ELSE '8' END 
--WHEN status = 'MIL' THEN CASE WHEN (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number AND user0 = 'SCRA' AND action = 'RTN') = 'ACT' THEN '5' ELSE 'M' END 
--WHEN status = 'OOS' THEN CASE WHEN customer = '0001749' THEN '9' ELSE '8' END 
--WHEN status = 'SIF' THEN 'S'
--WHEN status = 'PIF' THEN '3'
--WHEN status = 'UCV' THEN 'V'
--WHEN status = 'NUR' then 'H'
--ELSE 'N' END AS Reason, 
--'Y' AS RouteConfirm
--from master m WITH (NOLOCK) LEFT OUTER JOIN deceased de ON m.number = de.AccountID
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND (((m.closed BETWEEN @startDate AND @endDate OR m.returned BETWEEN @startDate AND @endDate) AND status NOT IN ('PIF', 'SIF'))
--OR (m.returned BETWEEN @startDate AND @endDate AND status IN ('PIF', 'SIF')))

--UNION ALL

----Record 215 - Account reopened for Recall extension Requested
--SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '215' AS TransCode, CONVERT(VARCHAR(8), n.created, 112) AS TransDate, 'SIMM    ' AS ThirdPartyID,
--SUBSTRING(RIGHT(CONVERT(VARCHAR(100), comment), 2), 1, 1) AS Reason, 
--'Y' AS RouteConfirm
--from master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
--WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 382)
--AND n.created BETWEEN @startDate AND @endDate AND user0 = 'USB' AND action = 'RCL' AND result = 'RSN'
--AND m.closed IS NOT NULL


END
GO
