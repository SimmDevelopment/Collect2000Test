SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             procedure [dbo].[LatitudeLegal_Export]

(

            @startdate datetime = null,

            @enddate datetime = null,

            @tableName varchar(100)

)

as

begin

 

 

-- get static variables

declare @myyougotclaimsid varchar(20)

declare @myname varchar(30)

declare @mystreet varchar(62)

declare @mycitystatezip varchar(36)

declare @myphone varchar(20)

 

SELECT            @myyougotclaimsid = yougotclaimsid,@myname = company,@mystreet = street1 + ' ' + street2,

                         @mycitystatezip = city + ', ' + state + ' ' + zipcode , @myphone = phone from controlfile

set                    @enddate = isnull(@enddate,getdate())

if(@enddate is null)

begin

set @enddate = getdate()

end

if(@startdate is  null)

begin

select @startdate = max(starteddatetime) from LatitudeLegal_History where endeddatetime is not null and type = 'Export' and Test = 0

end

/********    DataSet **************

            Table[0]  - 01 new claims

            Table[1]  - 02 primary debtor

            Table[2]  - 03 2nd and 3rd debtor 

            Table[3]  - 04 employment info 

            Table[4]  - 05 Asset info

            Table[5]  - 06 misc info

            Table[6]  - 07 legal info

            Table[7]  - 08 caption legal names

            Table[8]  - 09 messages

            Table[9]  - 11 invoice

            Table[10] - 12 direct payments

            Table[11] - 18 reconciliation

            Table[12] - 21 financial discrepency

**********************************************/

--select * from branchcodes

-- new claim

if( @tableName =  'NewClaim')

BEGIN

 

 SELECT           '01' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        m.assignedattorney as [DATE_FORW],null as [LAW_LIST],isnull(a.feerate,0) as [COMM],

                        null as [SFEE],m.current1 as [ORIG_CLAIM],m.current2 as ORIG_INT,m.lastinterest as ORIG_INT_D,

                        isnull(CASE WHEN len(substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)) = 5 THEN substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)

                        WHEN len(substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)) = 4 THEN substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5) + '0'

                        WHEN len(substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)) = 3 THEN substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5) + '00'

                        WHEN len(substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)) = 2 THEN substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5) + '000'

                        WHEN len(substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5)) = 1 THEN substring(cast(cast(isnull(interestrate,0)/100 as float) as varchar(10)),2,5) + '0000'

                        END,cast('.0000' as varchar(5))) as [RATES_PRE],cast('.0000'as varchar(5)) as [RATES_POST],m.originalcreditor as [CRED_NAME],'' as [CRED_NAME2],

                        b.address1+' '+b.address2 as [CRED_STREET],b.city+', '+b.state as [CRED_CS],

                        b.zipcode as [CRED_ZIP],m.current1 + m.current2 as [DEBT_BAL],null as [CTYPE],isnull(CASE WHEN m.lastpaid is null and m.clidlp is null THEN '' 

                                                WHEN m.lastpaid is null THEN m.clidlp WHEN m.clidlp is null THEN m.lastpaid WHEN m.clidlp > m.lastpaid THEN m.clidlp WHEN m.lastpaid > m.clidlp THEN m.lastpaid ELSE '' END,'1/1/1900') as [DATE_LPAY],

                        abs(m.lastpaidamt) as [AMT_LPAY],m.contractdate as [DATE_OPEN],m.chargeoffdate as [CHRG_OFF_D],

                        null as [CHRG_OFF_A],null as [PURCHASE_D]

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        left outer join [dbo].[branchcodes] b with(nolock) on m.branch = b.code

WHERE            m.attorneystatus = 'Placing'

 

END

else if(@tableName =  'Debtor')

BEGIN

 

-- primary debtor

SELECT            '02' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        replace(replace(replace(replace(d.name,',','/'),'.','/'),' / ','/'),'/ ','/')

                        as [D1_NAME],null as [D1_SALUT],replace(replace(replace(replace(d.othername,',','/'),'.','/'),' / ','/'),'/ ','/') as [D1_ALIAS],

                        d.street1+' '+d.street2 as [D1_STREET],d.city+', '+d.state as [D1_CS],

                        replace(d.zipcode,'-','') as [D1_ZIP], d.homephone as [D1_PHONE],d.fax as [D1_FAX],

                        d.ssn as [D1_SSN],null as [RFILE],d.dob as [D1_DOB],d.dlnum as [D1_DL],d.state as [D1_STATE]

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[debtors] d with(nolock) on d.number = m.number

