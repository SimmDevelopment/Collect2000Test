SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




/*

DECLARE @customerList varchar(7999)
DECLARE @startDate datetime
DECLARE @endDate datetime
set @customerList = '|0001003|'
set @startDate = '20081218'
set @endDate = '20081218'
EXEC [Custom_NCOUploadMaint] @customerList, @startDate, @endDate


*/

CREATE          PROCEDURE [dbo].[Custom_NCOUploadMaint]
	@customerList as varchar(7999),  
	@startDate as DateTime, 
 	@endDate as DateTime
AS
BEGIN

--Record 31 Primary Debtor here Demo changes
	SET @customerList=@customerList + '|'
    set @startDate = ltrim(rtrim(convert(char,@startDate,112)))
    set @enddate =  ltrim(rtrim(CONVERT(char,@enddate,101)))  + ' 11:59:59 PM'
--Record 31 Primary Debtor here Demo changes
select distinct
	m.number,
	'31' as Record_Code,
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO')  as FileNo,
        m.Account as Forw_File ,
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
--     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),' ') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,		
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,		
	d.name as D1_Name, '' as D1_Salut,
	d.otherName as D1_Alias,
	d.Street1 as D1_Street,
	ltrim(rtrim(isnull(d.city,''))) + ' ' + ltrim(rtrim(isnull(d.state,''))) as D1_CS,
	d.ZipCode as D1_Zip,
	d.homephone as D1_Phone,
	'' as D1_Fax,
	d.SSN as D1_SSN,
	'' as RFile,
	replace(ltrim(rtrim(convert(char,isnull(d.DOB,''),112))),'19000101','        ') as D1_DOB,
	d.DLNUM as D1_DL,
	isnull(d.mr,'N') as D1_Mail,
	'' as Service_D, '' as Answer_Due_Date, '' Answer_Due_Date, '' as Answer_File_Date, '' as Default_D,
	'' as Trial_D,'' as Hearing_D,'' as Lien_D,'' as Garn_D,'' as ServiceType
	From Debtors d with (nolock)
		Join Master m with (nolock) on m.number=d.number and d.seq = 0
and  m.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	and d.debtorID in (
	select distinct debtorID from (
	(select distinct debtorID from addresshistory with (nolock) 
		where datechanged  between   @startDate and @endDate and Accountid  in(select number from master with (nolock) where customer in (select string from dbo.CustomStringToSet(@customerList, '|'))))
union all
	(select distinct debtorID from phonehistory with (nolock) 
		where datechanged  between   @startDate and @endDate and Accountid in
(select number from master with (nolock) where customer in 
	(select string from dbo.CustomStringToSet(@customerList, '|')) )) )UNA
)
 --Populate table for Supplemental Debtor Demo Changes Record 33 
declare @DebtorUpdates table(DebtorID int, Number int)
 insert into @DebtorUpdates 
  select distinct debtorID,number from debtors where seq > 0  
		and debtorid in 
			(
			 select distinct debtorID from addresshistory with (nolock) 
			    where datechanged  between   @startDate and @endDate
			    and Accountid  in 
				(
				  select number from master with (nolock) 
				      where customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
				)  
			union all
			select distinct debtorID from phonehistory with (nolock) 
			    where datechanged  between   @startDate and @endDate
			     and PhoneType= 1		
			     and Accountid  in 
				 (
					select number from master with (nolock) 
					where customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
				  ) 	
			)
 --Supplemental Debtor Demo Changes Record 33 
