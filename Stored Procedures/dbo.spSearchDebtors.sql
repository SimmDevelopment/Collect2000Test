SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[spSearchDebtors]
  @searchstring varchar(4000), @searchmethod varchar(25), @username varchar(15), @userid int
as
  if @searchmethod='name'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where name like @searchstring+'%' and customer in (select * from AllowedCustomers(@userid))
  else
  if @searchmethod = 'contains'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where name like '%'+@searchstring+'%' and customer in (select * from AllowedCustomers(@userid))
  else
  if @searchmethod = 'endswith'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where name like '%'+@searchstring and customer in (select * from AllowedCustomers(@userid))
  else
  if @searchmethod = 'account'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where account = @searchstring and customer in (select * from AllowedCustomers(@userid))
  else
  if @searchmethod = 'ssn'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where SSN = @searchstring and customer in (select * from AllowedCustomers(@userid))
  else
  if @searchmethod = 'number'
    select Number, dbo.ProperCase(Name) as Name, Status, Original, current0 as [Current], Received, Account, SSN from vDebtorView where number = @searchstring and customer in (select * from AllowedCustomers(@userid))
GO
