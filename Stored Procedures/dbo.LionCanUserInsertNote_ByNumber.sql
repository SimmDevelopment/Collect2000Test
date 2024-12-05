SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionCanUserInsertNote_ByNumber    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/21/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionCanUserInsertNote_ByNumber]
	-- Add the parameters for the stored procedure here
	@lionUserId int,
	@number int,
	@canInsert bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @canInsert = 0



	If Exists( select * from LionUserPermissions with (nolock) where LionUserId=@LionUserId)
	BEGIN
			Select @canInsert=CanInsertNote from LionUserPermissions with (nolock) where LionUserId=@LionUserId
			if( @canInsert != 1 )
			BEGIN
				select @canInsert=convert(bit,0)
				return
			END

			--see if the customer is allowed or not to be viewed
			If Exists(
				Select m.*
				From Master m with (nolock)
				Join Customer c with (nolock) on c.customer=m.customer
				Where m.number=@number
				and m.customer in (select * from LionAllowedCustomers(@lionUserId))
			)
			Begin		
				select @canInsert=convert(bit,1)
				return
			End

			select @canInsert=convert(bit,0)
			return
	END
	Else	--no permission exists default to not insert note
	BEGIN
		select @canInsert=convert(bit,0)
		Return
	END

	return
END


GO
