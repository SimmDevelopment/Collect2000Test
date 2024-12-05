SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[Custom_Fortress_Load_DebtorInfo]
	-- Add the parameters for the stored procedure here
@number int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @id varchar(50)
Declare @lastname varchar(50)
Declare @firstname varchar(50)
Declare @taxid varchar(50)
Declare @address1 varchar(50)
Declare @address2 varchar(50)
Declare @city varchar(50)
Declare @state varchar(50)
Declare @zip varchar(50)
Declare @homephone varchar(50)
Declare @officephone varchar(50)
Declare @validaddress varchar(50)
Declare @filler varchar(50)
Declare @ref1acctnum varchar(50)
Declare @ref1lastname varchar(50)
Declare @ref1firstname varchar(50)
Declare @ref1address1 varchar(50)
Declare @ref1address2 varchar(50)
Declare @ref1city varchar(50)
Declare @ref1state varchar(50)
Declare @ref1zip varchar(50)
Declare @ref1homephone varchar(50)
Declare @ref1officephone varchar(50)
Declare @ref2acctnum varchar(50)
Declare @ref2lastname varchar(50)
Declare @ref2firstname varchar(50)
Declare @ref2address1 varchar(50)
Declare @ref2address2 varchar(50)
Declare @ref2city varchar(50)
Declare @ref2state varchar(50)
Declare @ref2zip varchar(50)
Declare @ref2homephone varchar(50)
Declare @ref2officephone varchar(50)
Declare @ref3acctnum varchar(50)
Declare @ref3lastname varchar(50)
Declare @ref3firstname varchar(50)
Declare @ref3address1 varchar(50)
Declare @ref3address2 varchar(50)
Declare @ref3city varchar(50)
Declare @ref3state varchar(50)
Declare @ref3zip varchar(50)
Declare @ref3homephone varchar(50)
Declare @ref3officephone varchar(50)
Declare @birthdate varchar(50)
Declare @cellphone varchar(50)


    -- Insert statements for procedure here
SELECT     @id = id, @lastname = lastname, @firstname = firstname, @taxid = ssn, @address1 = address1, @address2 = address2, @city = city, 
			@state = state, @zip = zip, @homephone = homephone, @officephone = workphone, @validaddress = validaddress, @filler = filler, 
			@ref1acctnum = ref1acctnum, @ref1lastname = ref1lastname, @ref1firstname = ref1firstname, @ref1address1 = ref1address1, 
			@ref1address2 = ref1address2, @ref1city = ref1city, @ref1state = ref1state, @ref1zip = ref1zip, @ref1homephone = ref1homephone, 
			@ref1officephone = ref1workphone, @ref2acctnum = ref2acctnum, @ref2lastname = ref2lastname, @ref2firstname = ref2firstname, 
			@ref2address1 = ref2address1, @ref2address2 = ref2address2, @ref2city = ref2city, @ref2state = ref2state, @ref2zip = ref2zip, 
			@ref2homephone = ref2homephone, @ref2officephone = ref2workphone, @ref3acctnum = ref3acctnum, @ref3lastname = ref3lastname, @ref3firstname = ref3firstname, 
			@ref3address1 = ref3address1, @ref3address2 = ref3address2, @ref3city = ref3city, @ref3state = ref3state, @ref3zip = ref3zip, 
			@ref3homephone = ref3homephone, @ref3officephone = ref3workphone, @birthdate = birthdate, @cellphone = cellphone
			
FROM            Custom_Fortress_Debtor_Info
where ssn = (select ssn from master with (Nolock) where number = @number) ORDER BY CONVERT(DATETIME, filler, 101) DESC

update debtors
set name = @lastname + ', ' + @firstname, street1 = @address1, street2 = @address2, city = @city, state = @state, zipcode = @zip, homephone = @homephone,
			workphone = @officephone, lastname = @lastname, firstname = @firstname, dob = @birthdate, pager = @cellphone
where number = @number and seq = 0