WHERE            m.attorneystatus = 'Placing' and d.seq = 0

 

END

else if(@tableName =   '2ndDebtor')

BEGIN

 

-- 2nd and 3rd debtors

SELECT            '03' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        replace(replace(replace(replace(d2.name,',','/'),'.','/'),' / ','/'),'/ ','/') as D2_NAME, d2.street1+' '+d2.street2 as D2_STREET,

                        d2.city+', '+d2.state+', '+d2.zipcode as D2_CSZ,d2.homephone as D2_PHONE,d2.ssn as D2_SSN,

                        replace(replace(replace(replace(d3.name,',','/'),'.','/'),' / ','/'),'/ ','/') as D3_NAME, d3.street1+' '+d3.street2 as D3_STREET,

                        d3.city+', '+d3.state+', '+d3.zipcode as D3_CSZ,d3.homephone as D3_PHONE,d3.ssn as D3_SSN,

                        d2.dob as D2_DOB,d3.dob as D3_DOB,d2.dlnum as D2_DL,d3.dlnum as D3_DL

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[debtors] d2 with(nolock) on d2.number = m.number and d2.seq = 1

                        left outer join [dbo].[debtors] d3 with(nolock) on d3.number = m.number and d3.seq = 2

WHERE            m.attorneystatus = 'Placing' 

                       
 

END

else if(@tableName =   'Employment')

BEGIN

 

-- employment info

SELECT            '04' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        d.jobname as EMP_NAME,d.jobaddr1+' '+d.jobaddr2 as EMP_STREET,null as EMP_PO,

                        d.jobcsz as EMP_CS,null as EMP_ZO,d.workphone as EMP_PHONE,null as EMP_FAX,

                        d.jobmemo as EMP_ATTN,null as EMP_PAYR,null as EMP_NO,null as EMPLOYEE_NAME

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[debtors] d with(nolock) on d.number = m.number

WHERE            m.attorneystatus = 'Placing' and d.seq = 0

 

 

END

else if(@tableName =   'Asset')

BEGIN

 

-- asset info (not implemented)

SELECT            top 0

                        '05' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        null as FILLER,null as BANK_NAME,null as BANK_STREET,null as BANK_CSZ,

                        null as BANK_ATTN, null as BANK_PHONE,null as BANK_FAX,null as BANK_ACCT,

                        null as MISC_ASSET1,null as MISC_ASSET2, null as MISC_ASSET3,null as MISC_PHONE,null as BANK_NO

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

WHERE            m.attorneystatus = 'Placing'

 

 

END

else if(@tableName =   'Misc')

BEGIN

 

-- misc info

SELECT            '06' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        da.name as ADVA_NAME,da.firm as ADVA_FIRM,null as ADVA_FIRM2,da.addr1+' '+da.addr2 as ADVA_STREET,

                        da.city+', '+da.state+', '+da.zipcode as ADVA_CSZ,null as ADVA_SALUT,

                        da.phone as ADVA_PHONE,da.fax as ADVA_FAX,null as ADVA_FILENO,

                        null as MISC_DATE1,null as MISC_DATE2,null as MISC_AMT1,null as MISC_AMT2,

                        da.comments as MISC_COMM1,da.email as MISC_COMM2,null as MISC_COMM3,

                        null as MISC_COMM4,null as ADVA_NUM

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[debtors] d with(nolock) on d.number = m.number

                        join [dbo].[DebtorAttorneys] da with(nolock) on da.debtorid = d.debtorid

WHERE            m.attorneystatus = 'Placing' and d.seq = 0

 

 

END

else if(@tableName =   'Legal')

BEGIN

 

-- legal info

