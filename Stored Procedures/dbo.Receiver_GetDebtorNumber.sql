SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_GetDebtorNumber]
@filenumber int,
@clientid int

as

	DECLARE @debtornumber int 
	select @debtornumber = max(debtorid )
	from debtors d join receiver_reference r on
	d.number = r.receivernumber 
	where sendernumber = @filenumber
		and clientid = @clientid

	if(@debtornumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end

	select @debtornumber

GO
