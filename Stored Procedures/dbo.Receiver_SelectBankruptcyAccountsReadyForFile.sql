SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[Receiver_SelectBankruptcyAccountsReadyForFile] 
 
@clientid int

as

begin

	DECLARE @AIMClientVersion varchar(10)
	DECLARE @UseNewSchema bit
	
	SELECT @AIMClientVersion = [AIMClientVersion]
	FROM Receiver_Client WHERE ClientID = @clientid
	
	IF(RTRIM(LTRIM(@AIMClientVersion)) = '8.3.*' OR RTRIM(LTRIM(@AIMClientVersion)) IN ('10.7' ,'10.8'))
	BEGIN
		SET @UseNewSchema = 1
	END
	ELSE
	BEGIN
		SET @UseNewSchema = 0
	END


--DECLARE TEMP TABLE
DECLARE  @tempBankruptcy TABLE(
	[BankruptcyID] [int] NOT NULL ,
	[Chapter] [int]
) 


--INSERT DATA INTO TEMP TABLE
INSERT INTO @tempBankruptcy (BankruptcyId,Chapter)
SELECT  BankruptcyID,Chapter
FROM 
	bankruptcy b with (nolock) join receiver_debtorreference rd with (nolock) on b.debtorid = rd.receiverdebtorid
	join master m with (nolock) on m.number = b.accountid
	join receiver_reference rr with (nolock) on rr.receivernumber = m.number
WHERE 
	b.transmitteddate is null and rr.clientid = @clientid
	and b.casenumber is not null and ltrim(rtrim(casenumber)) <> ''
	and (b.chapter = 7 or b.chapter = 11 or b.chapter = 13)
	and m.qlevel < '999' AND ISNULL(b.ctl,'') != 'AIM'


--UPDATE TRANSMITTED DATE IN BANKRUPTCY TABLE
UPDATE Bankruptcy
SET
	TransmittedDate = getdate()
FROM 
	Bankruptcy b join @tempBankruptcy t
	on b.BankruptcyId = t.BankruptcyId
--UPDATE MASTER TABLE AS RETURNED
UPDATE Master
SET
	status = CASE t.Chapter WHEN 7 THEN 'B07' WHEN 11 THEN 'B11' WHEN 13 THEN 'B13' END,
	returned = getdate(),
	qlevel = '999',
	closed = isnull(closed,getdate())
FROM 
	bankruptcy b with (nolock) join receiver_debtorreference rd with (nolock) on b.debtorid = rd.receiverdebtorid
	join master m with (nolock) on m.number = b.accountid
	join receiver_reference rr with (nolock) on rr.receivernumber = m.number
	join @tempbankruptcy t  on t.bankruptcyid = b.bankruptcyid


INSERT INTO NOTES (number,user0,action,result,comment,created)
SELECT b.accountid,'AIM','+++++','+++++','Bankruptcy info was entered.  Account will be returned via AIM Receiver and Status updated to B' + cast(t.chapter as varchar(2))+'.',getdate()
FROM bankruptcy b with (nolock) join @tempbankruptcy t on b.bankruptcyid= t.bankruptcyid

IF(@UseNewSchema = 0) BEGIN
	--SELECT FROM TEMP TABLE JOIN BANKRUPTCY TABLE
	SELECT
		'ABKP' as record_type,
		rd.senderdebtorid as debtor_number,
		rr.sendernumber as file_number,
		b.chapter as chapter,
		b.datefiled as date_filed,
		b.casenumber as case_number,
		b.courtcity as court_city,
		b.courtdivision as court_division,
		b.courtdistrict as court_district,
		b.courtphone as court_phone,
		b.courtstreet1 as court_street1,
		b.courtstreet2 as court_street2,
		b.courtstate as court_state,
		b.courtzipcode as court_zipcode,
		b.trustee as trustee,
		b.trusteestreet1 as trustee_street1,
		b.trusteestreet2 as trustee_street2,
		b.trusteecity as trustee_city,
		b.trusteestate as trustee_state,
		b.trusteezipcode as trustee_zipcode,
		b.trusteephone as trustee_phone,
		b.has341info as three_forty_one_info_flag,
		case b.datetime341 when '1753-01-01 00:00:00.000' then null else b.datetime341 end as three_forty_one_date,
		b.location341 as three_forty_one_location,
		b.comments as comments,
		b.status as status,
		b.transmitteddate as transmit_date
			

	FROM
		bankruptcy b with (nolock) join receiver_debtorreference rd with (nolock) on b.debtorid = rd.receiverdebtorid
		join master m with (nolock) on m.number = b.accountid
		join receiver_reference rr with (nolock) on rr.receivernumber = m.number
		join @tempbankruptcy t  on t.bankruptcyid = b.bankruptcyid
