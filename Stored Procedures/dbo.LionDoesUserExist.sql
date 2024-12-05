SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDoesUserExist    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimmi
-- Create date: 12/06/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionDoesUserExist]
	-- Add the parameters for the stored procedure here
	@username varchar(50),
	@exists bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @exists = 1

	if not exists(select * from users with (nolock) where UserName=@username)
		set @exists=0
END

GO