SELECT            '07' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        c.county as CRT_COUNTY,null as CRT_DESIG,null as CRT_TYPE,

                        c.courtname as SHER_NAME,c.clerklastname+', '+c.clerkfirstname as SHER_NAME2,c.address1 + ' '+c.address2 as SHER_STREET,

                        c.city+', '+c.state+', '+c.zipcode as SHER_CSZ,null as SUIT_AMT,

                        null as CNTRCT_FEE,null as STAT_FEE,null as DOCKET_NO,cc.casenumber as JDGMNT_NO,

                        null as BKCY_NO,null as SUIT_DATE,cc.judgementdate as JDGMNT_DATE,

                        cc.judgementintrate as JDGMNT_AMT,cc.judgementamt as JUDG_PRIN,

                        m.interestrate as PREJ_INT,cc.judgementcostaward as JDG_COSTS,

                        null as ADJUSTMENT

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[courtcases] cc with(nolock) on m.number = cc.accountid

                        join [dbo].[courts] c with(nolock) on c.courtid = cc.courtid

WHERE            m.attorneystatus = 'Placing' 

 

 

END

else if(@tableName =   'Caption')

BEGIN

 

-- legal names

SELECT            '08' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        b.name as PLAINTIFF_1,null as PLAINTIFF_2, null as PLAINTIFF_3, null as PLAINTIFF_4,

                        null as PLAINTIFF_5, null as PLAINTIFF_6, null as PLAINTIFF_7,cc.defendant as DEFENDANT_1,

                        null as DEFENDANT_2,null as DEFENDANT_3,null as DEFENDANT_4,null as DEFENDANT_5,

                        null as DEFENDANT_6,null as DEFENDANT_7,null as DEFENDANT_8,null as DEFENDANT_9

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        left outer join [dbo].[courtcases] cc with(nolock) on m.number = cc.accountid                     

                        left outer join [dbo].[branchcodes] b with(nolock) on m.branch = b.code

WHERE            m.attorneystatus = 'Placing' 

 

-- messages

 

END

else if(@tableName =   'Messages')

BEGIN

 

--recalls

SELECT            '09' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        getdate() as PDATE, CASE m.attorneystatus WHEN 'Recalling' THEN '*CC:C102' WHEN 'Placing' THEN '*CC:S001'  END as PCODE,

                        CASE m.attorneystatus WHEN 'Recalling' THEN 'Recalling account.' 

                                                            WHEN 'Placing' THEN 'Placing Account.' 

--                                                          WHEN 'Placed' THEN 'The last paid date is below. Please call 858-650-9200 if you wish the claim resent. Last PaidDate:' + 

--                                              CASE WHEN m.lastpaid is null and m.clidlp is null THEN '' 

--                                                                                  WHEN m.lastpaid is null THEN cast(month(m.clidlp) as varchar) + '/' + cast(month(m.clidlp) as varchar) + '/' + cast(year(m.clidlp) as varchar)

--                                                                                  WHEN m.clidlp is null THEN cast(month(m.lastpaid) as varchar) + '/' + cast(month(m.lastpaid) as varchar) + '/' + cast(year(m.lastpaid) as varchar) 

--                                                                                  WHEN m.clidlp > m.lastpaid THEN cast(month(m.clidlp) as varchar) + '/' + cast(month(m.clidlp) as varchar) + '/' + cast(year(m.clidlp) as varchar) 

--                                                                                  WHEN m.lastpaid > m.clidlp THEN cast(month(m.lastpaid) as varchar) + '/' + cast(month(m.lastpaid) as varchar) + '/' + cast(year(m.lastpaid) as varchar) ELSE '' END

                                                                                     END

                                                                                     as PCMT

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

WHERE            m.attorneystatus in ('Placing', 'Recalling')

 

                                                     UNION

SELECT            '09' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        getdate() as PDATE, '*CC:W122' as PCODE,

cast(n.comment as varchar(800)) as PCMT

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[notes] n with (nolock) on m.number = n.number

WHERE            m.attorneystatus = 'Placed' and n.created between @startdate and @enddate and n.user0 <> 'YGC'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

 

 

 

 

 

 

 

 

 

END

else if(@tableName =   'Invoice')

BEGIN

 

-- invoices

SELECT            top 0

                        '11' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        null as INV_DATE,null as INV_NO,null as INV_DESC,null as INV_ORG,null as INV_BAL

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

 

 

END

else if(@tableName =   'Payment')

BEGIN

 

-- direct payments

SELECT            '12' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        p.datepaid as DP_DATE,p.comment as DP_CMT,

                        CASE WHEN p.batchtype LIKE '%r%' THEN -p.totalpaid ELSE p.totalpaid END as DP_MERCH,

                        ' ' as [SPACE],

                        CASE WHEN p.batchtype LIKE '%r%' THEN -p.totalpaid ELSE p.totalpaid END as DP_CASH,0 as DP_NOFEE

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[payhistory] p with(nolock) on m.number = p.number

