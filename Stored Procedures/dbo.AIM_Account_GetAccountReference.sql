SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* Object:  Stored Procedure dbo.AIM_Account_GetAccountReference    */


CREATE             procedure [dbo].[AIM_Account_GetAccountReference]
(
      @referenceNumber   int,
      @accountReferenceId   int output
)
as
begin

	select
		@accountReferenceId = ar.accountreferenceid
	from
		AIM_accountreference ar
	where
		ar.referenceNumber = @referenceNumber

	-- if no account reference record then create one
	if(@accountReferenceId is null)
	begin
		insert into 
			AIM_accountreference 
		(
			referencenumber
		)
		values
		(
			@referenceNumber
		)

		select @accountReferenceId = @@Identity
	end

end

GO
