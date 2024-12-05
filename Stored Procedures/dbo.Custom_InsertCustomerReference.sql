SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE        procedure [dbo].[Custom_InsertCustomerReference]
AS

DECLARE @customerReferenceId int

	insert into custom_customerreference (ccustomerid) values(null)
	select @customerReferenceId = SCOPE_IDENTITY()

	SELECT @customerReferenceId





GO
