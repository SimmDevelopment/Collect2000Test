SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Placement_SelectTransactionsReadyForFile]
(
 @agencyID INT,
 @transactionTypeID int
)

AS
BEGIN

DECLARE @myyougotclaimsid VARCHAR(20),@myname VARCHAR(30),@mystreet VARCHAR(62),@mycitystatezip VARCHAR(36),@myphone VARCHAR(20),@AIMYGCID VARCHAR(10)
DECLARE @rowcount INT, @currentrow INT, @maxid INT, @sqlbatchsize INT


SELECT  
@myyougotclaimsid = yougotclaimsid,
@myname = company,
@mystreet = street1 + ' ' + street2,
@mycitystatezip = city + ', ' + state + ' ' + zipcode , 
@myphone = phone 
FROM controlfile;

SELECT
@AIMYGCID = AlphaCode
FROM AIM_Agency WHERE AgencyID = @agencyID;

SELECT 
@sqlbatchsize = CAST(CAST(VALUE AS VARCHAR) AS INT) 
FROM aim_appsetting 
WHERE [key] = 'AIM.Database.SqlBatchTransactionSize';

CREATE TABLE #placeaccounts (referenceNumber int primary key, accountreferenceid int, account VARCHAR(30),commissionpercentage float,feeschedule varchar(5) )
DECLARE @executeSQL VARCHAR(8000)
set @executeSQL =
'insert into #placeaccounts
select	top ' + cast(@sqlbatchsize as VARCHAR(16)) + ' referenceNumber
	,max(ar.accountreferenceid)
	,m.account
	,atr.commissionpercentage
	,atr.feeschedule
from	AIM_accountreference ar with (nolock)
	join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
	join master m WITH (NOLOCK) on m.number = ar.referencenumber
where	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
	and transactiontypeid = 1 
	and transactionstatustypeid = 1
group by referencenumber,account,atr.commissionpercentage,atr.feeschedule'

exec(@executeSQL)



SELECT           
		'01'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as [FIRM_ID],
		GETDATE()					as [DATE_FORW],
		null						as [LAW_LIST],
		right(cast(CASE WHEN acct.feeschedule is null 
		THEN cast(cast(isnull(acct.commissionpercentage,0) as float)/cast(100 as float)  as decimal(5,4))
		ELSE cast(cast(isnull(fsd.fee1,0) as float)/cast(100 as float) as decimal(5,4))	END as varchar(6)),5)	
		as [COMM], 
		null						as [SFEE],
		m.current1					as [ORIG_CLAIM],
		m.current2					as [ORIG_INT],
		m.lastinterest				as [ORIG_INT_D],
		right(cast(cast(cast(isnull(interestrate,0) as float)/cast(100 as float) as decimal(5,4)) as varchar(6)),5) as [RATES_PRE],
		cast('.0000'as varchar(5))	as [RATES_POST],
		CASE WHEN len(c.name) > 25 THEN left(c.name,25) ELSE c.name END	as [CRED_NAME],
		CASE WHEN len(c.name) > 25 THEN substring(c.name,26,25) ELSE '' END	as [CRED_NAME2],
		c.street1+' '+isnull(c.street2,'')	as [CRED_STREET],
		c.city+', '+c.state			as [CRED_CS],
		c.zipcode					as [CRED_ZIP],
		m.current1					as [DEBT_BAL],
		null						as [CTYPE],
		isnull(CASE WHEN m.lastpaid is null and m.clidlp is null THEN '' 
		WHEN m.lastpaid is null THEN m.clidlp WHEN m.clidlp is null THEN m.lastpaid 
		WHEN m.clidlp > m.lastpaid THEN m.clidlp WHEN m.lastpaid > m.clidlp THEN m.lastpaid ELSE '' END,'1/1/1900') 
									as [DATE_LPAY],
		abs(m.lastpaidamt)			as [AMT_LPAY],
		m.contractdate				as [DATE_OPEN],
		m.chargeoffdate				as [CHRG_OFF_D],
		m.current1					as [CHRG_OFF_A],
		isnull(m.ContractDate,m.received)	as [PURCHASE_D],
		CASE WHEN len(m.originalcreditor) > 30 THEN left(m.originalcreditor,30) ELSE m.originalcreditor END	as [ORIG_CRED],
		CASE WHEN len(m.originalcreditor) > 30 THEN substring(m.originalcreditor,31,30) ELSE '' END			as [ORIG_CRED2],
		m.customer					as [PORT_ID],
		null						as [CRED_CNTRY],
		m.clidlp					as [LPAY_ISS_D],
		m.clialp					as [LPAY_ISS_AMT],
		null						as [MEDIA],
		m.delinquencydate			as [DELINQ_D],
		null						as [ACCEL_D],
		null						as [REPO_D],
		null						as [SALE_D],
		null						as [MATUR_D],
		m.statutedate				as [SOL_START_D],
		m.statutedate				as [SOL_END_D]

