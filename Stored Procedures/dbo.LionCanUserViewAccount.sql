SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionCanUserViewAccount    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/08/2006
-- Description:	
-- =============================================
/*
exec LionCanUserViewDebtor @lionUserId=2,@debtorId=5055
*/
CREATE PROCEDURE [dbo].[LionCanUserViewAccount]
	-- Add the parameters for the stored procedure here
	@lionUserId int,
	@number int,
	@canView bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @canView = 0

	If Exists(
		Select m.*
		From Master m with (nolock)
		Join Customer c with (nolock) on c.customer=m.customer
		Where m.number=@number
		and m.customer in (select * from LionAllowedCustomers(@lionUserId))
	)
	Begin		
		select @canView=convert(bit,1)
	End


	return

END


GO
