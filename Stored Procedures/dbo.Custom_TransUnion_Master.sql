SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_TransUnion_Master]

@RequestID int

 AS

declare @number int
declare @homephone varchar (30)
declare @comment varchar (500)
declare @date datetime

set @date = getdate()

--set this to the batchid that you want to import the TU data from
set @number = (select acctid from servicehistory with (Nolock) where requestid = @requestid)




--Move the scores 
insert into tuscores(number, score)
	select number, score
	from master with (Nolock)
	where number = @number

	update master
	set score = null
	where number = @number



--Update existing home phone numbers
--create the cursor to use
declare cur cursor for 
	
	--load the cursor with the information from the servicehistory table and parse the xmlinforeturned field
	select  h.acctid, case c.phoneareacode when '0' then '000' else c.phoneareacode end + c.phonenumber as homephone
	from servicehistory h with (nolock) inner join services_cpe c on h.requestid = c.requestid 
		inner join master m with (nolock) on h.acctid = m.number
	where c.phonenumber <> '0000000' and m.homephone <> '' and 
	m.homephone not in ('0000000000', '1111111111', '2222222222', '3333333333', '4444444444', '5555555555','6666666666', 
	'7777777777', '8888888888', '9999999999') and   h.serviceid = 5003 and h.requestid = @RequestID

open cur

--get the information from the cursor and into the variables
fetch from cur into @number, @homephone
while @@fetch_status = 0 begin
	
	--for some reason, you can not concatenate a variable in a stored procedure's parameter, therefore
	--we will build the string into a variable and then use the variable instead	
	set @comment = 'Trans Union supplied possible new home phone on '+ convert(varchar, dbo.date(getdate()), 101) + 
	' as ' + substring(@homephone, 1, 3) + '-' + substring(@homephone, 4, 3) + '-' + substring(@homephone, 7, 4)
	
	--run the stored procedure to insert a note into the latitude database
	exec spNote_AddV5 @number, @date, 'SYSTEM', 'PHONE', 'CHNG', @comment, 0, 0
	
	--get the next record from the cursor
	fetch from cur into @number, @homephone
	
end

--close and free up all the resources.
close cur
deallocate cur

--Update home phone that does not exist
--create the cursor to use
declare cur cursor for 
	
	--load the cursor with the information from the servicehistory table and parse the xmlinforeturned field
	select h.acctid, case c.phoneareacode when '0' then '000' else c.phoneareacode end + c.phonenumber as homephone
	from servicehistory h with (nolock) inner join services_cpe c on h.requestid = c.requestid 
		inner join master m with (nolock) on h.acctid = m.number
	where c.phonenumber <> '0000000' and m.homephone in ('', '0000000000', '1111111111', '2222222222', '3333333333', 
		'4444444444', '5555555555','6666666666', '7777777777', '8888888888', '9999999999') and   h.serviceid = 5003 
		and h.requestid = @RequestID

open cur

--get the information from the cursor and into the variables
fetch from cur into @number, @homephone
while @@fetch_status = 0 begin
	
	--perform the update on the master table.
	update master
	set homephone = @homephone
	where number = @number

	--also perform the update on the master table.
	update debtors
	set homephone = @homephone
	where number = @number and seq = 0

	--for some reason, you can not concatenate a variable in a stored procedure's parameter, therefore
	--we will build the string into a variable and then use the variable instead	
	set @comment = 'Trans Union supplied possible new home phone on ' + 
		convert(varchar, dbo.date(getdate()), 101) + ' as ' + substring(@homephone, 1, 3) + 
		'-' + substring(@homephone, 4, 3) + '-' + substring(@homephone, 7, 4)
	
	--run the stored procedure to insert a note into the latitude database
	exec spNote_AddV5 @number, @date, 'SYSTEM', 'PHONE', 'CHNG', @comment, 0, 0
	
	--get the next record from the cursor
	fetch from cur into @number, @homephone
	
end

--close and free up all the resources.
close cur
deallocate cur

--Insert employer information into notes
insert into notes 
	(number,ctl,created,user0,action,result,comment)

select sh.acctid, 'ctl', getdate(), 'SYSTEM', 'CO', 'CO', 
	'TU RTND POSS POB on '+ convert(varchar, dbo.date(getdate()), 101) + ' as ' + c.employmentname
from servicehistory sh with (nolock) inner join 
	services_cpe c with (nolock) on sh.requestid = c.requestid
where sh.requestid = @RequestID and xmlinforeturned is not null and c.employmentname <> '' 

--Insert curr address reported.
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

--Insert previous address into notes
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








GO