FROM [dbo].[master] m WITH (nolock)
JOIN #placeaccounts acct ON acct.referencenumber = m.number
JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
LEFT OUTER JOIN AIM_Portfolio ap WITH (NOLOCK) ON m.purchasedportfolio = ap.portfolioid
LEFT OUTER JOIN [dbo].[feescheduledetails] fsd with (nolock) on acct.feeschedule = fsd.code and fsd.seq = 1

 
SELECT            
		'02'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as [FIRM_ID],
		replace(replace(replace(replace(d.name,',','/'),'.','/'),' / ','/'),'/ ','/') 
									as [D1_NAME],
		null						as [D1_SALUT],
		replace(replace(replace(replace(d.othername,',','/'),'.','/'),' / ','/'),'/ ','/') 
									as [D1_ALIAS],
		d.street1					as [D1_STREET],
		d.city + ', ' + d.state		as [D1_CS],
		replace(d.zipcode,'-','')	as [D1_ZIP], 
		d.homephone					as [D1_PHONE],
		d.fax						as [D1_FAX],
		d.ssn						as [D1_SSN],
		null						as [RFILE],
		d.dob						as [D1_DOB],
		d.dlnum						as [D1_DL],
		d.state						as [D1_STATE],
		null						as [D1_MAIL],
		null						as [SERVICE_D],
		null						as [ANSWER_DUE_D],
		null						as [ANSWER_FILE_D],
		null						as [DEFAULT_D],
		null						as [TRIAL_D],
		null						as [HEARING_D],
		null						as [LIEN_D],
		null						as [GARN_D],
		null						as [SERVICE_TYPE],
		d.street2					as [D1_STRT2],
		null						as [D1_CITY],
		null						as [D1_CELL],
		null						as [SCORE_FICO],
		null						as [SCORE_COLLECT],
		m.score						as [SCORE_OTHER],
		null						as [D1_CNTRY],
		d.street1 + ' '+ isnull(d.street2,'')  as [D1_STREET_LONG],
		null						as [D1_STREET2_LONG]

FROM #placeaccounts acct 
JOIN [dbo].[debtors] d WITH (nolock) ON d.number = acct.referencenumber AND D.SEQ = 0
JOIN [dbo].[master] m WITH (NOLOCK) ON d.number = m.number

SELECT            
		'03'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		replace(replace(replace(replace(d2.name,',','/'),'.','/'),' / ','/'),'/ ','/') as D2_NAME, 
		d2.street1+' '+isnull(d2.street2,'')	as D2_STREET,
		d2.city+', '+d2.state+', '+d2.zipcode as D2_CSZ,
		d2.homephone				as D2_PHONE,
		d2.ssn						as D2_SSN,
		replace(replace(replace(replace(d3.name,',','/'),'.','/'),' / ','/'),'/ ','/') as D3_NAME, 
		d3.street1+' '+isnull(d3.street2,'')	as D3_STREET,
		d3.city+', '+d3.state+', '+d3.zipcode as D3_CSZ,
		d3.homephone				as D3_PHONE,
		d3.ssn 						as D3_SSN,
		d2.dob 						as D2_DOB,
		d3.dob 						as D3_DOB,
		d2.dlnum 					as D2_DL,
		d3.dlnum 					as D3_DL,
		null						as [D2_CNTRY],
		null						as [D3_CNTRY],
		d2.street1+' '+isnull(d2.street2,'')	as [D2_STREET_LONG],
		null						as [D2_STREET2_LONG],
		d3.street1+' '+isnull(d3.street2,'')	as [D3_STREET_LONG],
		null						as [D3_STREET2_LONG]