END
ELSE
-- Otherwise we are using the new schema with more fields fields.
BEGIN

	SELECT 
		'ABKP' as record_type,
		rd.senderdebtorid as debtor_number,
		rr.sendernumber as file_number,
		b.chapter as chapter,
		b.datefiled as date_filed,
		b.casenumber as case_number,
		b.courtcity as court_city,
		b.courtdivision as court_division,
		b.courtdistrict as court_district,
		b.courtphone as court_phone,
		b.courtstreet1 as court_street1,
		b.courtstreet2 as court_street2,
		b.courtstate as court_state,
		b.courtzipcode as court_zipcode,
		b.trustee as trustee,
		b.trusteestreet1 as trustee_street1,
		b.trusteestreet2 as trustee_street2,
		b.trusteecity as trustee_city,
		b.trusteestate as trustee_state,
		b.trusteezipcode as trustee_zipcode,
		b.trusteephone as trustee_phone,
		b.has341info as three_forty_one_info_flag,
		case b.datetime341 when '1753-01-01 00:00:00.000' then null else b.datetime341 end as three_forty_one_date,
		b.location341 as three_forty_one_location,
		b.comments as comments,
		b.status as status,
		b.transmitteddate as transmit_date,
		-- New additions KAR 04/29/2010
		b.[DateNotice] as notice_date,--<column name="notice_date" dataType="dateTime" width="8" />
		b.[ProofFiled] as proof_filed_date, --<column name="proof_filed_date" dataType="dateTime" width="8" />
		b.[DischargeDate] as discharge_date,--<column name="discharge_date" dataType="dateTime" width="8" />
		b.[DismissalDate] as dismissal_date,--<column name="dismissal_date" dataType="dateTime" width="8" />
		b.[ConfirmationHearingDate] as 	confirmation_hearing_date,--<column name="confirmation_hearing_date" dataType="dateTime" width="8" />
		b.[ReaffirmDateFiled] as reaffirm_filed_date,--<column name="reaffirm_filed_date" dataType="dateTime" width="8" />
		b.[VoluntaryDate] as voluntary_date, --<column name="voluntary_date" dataType="dateTime" width="8" />
		b.[SurrenderDate] as surrender_date,--<column name="surrender_date" dataType="dateTime" width="8" />
		b.[AuctionDate] as auction_date,--<column name="auction_date" dataType="dateTime" width="8" />
		b.[ReaffirmAmount] as reaffirm_amount,--<column name="reaffirm_amount" dataType="decimal" width ="12" />
		b.[VoluntaryAmount] as voluntary_amount,--<column name="voluntary_amount" dataType="decimal" width ="12" />
		b.[AuctionAmount] as auction_amount,--<column name="auction_amount" dataType="decimal" width ="12" />
		b.[AuctionFee] as auction_fee_amount,--	<column name="auction_fee_amount" dataType="decimal" width ="12" />
		b.[AuctionAmountApplied] as auction_applied_amount,--<column name="auction_applied_amount" dataType="decimal" width ="12" />
		b.[SecuredAmount] as secured_amount,--<column name="secured_amount" dataType="decimal" width ="12" />
		b.[SecuredPercentage] as secured_percentage,--<column name="secured_percentage" dataType="decimal" width ="12" />
		b.[UnsecuredAmount] as unsecured_amount,--<column name="unsecured_amount" dataType="decimal" width ="12" />
		b.[UnsecuredPercentage] as unsecured_percentage,--<column name="unsecured_percentage" dataType="decimal" width ="12" />
		b.[ConvertedFrom] as converted_from_chapter,--<column name="converted_from_chapter" dataType="int" width="2" />
		CASE b.[HasAsset] WHEN 1 THEN '1' ELSE '0' END as has_asset,--<column name="has_asset" dataType="string" width="1" />
		b.[Reaffirm] as reaffirm_flag,--<column name="reaffirm_flag" dataType="string" width="1" />
		b.[ReaffirmTerms] as reaffirm_terms,--<column name="reaffirm_terms" dataType="string" width="50" />
		b.[VoluntaryTerms] as voluntary_terms,--<column name="voluntary_terms" dataType="string" width="50" />
		b.[SurrenderMethod] as surrender_method,--<column name="surrender_method" dataType="string" width="50" />
		b.[AuctionHouse] as auction_house--<column name="auction_house" dataType="string" width="50" />
	
	FROM
		bankruptcy b with (nolock) join receiver_debtorreference rd with (nolock) on b.debtorid = rd.receiverdebtorid
		join master m with (nolock) on m.number = b.accountid
		join receiver_reference rr with (nolock) on rr.receivernumber = m.number
		join @tempbankruptcy t  on t.bankruptcyid = b.bankruptcyid

END

end
GO
