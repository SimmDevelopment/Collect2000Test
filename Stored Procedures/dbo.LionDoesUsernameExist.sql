SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--KMG Fixed the checking for the username existence, previous logic was invalid
CREATE PROCEDURE [dbo].[LionDoesUsernameExist]
	@username varchar(50),
	@usernameexists bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @usernameexists=0

	if exists(select * from users with (nolock) where LoginName=@username)	
	begin
		select @usernameexists=convert(bit,1)
	end
END
GO