FROM #placeaccounts acct 
JOIN [dbo].[debtors] d2 WITH (nolock) ON d2.number = acct.referencenumber AND D2.SEQ = 1
LEFT OUTER JOIN [dbo].[debtors] d3 WITH (nolock) ON d3.number = acct.referencenumber AND D3.SEQ = 2

 
SELECT            
		'04'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		d.jobname					as EMP_NAME,
		d.jobaddr1+' '+isnull(d.jobaddr2,'')	as EMP_STREET,
		null						as EMP_PO,
		d.jobcsz					as EMP_CS,
		null						as EMP_ZO,
		d.workphone					as EMP_PHONE,
		null						as EMP_FAX,
		d.jobmemo					as EMP_ATTN,
		null						as EMP_PAYR,
		null						as EMP_NO,
		null						as EMPLOYEE_NAME,
		null						as EMP_INCOME,
		null						as EMP_FREQ,
		null						as EMP_POS,
		null						as EMP_TENURE,
		null						as EMP_CNTRY

FROM #placeaccounts acct 
JOIN [dbo].[debtors] d WITH (nolock) ON d.number = acct.referencenumber AND D.SEQ = 0

SELECT
		'05'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		null 						as FILLER,
		dbi.bankname				as BANK_NAME,
		dbi.bankaddress				as BANK_STREET,
		dbi.bankcity + ' ' + dbi.bankstate + ' ' + dbi.bankzipcode	as BANK_CSZ,
		null 						as BANK_ATTN, 
		dbi.bankphone				as BANK_PHONE,
		null 						as BANK_FAX,
		dbi.accountnumber			as BANK_ACCT,
		null 						as MISC_ASSET1,
		null 						as MISC_ASSET2, 
		null 						as MISC_ASSET3,
		null 						as MISC_PHONE,
		null 						as BANK_NO,
		null						as BANK_CNTRY

FROM #placeaccounts acct
JOIN [dbo].[debtors] d WITH (nolock) ON d.number = acct.referencenumber AND D.SEQ = 0
JOIN [dbo].[debtorbankinfo] dbi WITH (NOLOCK)  ON acct.referencenumber = dbi.acctID and dbi.DebtorID = 0

SELECT            
		'06'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		da.name						as ADVA_NAME,
		da.firm						as ADVA_FIRM,
		null						as ADVA_FIRM2,
		da.addr1+' '+da.addr2		as ADVA_STREET,
		da.city+', '+da.state+', '+da.zipcode as ADVA_CSZ,
		null						as ADVA_SALUT,
		da.phone					as ADVA_PHONE,
		da.fax						as ADVA_FAX,
		null 						as ADVA_FILENO,
		null 						as MISC_DATE1,
		null 						as MISC_DATE2,
		null 						as MISC_AMT1,
		null 						as MISC_AMT2,
		da.comments					as MISC_COMM1,
		da.email					as MISC_COMM2,
		null 						as MISC_COMM3,
		null 						as MISC_COMM4,
		'00' + cast(d.SEQ+1 as char(1))	as ADVA_NUM,
		null						as ADVA_CNTRY

FROM #placeaccounts acct 
JOIN [dbo].[debtors] d WITH (nolock) ON d.number = acct.referencenumber AND D.SEQ <=2
JOIN [dbo].[DebtorAttorneys] da with(nolock) on da.debtorid = d.debtorid


