SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





CREATE         procedure [dbo].[Custom_SelectCustomerReference]
	@customerReferenceId int
AS
	select
		cr.*
		,c.Customer
		,c.Contact
		,c.Phone
		,c.Email
		,c.street1 as Address
	from		
		Custom_CustomerReference cr 
		left outer join Customer c on cr.customerreferenceid = c.ccustomerid
	where
		cr.customerreferenceid = @customerReferenceId



GO
