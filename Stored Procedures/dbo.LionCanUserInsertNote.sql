SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionCanUserInsertNote    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/21/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionCanUserInsertNote]
	-- Add the parameters for the stored procedure here
	@lionUserId int,
	@debtorId int,
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
			--now we must check to see if this guy can view the debtor
			exec LionCanUserViewDebtor @lionUserId=@lionUserId,@debtorId=@debtorId,@canView=@canInsert output
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