SELECT           
		'07'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		c.county					as CRT_COUNTY,
		null						as CRT_DESIG,
		null						as CRT_TYPE,
		c.courtname					as SHER_NAME,
		c.clerklastname+', '+c.clerkfirstname as SHER_NAME2,
		c.address1 + ' '+c.address2 as SHER_STREET,
		c.city+', '+c.state+', '+c.zipcode as SHER_CSZ,
		null 						as SUIT_AMT,
		null 						as CNTRCT_FEE,
		null 						as STAT_FEE,
		null 						as DOCKET_NO,
		cc.casenumber				as JDGMNT_NO,
		null						as BKCY_NO,
		null						as SUIT_DATE,
		cc.judgementdate			as JDGMNT_DATE,
		cc.judgementintrate			as JDGMNT_AMT,
		cc.judgementamt				as JUDG_PRIN,
		m.interestrate				as PREJ_INT,
		cc.judgementcostaward		as JDG_COSTS,
		null						as ADJUSTMENT,
		null						as SHER_CNTRY
FROM #placeaccounts acct 
join [dbo].[courtcases] cc with(nolock) on acct.referencenumber = cc.accountid
join [dbo].[courts] c with(nolock) on c.courtid = cc.courtid
join master m with (nolock) on acct.referencenumber = m.number

SELECT            
		'08'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		CASE WHEN len(c.name) > 30 THEN left(c.name,30) ELSE c.name END as PLAINTIFF_1, 
		CASE WHEN len(c.name) > 30 THEN substring(c.name,31,30) ELSE '' END	as PLAINTIFF_2, 
		null 						as PLAINTIFF_3, 
		null 						as PLAINTIFF_4,
		null 						as PLAINTIFF_5, 
		null 						as PLAINTIFF_6, 
		null 						as PLAINTIFF_7,
		m.name						as DEFENDANT_1,
		null 						as DEFENDANT_2,
		null 						as DEFENDANT_3,
		null 						as DEFENDANT_4,
		null 						as DEFENDANT_5,
		null 						as DEFENDANT_6,
		null 						as DEFENDANT_7,
		null 						as DEFENDANT_8,
		null 						as DEFENDANT_9

FROM #placeaccounts acct 
JOIN master m with (nolock) on m.number = acct.referencenumber  
JOIN customer c WITH (NOLOCK) ON m.customer = c.customer                 




SELECT            
		'09'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		getdate()					as PDATE, 
		'*CC:S001'					as PCODE,
		'Placing Account.'			as PCMT

FROM #placeaccounts acct 


SELECT            
		'15'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		dec.dod						as DOD,
		dec.casenumber				as PRB_CASE_NO,
		dec.state					as PRB_ST,
		null						as PRB_CTY,
		dec.courtdistrict			as PRB_CRT,
		dec.datefiled				as PRB_DATE,
		dec.claimdeadline			as PRB_EXP,
		dec.executor				as REP_NAME,
		dec.executorstreet1			as REP_STRT1,
		dec.executorstreet2			as REP_STRT2,
		dec.executorcity			as REP_CITY,
		dec.executorstate			as REP_ST,
		dec.executorzipcode			as REP_ZIP,
		dec.executorphone			as REP_PHONE,
		null						as ATTY_NAME,
		null						as ATTY_FIRM,
		null						as ATTY_STRT1,
		null						as ATTY_STRT2,
		null						as ATTY_CITY,
		null						as ATTY_ST,
		null						as ATTY_ZIP,
		null						as ATTY_PHONE,
		null						as REP_CNTRY,
		null						as ATTY_CNTRY


FROM [dbo].[deceased] [dec] WITH (NOLOCK)
JOIN #placeaccounts acct ON acct.referencenumber = dec.accountid
JOIN [dbo].[debtors] d WITH (NOLOCK) ON dec.debtorid = d.debtorid AND d.seq <= 2


