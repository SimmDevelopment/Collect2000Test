SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LionGetDefaultMail]
	@defaultEmail varchar(2000) output
AS
BEGIN
	SET NOCOUNT ON;
	set @defaultEmail = ''

	Declare @defaultEmailKey varchar(100)
	set @defaultEmailKey = 'DefaultEmail'

	if exists(select * from LionAppSettings with (nolock) where Name=@defaultEmailKey and Value is not null)
	BEGIN
		select @defaultEmail=Value from LionAppSettings with (nolock) 
		where Name=@defaultEmailKey and Value is not null
	END
	
--	if( @defaultEmail = null or LTRIM(RTRIM(@company))='')
--	BEGIN
--		select top 1 @company = Company from ControlFile with (nolock)
--	END

    
END
GO
