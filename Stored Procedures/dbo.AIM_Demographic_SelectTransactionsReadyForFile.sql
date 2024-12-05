SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Demographic_SelectTransactionsReadyForFile] 
(
	@agencyId INT,
	@transactionTypeID INT
)
AS
BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT,TransactionTypeID INT)
DECLARE @sqlbatchsize int
SELECT @sqlbatchsize = CAST(CAST(VALUE AS VARCHAR)AS INT) FROM Aim_AppSetting WHERE [Key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @executeSQL VARCHAR(8000)
SET @executeSQL =
'INSERT INTO #AIMExecutingExportTransactions
SELECT TOP ' + cast(@sqlbatchsize as VARCHAR(16)) + ' AccountTransactionID,ForeignTableUniqueId,TransactionTypeID
FROM	AIM_AccountReference AR WITH (NOLOCK)
	JOIN AIM_accounttransaction ATR WITH (NOLOCK) ON ATR.AccountReferenceID = AR.AccountReferenceid
	AND ATR.AgencyID = AR.CurrentlyPlacedAgencyID AND ATR.CreatedDateTime > AR.LastPlacementDate
WHERE	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
	AND transactiontypeid IN (37,38,41,46)
	AND transactionstatustypeid = 1
	AND ATR.AgencyID IS NOT NULL '

EXEC(@executeSQL)
DECLARE @agencyFileFormat VARCHAR(50), @agencyVersion VARCHAR(10);
SELECT @agencyFileFormat = FileFormat FROM AIM_Agency WHERE AgencyId = @agencyId
DECLARE @myyougotclaimsid VARCHAR(20),@AIMYGCID VARCHAR(10)

select @agencyVersion = ISNULL(RTRIM(LTRIM(agencyversion)),'8.3.0') FROM AIM_Agency WITH (NOLOCK) WHERE agencyId = @agencyId;

SELECT  
@myyougotclaimsid = yougotclaimsid
FROM controlfile;

SELECT
@AIMYGCID = AlphaCode
FROM AIM_Agency WHERE AgencyID = @agencyID;

IF(@agencyFileFormat='YGC')
BEGIN
	DECLARE @uniqueDebtorIDS TABLE (DebtorID INT)
	INSERT INTO @uniqueDebtorIDS
	SELECT 
	ah.DebtorID
	FROM AddressHistory ah WITH (NOLOCK) JOIN #AIMExecutingExportTransactions [temp]
	ON ah.ID = [temp].ForeignTableUniqueID AND [temp].TransactionTypeID = 38
	UNION
	SELECT
	pm.DebtorID
	FROM Phones_Master pm WITH (NOLOCK) JOIN #AIMExecutingExportTransactions [temp]
	ON pm.MasterPhoneID = [temp].ForeignTableUniqueID AND [temp].TransactionTypeID = 37

SELECT   DISTINCT         
		'02'						AS [Record Code],
		m.number					AS [FILENO],
		m.account					AS [FORW_FILE],
		null						AS [MASCO_FILE],
		@myyougotclaimsid			AS [FORW_ID],
		@AIMYGCID					AS [FIRM_ID],
		REPLACE(REPLACE(REPLACE(REPLACE(d.name,',','/'),'.','/'),' / ','/'),'/ ','/') 
									AS [D1_NAME],
		null						AS [D1_SALUT],
		REPLACE(REPLACE(REPLACE(REPLACE(d.othername,',','/'),'.','/'),' / ','/'),'/ ','/') 
									AS [D1_ALIAS],
		d.street1					AS [D1_STREET],
		d.city + ', ' + d.state		AS [D1_CS],
		REPLACE(d.zipcode,'-','')	AS [D1_ZIP], 
		d.homephone					AS [D1_PHONE],
		d.fax						AS [D1_FAX],
		d.ssn						AS [D1_SSN],
		null						AS [RFILE],
		convert(varchar(8),d.dob,112) AS [D1_DOB],
		d.dlnum						AS [D1_DL],
		d.state						AS [D1_STATE],
		null						AS [D1_MAIL],
		null						AS [SERVICE_D],
		null						AS [ANSWER_DUE_D],
		null						AS [ANSWER_FILE_D],
		null						AS [DEFAULT_D],
		null						AS [TRIAL_D],
		null						AS [HEARING_D],
		null						AS [LIEN_D],
		null						AS [GARN_D],
		null						AS [SERVICE_TYPE],
		d.street2					AS [D1_STRT2],
		d.city						AS [D1_CITY],
		null						AS [D1_CELL],
		null						AS [SCORE_FICO],
		null						AS [SCORE_COLLECT],
		null						AS [SCORE_OTHER],
		null						AS [D1_CNTRY],
		d.street1 + ' '+ d.street2	AS [D1_STREET_LONG],
		null						AS [D1_STREET2_LONG]

FROM @uniqueDebtorIDS [temp]
JOIN [dbo].[debtors] d WITH (NOLOCK) ON d.debtorid = temp.debtorid and d.SEQ = 0
JOIN [dbo].[master] m WITH (NOLOCK) ON d.number=m.number


SELECT  DISTINCT 
		'03'						AS [Record Code],
		m.number					AS [FILENO],
		m.account					AS [FORW_FILE],
		null						AS [MASCO_FILE],
		@myyougotclaimsid			AS [FORW_ID],
		@AIMYGCID					AS FIRM_ID,
		REPLACE(REPLACE(REPLACE(REPLACE(d2.name,',','/'),'.','/'),' / ','/'),'/ ','/') AS D2_NAME, 
		d2.street1+' '+d2.street2	AS D2_STREET,
		d2.city+', '+d2.state+', '+d2.zipcode AS D2_CSZ,
		d2.homephone				AS D2_PHONE,
		d2.ssn						AS D2_SSN,
		REPLACE(REPLACE(REPLACE(REPLACE(d3.name,',','/'),'.','/'),' / ','/'),'/ ','/') AS D3_NAME, 
		d3.street1+' '+d3.street2	AS D3_STREET,
		d3.city+', '+d3.state+', '+d3.zipcode AS D3_CSZ,
		d3.homephone				AS D3_PHONE,
		d3.ssn 						AS D3_SSN,
		convert(varchar(8),d2.dob,112)	AS D2_DOB,
		convert(varchar(8),d3.dob,112)	AS D3_DOB,
		d2.dlnum 					AS D2_DL,
		d3.dlnum 					AS D3_DL,
		null						AS [D2_CNTRY],
		null						AS [D3_CNTRY],
		d2.street1+' '+d2.street2	AS [D2_STREET_LONG],
		null						AS [D2_STREET2_LONG],
		d3.street1+' '+d3.street2	AS [D3_STREET_LONG],
		null						AS [D3_STREET2_LONG]

FROM @uniqueDebtorIDS [temp]
JOIN [dbo].[debtors] d2 WITH (NOLOCK) ON d2.debtorid = [temp].debtorid and d2.SEQ = 1
JOIN [dbo].[master] m WITH (NOLOCK) ON d2.number=m.number
LEFT OUTER JOIN [dbo].[debtors] d3 WITH (NOLOCK) ON d3.debtorid = [temp].debtorid AND D3.SEQ = 2



END
ELSE
BEGIN

	-- SELECT 	
		-- 'CUPH' AS record_type,
		-- ph.debtorid AS debtor_number,
		-- ph.accountid AS file_number,
		-- phonetype AS phone_type,
		-- CASE WHEN newnumber = oldnumber THEN '' ELSE newnumber END AS new_number,
		-- oldnumber AS old_number,
		-- datechanged AS date_changed,
		-- '' AS Filler
	-- FROM 	#AIMExecutingExportTransactions [temp]
		-- JOIN PhoneHistory ph WITH (NOLOCK) ON ph.ID = temp.ForeignTableUniqueID and temp.TransactionTypeID = 36

	
	SELECT 	
		'CUAD' AS record_type,
		ah.debtorid AS debtor_number,
		ah.accountid AS file_number,
		newstreet1 AS new_street1,
		newstreet2 AS new_street2,
		newcity AS new_city,
		newstate AS new_state,
		newzipcode AS new_zipcode,
		oldstreet1 AS old_street1,
		oldstreet2 AS old_street2,
		oldcity AS old_city,
		oldstate AS old_state,
		oldzipcode AS old_zipcode,
		datechanged AS date_updated
	FROM 	#AIMExecutingExportTransactions [temp]
		JOIN AddressHistory ah WITH (NOLOCK) ON ah.ID = temp.ForeignTableUniqueID and temp.TransactionTypeID = 38

	IF(@agencyVersion = '10.8.0') BEGIN
		SELECT 	
			'CUPP' AS record_type,
			pm.debtorid AS debtor_number,
			pm.number AS file_number,
			Relationship AS relationship,
			PhoneTypeID AS phone_type_id,
			PhoneStatusID AS phone_status_id,
			cast([OnHold] AS varchar(1)) AS on_hold,
			PhoneNumber AS phone_number,
			PhoneExt AS phone_ext,
			PhoneName AS phone_name,
			CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN us.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
			END AS source,
			CASE WHEN pc.AllowManualCall = 1 THEN 'Y' ELSE 'N' END AS AllowManualCalling, 
		   CASE WHEN pc.AllowAutoDialer = 1 THEN 'Y' ELSE 'N' END AS AllowAutoDialer,
		   CASE WHEN pc.AllowFax = 1 THEN 'Y' ELSE 'N' END AS AllowFax,
		   CASE WHEN pc.AllowText = 1 THEN 'Y' ELSE 'N' END AS AllowText,
		   CAST(pc.WrittenConsent AS VARCHAR(1)) AS WrittenConsent,
		   CAST(pc.ObtainedFrom AS nvarchar(100)) AS ObtainedFrom, 
		   pc.EffectiveDate AS EffectiveDate, 
		   CAST(pc.comment AS nvarchar(120)) AS Comment,
		CASE WHEN [MondayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [MondayNeverCall],
		[MondayCallWindowStart],
		[MondayCallWindowEnd],
		[MondayNoCallWindowStart],
		[MondayNoCallWindowEnd],
		CASE WHEN [TuesdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [TuesdayNeverCall],
		[TuesdayCallWindowStart],
		[TuesdayCallWindowEnd],
		[TuesdayNoCallWindowStart],
		[TuesdayNoCallWindowEnd],
		CASE WHEN [WednesdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [WednesdayNeverCall],
		[WednesdayCallWindowStart],
		[WednesdayCallWindowEnd],
		[WednesdayNoCallWindowStart],
		[WednesdayNoCallWindowEnd],
		CASE WHEN [ThursdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [ThursdayNeverCall],
		[ThursdayCallWindowStart],
		[ThursdayCallWindowEnd],
		[ThursdayNoCallWindowStart],
		[ThursdayNoCallWindowEnd],
		CASE WHEN [FridayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [FridayNeverCall],
		[FridayCallWindowStart],
		[FridayCallWindowEnd],
		[FridayNoCallWindowStart],
		[FridayNoCallWindowEnd],
		CASE WHEN [SaturdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [SaturdayNeverCall],
		[SaturdayCallWindowStart],
		[SaturdayCallWindowEnd],
		[SaturdayNoCallWindowStart],
		[SaturdayNoCallWindowEnd], 
		CASE WHEN [SundayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [SundayNeverCall],
		[SundayCallWindowStart],  
		[SundayCallWindowEnd],  
		[SundayNoCallWindowStart],  
		[SundayNoCallWindowEnd],
		'' as [Filler]
		FROM #AIMExecutingExportTransactions [temp] JOIN phones_master pm WITH (NOLOCK) ON pm.masterphoneid = temp.ForeignTableUniqueID and temp.TransactionTypeID = 37
		OUTER APPLY
	(SELECT TOP 1 * FROM Phones_Consent pc WITH (NOLOCK) WHERE pc.MasterPhoneId = pm.MasterPhoneID ORDER BY PhonesConsentId DESC) AS pc
		LEFT OUTER JOIN dbo.Phones_Preferences AS PP WITH (NOLOCK) ON PP.MasterPhoneId=pm.MasterPhoneID
			LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
			LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
			LEFT OUTER JOIN Users us WITH (NOLOCK) ON pm.LoginName = us.LoginName

	/*Exporting Email & Consent related data*/
		select
		'CEML' as record_type,
		d.number as File_number,
		d.DebtorID as debtor_number,
		CASE 
		 WHEN d.ContactMethod='Letter' THEN '1'
		 WHEN d.ContactMethod='Phone' THEN '2'
		 WHEN d.ContactMethod='Email' THEN '3'
		 WHEN d.ContactMethod='SMS' THEN '4'
		  ELSE NULL END AS PreferredMethod,
		E.[Email] as EmailAddress,
		TypeCd as EmailType,
		CASE WHEN E.ConsentGiven = 1 THEN 'Y' ELSE 'N' END AS ConsentToEmail, 
		CAST(E.WrittenConsent AS VARCHAR(1)) AS Method, 
		ConsentSource as ObtainedFrom,
		ModifiedWhen as EffectiveDate,
		E.comment as Comment,
		CASE WHEN E.TypeCd = 'Work' THEN 'Y' ELSE 'N' END AS WorkEmail,
		'' as Filler
		FROM #AIMExecutingExportTransactions [temp] JOIN dbo.Email e WITH (NOLOCK) ON e.EmailId = temp.ForeignTableUniqueID and temp.TransactionTypeID = 46
		INNER JOIN  dbo.Debtors as D WITH (NOLOCK) ON E.DebtorId=D.DebtorID	
	END
	ELSE
	BEGIN
		SELECT 	
		'CUPP' AS record_type,
		pm.debtorid AS debtor_number,
		pm.number AS file_number,
		Relationship AS relationship,
		PhoneTypeID AS phone_type_id,
		PhoneStatusID AS phone_status_id,
		cast([OnHold] AS varchar(1)) AS on_hold,
		PhoneNumber AS phone_number,
		PhoneExt AS phone_ext,
		PhoneName AS phone_name,
		CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN us.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
		END AS source,
		'' AS [Filler]
		FROM #AIMExecutingExportTransactions [temp] JOIN phones_master pm WITH (NOLOCK) ON pm.masterphoneid = temp.ForeignTableUniqueID and temp.TransactionTypeID = 37
		LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
		LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
		LEFT OUTER JOIN Users us WITH (NOLOCK) ON pm.LoginName = us.LoginName
	END
END

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END
GO