SELECT           
		'16'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		da.AssetType AS ASSET_ID,
		d.Name AS ASSET_OWNER,
		d.Street1 AS STREET,
		d.Street2 AS STREET_2,
		NULL AS STREET_3,
		d.City AS CITY,
		NULL AS TOWN,
		NULL AS CNTY,
		d.State AS STATE,
		d.Zipcode AS ZIP,
		NULL AS CNTRY,
		NULL AS PHONE,
		NULL AS BLOCK,
		NULL AS LOT,
		da.currentvalue AS ASSET_VALUE,
		da.Name AS ASSET_DESC,
		NULL AS ASSET_VIN,
		NULL AS ASSET_LIC_PLATE,
		NULL AS ASSET_COLOR,
		NULL AS ASSET_YEAR,
		NULL AS ASSET_MAKE,
		NULL AS ASSET_MODEL,
		NULL AS REPO_FILE_NUM,
		NULL AS REPO_D,
		NULL AS REPO_AMT,
		NULL AS CERT_TITLE_NAME,
		NULL AS CERT_TITLE_D,
		NULL AS MORT_FRCL_D,
		NULL AS MORT_FRCL_FILENO,
		NULL AS MORT_FRCL_DISMIS_D,
		NULL AS MORT_PMT,
		NULL AS MORT_RATE,
		NULL AS MORT_BOOK_1,
		NULL AS MORT_PAGE_1,
		NULL AS MORT_BOOK_2,
		NULL AS MORT_PAGE_2,
		NULL AS MORT_RECRD_D,
		NULL AS MORT_DUE_D,
		NULL AS LIEN_FILE_NUM,
		NULL AS LIEN_CASE_NUM,
		NULL AS LIEN_D,
		NULL AS LIEN_BOOK,
		NULL AS LIEN_PAGE,
		NULL AS LIEN_AOL,
		NULL AS LIEN_RLSE_D,
		NULL AS LIEN_RLSE_BOOK,
		NULL AS LIEN_RLSE_PAGE,
		NULL AS LIEN_LITIG_D,
		NULL AS LIEN_LITIG_BOOK,
		NULL AS LIEN_LITIG_PAGE

FROM [debtor_assets] da WITH (NOLOCK)
JOIN #placeaccounts acct ON acct.referencenumber = da.accountid
JOIN debtors d WITH (NOLOCK) ON da.accountid = d.number AND da.debtorid = d.debtorid and d.seq <= 2

	
SELECT            
		'19'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		b.chapter					as CHAPTER,
		b.casenumber				as BK_FILENO,
		b.courtdistrict				as LOC,
		b.datefiled					as FILED_DATE,
		b.dismissaldate				as DSMIS_DATE,
		b.dischargedate				as DSCHG_DATE,
		null						as CLOSE_DATE,
		null						as CNVRT_DATE,
		convert(varchar(16),b.datetime341,121)	as MTG_341_DATETIME,
		b.location341				as MTG341_LOC,
		null						as JUDGE_INIT,
		b.reaffirmamount			as REAF_AMT,
		b.reaffirmdatefiled			as REAF_DATE,
		null						as PAY_AMT,
		null						as PAY_DATE,
		null						as CONF_DATE,
		null						as CURE_DATE

FROM [dbo].[bankruptcy] b WITH (NOLOCK)
JOIN #placeaccounts acct ON acct.referencenumber = b.accountid
JOIN [dbo].[debtors] d WITH (NOLOCK) ON b.debtorid = d.debtorid AND d.seq <= 2

SELECT
		'22'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		d.firstname					as [F_NAME],
		d.middlename				as [M_NAME],
		d.lastname					as [L_NAME],
		d.suffix					as [SUFFIX],
		ah.oldstreet1				as [STREET],
		ah.oldstreet2				as [STREET2],
		ah.oldcity					as [CITY],
		ah.oldstate					as [STATE],
		ah.oldzipcode				as [ZIP],
		'USA'						as [CNTRY],
		NULL						as [OBTAINED_D],
		NULL						as [SOURCE],
		'B'							as [VERIFY_STAT],
		NULL						as [BAD_REASON],
		NULL						as [VERIFY_D],
		NULL						as [START_D],
		NULL						as [END_D]


FROM  [addresshistory] ah WITH (NOLOCK) 
JOIN [debtors] d WITH (NOLOCK)  ON d.number = ah.accountid and d.debtorid = ah.debtorid AND d.seq <= 2
JOIN #placeaccounts acct ON acct.referencenumber = ah.accountid




