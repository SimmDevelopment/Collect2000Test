SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_H&RBlock_NameParse]
@number int

 AS

update master
set name = upper(dbo.getlastname(name)) + ', ' + upper(dbo.getfirstname(name)) + ' ' + upper(dbo.getmiddlename(name))
where number = @number

update debtors
set name = upper(dbo.getlastname(name)) + ', ' + upper(dbo.getfirstname(name)) + ' ' + upper(dbo.getmiddlename(name)), lastname = upper(dbo.getlastname(name)),
	firstname = upper(dbo.getfirstname(name)), middlename = upper(dbo.getmiddlename(name))
where number = @number and seq = 0
GO
