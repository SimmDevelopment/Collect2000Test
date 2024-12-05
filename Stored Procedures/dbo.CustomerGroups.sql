SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CustomerGroups]

AS
BEGIN

	Create Table #Customer(Customer varchar(7), Name varchar(50))

	Insert into #Customer(customer, name)
	select distinct Convert(varchar(7),id) as Customer, Convert(varchar(50),Name)
	From customcustgroups with (nolock)

	Insert into #Customer(customer, name)
	Select distinct Customer, Name
	From Customer with (nolock) 
	Order by Customer
	
	select * from #customer
	

	
END

GO
