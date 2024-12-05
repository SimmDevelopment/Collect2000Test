SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionCanUserViewDebtor    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE PROCEDURE [dbo].[LionCanUserViewDebtor]
	-- Add the parameters for the stored procedure here
	@lionUserId int,
	@debtorId int,
	@canView bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @canView = 0

	If Exists(
		Select d.name
		From Debtors d with (nolock)
		Join Master m with (nolock) on m.number=d.number
		Join Customer c with (nolock) on c.customer=m.customer
		Where d.debtorId=@debtorId
		and m.customer in (select * from LionAllowedCustomers(@lionUserId))
	)
	Begin		
		select @canView=convert(bit,1)
	End


	return

END

GO
