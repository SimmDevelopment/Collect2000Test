SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







create     procedure [dbo].[Custom_DeleteCustomerReference]
	@customerReferenceId int
AS
	delete from Custom_CustomerReference where customerreferenceid = @customerReferenceId




GO