SELECT
		'23'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		'00' + cast(d.SEQ+1 as char(1))	as DBTR_NUM,
		d.firstname					as [F_NAME],
		d.middlename				as [M_NAME],
		d.lastname					as [L_NAME],
		d.suffix					as [SUFFIX],
		pm.phonenumber				as [PHONE],
		pm.phoneext					as [PH_EXT],
		CASE pm.phonetypeid WHEN 1 THEN 'H' WHEN 2 THEN 'W' WHEN 3 THEN 'C' WHEN 4 THEN 'F' WHEN 6 THEN 'W2' WHEN 5 THEN 'H' END as [PH_TYPE],
		pm.DateAdded				as [OBTAINED_D],
		NULL						as [SOURCE],
		'B'							as [VERIFY_STAT],
		NULL						as [BAD_REASON],
		NULL						as [VERIFY_D],
		NULL						as [START_D],
		NULL						as [END_D]

FROM [phones_master] pm WITH (NOLOCK) 
JOIN [debtors] d WITH (NOLOCK)  ON d.number = pm.number and d.debtorid = pm.debtorid AND d.seq <= 2
JOIN #placeaccounts acct ON acct.referencenumber = pm.number




SELECT
		'24'						as [Record Code],
		acct.referencenumber		as [FILENO],
		acct.account				as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		p.datepaid					AS [POST_D],
		'1'							as [TRANS_CD],
		p.uid						as [TRANS_NUM],
		p.paid1+p.paid2+p.paid3+p.paid4+p.paid5+p.paid6+p.paid7+p.paid8+p.paid9	as [TOTAL_COLL],
		p.paid1						as [PRIN_COLL],
		p.paid2						as [INT_COLL],
		p.paid4+p.paid5				as [COST_COLL],
		0.0							as [STATU_COLL],
		0.0	as [COMM],
		null						as [DBTR_BAL],
		0.0							as [COST_EXPND],
		CASE WHEN p.batchtype like '%r%' THEN 'Reversal' ELSE 'Payment' END as [DESC],
		p.comment					as [CMT]

FROM #placeaccounts acct
JOIN [payhistory] p WITH (NOLOCK) ON acct.referencenumber = p.number

WHERE
  p.batchtype in ('PC','PU','PCR','PUR','PA','PAR')

SELECT    
		'99'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		l.yougotclaimsid			as [LAW_LIST],
		getdate()					as [DATE_FORW]
		,m.original1				as [ORIG_CLAIM],
		m.original2					as [ORIG_INT],
		m.lastinterest				as [ORG_INT_D],
		@myname						as [RE] ,
		replace(replace(replace(replace(m.name,',','/'),'.','/'),' / ','/'),'/ ','/')[VS],
		@AIMYGCID					as FIRM_ID,
		null						as [LL_ATTYID],
		a.Name						as [ATTY_NAME],
		a.address + ' ' + a.address1 as [ATTY_STREET],
		a.city + ', ' + a.state + ' ' + a.zip as [ATTY_CSZ],
		a.contactname				as [ATTY_CONTA]
		,null						as [ATTY_CNTRY],
		@myname						as [FORW_NAME],
		@mystreet					as [FORW_STREET],
		@mycitystatezip				as [FORW_CSZ],
		@myphone					as [FORW_PHONE],
		null						as [FORW_CONTA]

FROM   #placeaccounts acct
JOIN [dbo].[master] m with(nolock) ON acct.referencenumber = m.number,[AIM_Agency] a with (nolock) 
join [dbo].[lawlists] l with (NOLOCK) on a.defaultlawlist = l.code

WHERE a.AgencyID = @agencyId



		update 	AIM_accounttransaction with (rowlock) 
			set transactionstatustypeid = 2 -- being placed
		from 
			AIM_accounttransaction att
			join #placeaccounts a on a.accountreferenceid = att.accountreferenceid
		where
			transactiontypeid = 1 -- placement
			and transactionstatustypeid = 1 -- open
			and agencyid = @agencyId	

		drop table #placeaccounts
END

GO
