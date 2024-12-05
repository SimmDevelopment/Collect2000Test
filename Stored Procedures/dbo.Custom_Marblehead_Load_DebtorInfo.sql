SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Marblehead_Load_DebtorInfo]
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
Declare @skipind varchar(50)
Declare @defforbcode varchar(50)
Declare @defforbbegindate varchar(50)
Declare @defforbenddate varchar(50)
Declare @emailaddress varchar(50)
Declare @bortotalpastdue varchar(50)
Declare @lastcontactdate varchar(50)
Declare @filler1 varchar(50)
Declare @birthdate varchar(50)
Declare @cellphone varchar(50)
Declare @filler2 varchar(50)
Declare @borinfocode varchar(50)
Declare @filler3 varchar(50)


    -- Insert statements for procedure here
SELECT     @id = id, @lastname = lastname, @firstname = firstname, @taxid = taxid, @address1 = address1, @address2 = address2, @city = city, 
			@state = state, @zip = zip, @homephone = homephone, @officephone = officephone, @validaddress = validaddress, @filler = filler, 
			@ref1acctnum = ref1acctnum, @ref1lastname = ref1lastname, @ref1firstname = ref1firstname, @ref1address1 = ref1address1, 
			@ref1address2 = ref1address2, @ref1city = ref1city, @ref1state = ref1state, @ref1zip = ref1zip, @ref1homephone = ref1homephone, 
			@ref1officephone = ref1officephone, @ref2acctnum = ref2acctnum, @ref2lastname = ref2lastname, @ref2firstname = ref2firstname, 
			@ref2address1 = ref2address1, @ref2address2 = ref2address2, @ref2city = ref2city, @ref2state = ref2state, @ref2zip = ref2zip, 
			@ref2homephone = ref2homephone, @ref2officephone = ref2officephone, @skipind = skipind, @defforbcode = defforbcode, 
			@defforbbegindate = defforbbegindate, @defforbenddate = defforbenddate, @emailaddress = emailaddress, @bortotalpastdue = bortotalpastdue, 
			@lastcontactdate = lastcontactdate, @filler1 = filler1, @birthdate = birthdate, @cellphone = cellphone, @filler2 = filler2, 
			@borinfocode = borinfocode, @filler3 = filler3
FROM            Custom_Marblehead_Debtor_Info
where taxid = (select ssn from master with (Nolock) where number = @number)

update debtors
set name = @lastname + ', ' + @firstname, street1 = @address1, street2 = @address2, city = @city, state = @state, zipcode = @zip, homephone = @homephone,
			workphone = @officephone, lastname = @lastname, firstname = @firstname, dob = @birthdate, pager = @cellphone, email = @emailaddress
where number = @number and seq = 0

update master
set name = @lastname + ', ' + @firstname, street1 = @address1, street2 = @address2, city = @city, state = @state, zipcode = @zip, homephone = @homephone,
			workphone = @officephone
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








END
GO
