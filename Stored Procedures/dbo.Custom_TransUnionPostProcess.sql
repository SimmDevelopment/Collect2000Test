SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_TransUnionPostProcess]

@RequestID int

AS
--****************************************************************************************************
declare @homephone varchar (30)
declare @comment varchar (500)
declare @retcode int
declare @filenumber int
--****************************************************************************************************
--****************************************************************************************************
--	Enter a note that Transunion suppled a possible new phone number to skip on
--****************************************************************************************************

declare cur cursor for 
	
	--load the cursor with the information from the servicehistory table and parse the xmlinforeturned field
	select  h.acctid, case c.phoneareacode when '0' then '000' else c.phoneareacode end + c.phonenumber as homephone
	from servicehistory h with (nolock) inner join services_cpe c on h.requestid = c.requestid 
		inner join master m with (nolock) on h.acctid = m.number
	where c.phonenumber <> '0000000' and m.homephone <> '' and 
	m.homephone not in ('0000000000', '1111111111', '2222222222', '3333333333', '4444444444', '5555555555','6666666666', 
	'7777777777', '8888888888', '9999999999') and h.requestid = @RequestID

open cur

--get the information from the cursor and into the variables
fetch from cur into @filenumber, @homephone
while @@fetch_status = 0 begin
	
	--for some reason, you can not concatenate a variable in a stored procedure's parameter, therefore
	--we will build the string into a variable and then use the variable instead	
	set @comment = 'Trans Union supplied possible new home phone on '+ convert(varchar, dbo.date(getdate()), 101) + 
	' as ' + substring(@homephone, 1, 3) + '-' + substring(@homephone, 4, 3) + '-' + substring(@homephone, 7, 4)
	
	--run the stored procedure to insert a note into the latitude database
	exec @retcode = addnote @filenumber, 'SYSTEM', 'PHONE', 'CHNG', @comment, @retcode
	
	--get the next record from the cursor
	fetch from cur into @filenumber, @homephone
	
end

--close and free up all the resources.
close cur
deallocate cur

--****************************************************************************************************
--****************************************************************************************************
--	Update to supplied homephone if no homephone exists
--****************************************************************************************************

declare cur cursor for 
	
	--load the cursor with the information from the servicehistory table and parse the xmlinforeturned field
	select h.acctid, case c.phoneareacode when '0' then '000' else c.phoneareacode end + c.phonenumber as homephone
	from servicehistory h with (nolock) inner join services_cpe c on h.requestid = c.requestid 
		inner join master m with (nolock) on h.acctid = m.number
	where c.phonenumber <> '0000000' and m.homephone in ('', '0000000000', '1111111111', '2222222222', '3333333333', 
		'4444444444', '5555555555','6666666666', '7777777777', '8888888888', '9999999999') and h.requestid = @RequestID

open cur

--get the information from the cursor and into the variables
fetch from cur into @filenumber, @homephone
while @@fetch_status = 0 begin
	
	
	--remove score from master so collectors can not see it
	update master
	set score = null
	where number = @filenumber

	--also perform the update on the master table.
	update debtors
	set homephone = @homephone
	where number = @filenumber and seq = 0

	--for some reason, you can not concatenate a variable in a stored procedure's parameter, therefore
	--we will build the string into a variable and then use the variable instead	
	set @comment = 'Trans Union supplied possible new home phone on ' + 
		convert(varchar, dbo.date(getdate()), 101) + ' as ' + substring(@homephone, 1, 3) + 
		'-' + substring(@homephone, 4, 3) + '-' + substring(@homephone, 7, 4)
	
	--run the stored procedure to insert a note into the latitude database
	exec @retcode = addnote @filenumber, 'SYSTEM', 'PHONE', 'CHNG', @comment, @retcode
	
	--get the next record from the cursor
	fetch from cur into @filenumber, @homephone
	
end

--close and free up all the resources.
close cur
deallocate cur

	set @filenumber = (select acctid from servicehistory with (Nolock) where requestid = @requestid)

--perform the update on the master table.
	update master
	set homephone = @homephone
	where number = @filenumber

	--place score where account analysis can see
	insert into tuscores(number, score)
	select number, score
	from master with (Nolock)
	where number = @filenumber
GO