select distinct
	m.number, '33' as Record_Code, (Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,
    m.Account as Forw_File,
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,		
	d2.name as D2_Name, d3.name as D3_Name,	
	d2.Street1 as D2_Street, d3.Street1 as D3_Street,
	ltrim(rtrim(isnull(d3.city,''))) + ' ' + ltrim(rtrim(isnull(d2.state,'')))+ ' ' + ltrim(rtrim(isnull(d2.zipcode,''))) as D2_CSZ,
	ltrim(rtrim(isnull(d3.city,''))) + ' ' + ltrim(rtrim(isnull(d3.state,'')))+ ' ' + ltrim(rtrim(isnull(d3.zipcode,''))) as D3_CSZ,
	d2.homephone as D2_Phone, d3.homephone as D3_Phone,
	d2.SSN as D2_SSN,d3.SSN as D3_SSN,
	d2.DOB as D2_DOB,d3.DOB as D3_DOB,
	d2.DLNUM as D2_DL,d3.DLNUM as D3_DL 
	From Debtors d2 with (nolock) inner join Master m with (nolock) on d2.number = m.number inner join Debtors d3 with (nolock) on d3.number = m.number
		where m.number in (Select number from @DebtorUpdates) and (d2.seq = 1 or d3.seq = 2)

--Legal Record 36 
select distinct a.debtorid,
	m.number, '36' as Record_Code, (Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,
    m.Account as Forw_File, 
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,		
	a.name as ADVA_Name, a.Firm as ADVA_Firm, 
	'' as ADVA_Firm3, 
	a.Addr1 as ADVA_Street,
	ltrim(rtrim(isnull(a.city,''))) + ' ' + ltrim(rtrim(isnull(a.state,'')))+ ' ' + ltrim(rtrim(isnull(a.zipcode,''))) as ADVA_CSZ,
	a.Phone as ADVA_Phone, '' as ADVA_Salut,
	a.Fax as ADVA_Fax, '' as ADVA_FileNo, 
	ltrim(rtrim(convert(char,a.DateCreated,112))) as Misc_Date1,ltrim(rtrim(convert(char,a.DateCreated,112))) as Misc_Date2,
	a.Comments as Misc_Comm1,'' as Misc_Comm2, '' as Misc_Comm3, '' as Misc_Comm4,
	(Select Seq + 1 from Debtors with (nolock) where debtorid = a.debtorid) as ADVA_Num 
	From   Master m with (nolock) join DebtorAttorneys A with (nolock) on m.number = a.accountID 
		where   m.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	and (a.DateCreated between  @startDate and @endDate 
	or a.DateUpdated between    @startDate and @endDate )

---notes Record 39
select  number, Record_Code, FileNo, Forw_File,Masco_file,Firm_ID,Forw_ID,PCode,PDate,PCMT, ID, LetterCode,Action,Result, Qlevel, Status,Userid
from
(
  --gets requested Letters

   select distinct m.number, '39' as Record_Code, (Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,
    m.Account as Forw_File, 
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,	
	
	 (case  when lettercode between '10001' and '10100' then '*CC:W100'
	  when lettercode between '10101' and '10200' then '*CC:W101' end ) 	  as PCode,
	ltrim(rtrim(convert(char,l.DateProcessed,112))) as PDate,
	
	(case  when lettercode between '10001' and '10100' then '1st Demand Letter' 
		  when lettercode between '10101' and '10200' then '2nd Demand Letter' end) 	  as PCMT,	
	 l.letterrequestid as ID, l.lettercode, '' as action, '' as result,m.qlevel, m.status, l.username as UserID
	From   Master m with (nolock) join LetterRequest L with (nolock) on l.Accountid = m.Number  
		where   m.customer in  (select string from dbo.CustomStringToSet(@customerList, '|'))
		and L.DateProcessed Between   @startDate and @endDate
		and L.lettercode between '10001' and '10200'
union all
--gets mapped action result codes
  select distinct m.number, '39' as Record_Code, (Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,
    m.Account as Forw_File, 
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,	
	
	 (case when substring(n.action,1,1) ='T' then '*CC:W117'
		when n.action ='RA' then '*CC:S138'
		when n.action ='RC' then '*CC:S128'
		when n.action ='RS' then '*CC:S127' end) 	  as PCode,
  	 ltrim(rtrim(convert(char,n.Created,112))) as PDate,
	 ltrim(rtrim(convert(varchar(1024),Comment))) as PCMT, 
	 n.uid as id, '' as lettercode, N.action,  N.result, m.qlevel, m.status, n.user0 as userID
	From   Master m with (nolock) inner join notes n with (nolock) on N.Number = m.Number  
	where n.Created Between @startDate and @endDate 
	and (n.action in ('RA','RC','RS') or substring(n.action,1,1) ='T')
	and m.customer in  (select string from dbo.CustomStringToSet(@customerList, '|'))
	and m.qlevel < 998 and m.closed is null
union all

 --gets closed status codes mapped to YGC_StatusCodes - matches on status 
  select distinct m.number, '39' as Record_Code, (Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,
    m.Account as Forw_File, 
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
        Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,	
	y.pcode	  as PCode, ltrim(rtrim(convert(char,isnull(m.closed,getdate()),112))) as PDate,
	 ltrim(rtrim(convert(varchar(1024),description))) as PCMT, 
	 0 as id, '' as lettercode, '' as action, '' as result, m.qlevel, m.status, 'EXCHANGE' as userID
	From   Master m with (nolock) 
	left outer join YGC_StatusCodes y with (nolock) on m.Status = Y.Status
	 where   m.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	 and m.returned is null and m.closed between @startDate and @endDate
)f
ORDER BY NUMBER
/*
--create note for returns insert into notes
insert into notes (created, number, User0, Action, Result, Comment)
select  getdate(),number, 'EXCHANGE','+++++','+++++','Account Returned to Client'
from master where qlevel = '998' 
and customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
and status in (select distinct status from YGC_StatusCodes where statusType = 1 
				and substring(pcode,1,5)='*CC:C')
 
--update master record
update master set qlevel = '999', returned =  convert(datetime,ltrim(rtrim(convert(char,getdate(),112))) )
From   Master m with (nolock) 
join YGC_StatusCodes y with (nolock) on m.Status = Y.Status
where m.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
and m.qlevel = '998' and m.returned is null and m.closed between @startDate and @endDate
*/

END 
SET ANSI_NULLS OFF
GO