update master
set name = @lastname + ', ' + @firstname, street1 = @address1, street2 = @address2, city = @city, state = @state, zipcode = @zip, homephone = @homephone,
			workphone = @officephone, received = dbo.date(@filler)
where number = @number


insert into miscextra (number, title, thedata)
values (@number, 'ref1acctnum', @ref1acctnum)

insert into miscextra (number, title, thedata)
values (@number, 'ref1lastname', @ref1lastname)

insert into miscextra (number, title, thedata)
values (@number, 'ref1firstname', @ref1firstname)

insert into miscextra (number, title, thedata)
values (@number, 'ref1address1', @ref1address1)

insert into miscextra (number, title, thedata)
values (@number, 'ref1address2', @ref1address2)

insert into miscextra (number, title, thedata)
values (@number, 'ref1state', @ref1state)

insert into miscextra (number, title, thedata)
values (@number, 'ref1zip', @ref1zip)

insert into miscextra (number, title, thedata)
values (@number, 'ref1homephone', @ref1homephone)

insert into miscextra (number, title, thedata)
values (@number, 'ref1officephone', @ref1officephone)

insert into miscextra (number, title, thedata)
values (@number, 'ref2acctnum', @ref2acctnum)

insert into miscextra (number, title, thedata)
values (@number, 'ref2lastname', @ref2lastname)

insert into miscextra (number, title, thedata)
values (@number, 'ref2firstname', @ref2firstname)

insert into miscextra (number, title, thedata)
values (@number, 'ref2address1', @ref2address1)

insert into miscextra (number, title, thedata)
values (@number, 'ref2address2', @ref2address2)

insert into miscextra (number, title, thedata)
values (@number, 'ref2state', @ref2state)

insert into miscextra (number, title, thedata)
values (@number, 'ref2zip', @ref2zip)

insert into miscextra (number, title, thedata)
values (@number, 'ref2homephone', @ref2homephone)

insert into miscextra (number, title, thedata)
values (@number, 'ref2officephone', @ref2officephone)

insert into miscextra (number, title, thedata)
values (@number, 'ref3acctnum', @ref3acctnum)

insert into miscextra (number, title, thedata)
values (@number, 'ref3lastname', @ref3lastname)

insert into miscextra (number, title, thedata)
values (@number, 'ref3firstname', @ref3firstname)

insert into miscextra (number, title, thedata)
values (@number, 'ref3address1', @ref3address1)

insert into miscextra (number, title, thedata)
values (@number, 'ref3address2', @ref3address2)

insert into miscextra (number, title, thedata)
values (@number, 'ref3state', @ref3state)

insert into miscextra (number, title, thedata)
values (@number, 'ref3zip', @ref3zip)

insert into miscextra (number, title, thedata)
values (@number, 'ref3homephone', @ref3homephone)

insert into miscextra (number, title, thedata)
values (@number, 'ref3officephone', @ref3officephone)

IF EXISTS (SELECT * FROM dbo.StatusHistory WITH (NOLOCK) WHERE AccountID IN (SELECT number FROM master WITH (NOLOCK) WHERE account IN (SELECT account FROM master WITH (NOLOCK) WHERE number = @number)) 
AND NewStatus IN ('cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd'))
	BEGIN
		

		UPDATE master
		SET qlevel = '998', desk = '008', closed = dbo.date(GETDATE()), status = (SELECT TOP 1 newstatus FROM statushistory WITH (NOLOCK) WHERE AccountID IN (SELECT number FROM master WITH (NOLOCK) WHERE account IN (SELECT account FROM master WITH (NOLOCK) WHERE number = @number)) AND NewStatus IN ('cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd') ORDER BY Datechanged)
		FROM master m WITH (NOLOCK) 
		WHERE m.number = @number 

		insert into notes(number, ctl, created, user0, action, result, comment, utccreated)
		select @number, 'ctl', GETDATE(), 'SYSTEM', '+++++', '+++++', 'Status Changed by LGL process during import new business', null




	END
	




END
GO
