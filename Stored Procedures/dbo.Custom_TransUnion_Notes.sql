SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_TransUnion_Notes]

@RequestID int

AS

insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'CO', 'CO', 
	'TU RTND POSS POB on '+ convert(varchar, dbo.date(getdate()), 101) + ' as ' + c.employmentname
from servicehistory sh with (nolock) inner join 
	services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.employmentname <> '' 
--****************************************************************************************************
--****************************************************************************************************
--	Insert Current Address Reported into notes
--****************************************************************************************************
--****************************************************************************************************

insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'ADDR', 'CHNG', 'TU RTND CUR Address on ' + 
	convert(varchar, dbo.date(getdate()), 101) + ' as ' + c.housenumber + ' ' + 
	case c.predirection when '' then '' else c.predirection end + ' ' + c.streetname + 
	' ' + c.streettype + ' ' + case c.apartmentnumber when '' then '' else 'Apt. ' end + c.apartmentnumber
from servicehistory sh with (nolock) inner join services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.housenumber <> '' 

insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'ADDR', 'CHNG', '                                ' + 
	case c.city when '' then '' else c.city + ', ' end + c.state + ' ' + c.zipcode
from servicehistory sh with (nolock) inner join 
	services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.housenumber <> '' 
--****************************************************************************************************
--****************************************************************************************************
--	Insert Previous Address Reported into notes
--****************************************************************************************************
--****************************************************************************************************
insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'ADDR', 'CHNG', 'TU RTND PRV Address on '+ 
	convert(varchar, dbo.date(getdate()), 101) + ' as ' + c.previoushousenumber + ' ' + 
	case c.previouspredirection when '' then '' else c.previouspredirection end 
	+ ' ' + c.previousstreetname + ' ' + c.previousstreettype + ' ' + 
	case c.previousapartmentnumber when '' then '' else 'Apt. ' end + c.previousapartmentnumber
from servicehistory sh with (nolock) inner join services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.previoushousenumber <> '' 

insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'ADDR', 'CHNG', '                               ' + 
	case c.previouscity when '' then '' else c.previouscity + ', ' end + c.previousstate + ' ' + c.previouszipcode
from servicehistory sh with (nolock) inner join services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.previoushousenumber <> '' 

insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'CO', 'CO', 
	'TU RTND Inquiry dated: ' + convert(varchar, dbo.date(c.dateofinquiry), 101) + ' by ' + c.subscribername + ': ' + 
	c.inquiryHousenumber + ' ' + c.inquirypredirection + ' ' + c.inquirystreetname + ' ' + c.inquirystreettype + 
	' ' + case c.inquiryapartmentnumber when '' then '' else 'Apt. ' end + c.inquiryapartmentnumber + ' ' + c.inquirycity +
	', ' + c.inquirystate + ' ' + c.inquiryzipcode + case c.inquiryphonenumber when '' then '' else ' Phone: ' end + c.inquiryphonenumber +
	case c.inquiryemploymentname when '' then '' else ' Employment: ' end + c.inquiryemploymentname
from servicehistory sh with (nolock) inner join 
	services_cpe_in01 c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null
GO