WHERE            m.attorneystatus = 'Placed' and p.batchtype in ('PC','PU','PCR','PUR') 

                        and p.entered between @startdate and @enddate

 

END

else if(@tableName =   'Reconciliation')

BEGIN

 

-- reconciliation
		INSERT INTO LatitudeLegal_Reconciliation
		(AccountID,FORW_FILE,FIRM_ID,DPLACED,DEBT_NAME,
		CRED_NAME,D1_BAL,IDATE,IAMT,IDUE,PAID,COST_BAL,
		DEBT_CS,DEBT_ZIP,CRED_NAME2,COMM,SFEE,SENTDATE,SENTFLAG)
		SELECT					
		m.number as [FILENO],m.account as [FORW_FILE],
		a.yougotclaimsid as FIRM_ID,
		m.assignedattorney as DPLACED,replace(replace(replace(replace(m.name,',','/'),'.','/'),' / ','/'),'/ ','/') as DEBT_NAME,m.originalcreditor as CRED_NAME,
		m.current1 as D1_BAL,m.lastinterest as IDATE,m.interestrate as IAMT,
		m.current2 as IDUE, m.paid as PAID,m.current0 as COST_BAL,
		m.city+', '+m.state as DEBT_CS,m.zipcode as DEBT_ZIP,
		'' as CRED_NAME2,cast(a.feerate as varchar) as COMM,0 as SFEE,getdate(),1
		FROM   [dbo].[master] m with(nolock)
		join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid
		left outer join [dbo].[branchcodes] b with(nolock) on m.branch = b.code
		WHERE            m.attorneystatus = 'Placed'

		 

SELECT            '18' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],@myyougotclaimsid as [FORW_ID],a.yougotclaimsid as FIRM_ID,

                        m.assignedattorney as DPLACED,replace(replace(replace(replace(m.name,',','/'),'.','/'),' / ','/'),'/ ','/') as DEBT_NAME,m.originalcreditor as CRED_NAME,

                        m.current1 as D1_BAL,m.lastinterest as IDATE,m.interestrate as IAMT,

                        m.current2 as IDUE, m.paid as PAID,m.current0 as COST_BAL,

                        m.city+', '+m.state as DEBT_CS,m.zipcode as DEBT_ZIP,

                        '' as CRED_NAME2,a.feerate as COMM,0 as SFEE

FROM   [dbo].[master] m with(nolock)

                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        left outer join [dbo].[branchcodes] b with(nolock) on m.branch = b.code

WHERE            m.attorneystatus = 'Placed'

 

END

 

 

else if(@tableName =   'BondCoupon')

BEGIN

 

-- Bond Coupon

 

SELECT    '99' as [Record Code],m.number as [FILENO],m.account as [FORW_FILE],

                        null as [MASCO_FILE],'NL' as [FORW_ID],

                        l.yougotclaimsid as [LAW_LIST],getdate() as [DATE_FORW],m.original1 as [ORIG_CLAIM],

                        m.original1 as [ORIG_INT],m.lastinterest as [ORG_INT_D],null as [RE] ,

                        replace(replace(replace(replace(m.name,',','/'),'.','/'),' / ','/'),'/ ','/')[VS],

                        a.yougotclaimsid as FIRM_ID,null as [LL_ATTYID],a.Name as [ATTY_NAME],

                        a.Street1 + ' ' + a.street2 as [ATTY_STREET],a.city + ', ' + a.state + ' ' + a.zipcode as [ATTY_CSZ],

                        a.contact as [ATTY_CONTA],null as [ATTY_CNTRY],@myname as [FORW_NAME],@mystreet as [FORW_STREET],

                        @mycitystatezip as [FORW_CSZ],@myphone as [FORW_PHONE],null as [FORW_CONTA]

 

FROM   [dbo].[master] m with(nolock)


                        join [dbo].[attorney] a with(nolock) on m.attorneyid = a.attorneyid

                        join [dbo].[lawlists] l with (NOLOCK) on m.attorneylawlist = l.code

                        

WHERE            m.attorneystatus = 'Placing'

 

END

END

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 




GO
