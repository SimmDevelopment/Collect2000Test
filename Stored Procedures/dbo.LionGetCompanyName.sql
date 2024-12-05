SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetCompanyName    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 12/08/2006
-- Description:	Will get the name of the company.
--				If no company defined in LionSettings then it will be taken
--				From the ControlFile table.
-- =============================================
/*
declare @test varchar(2000)
exec LionGetCompanyName @company=@test output
select @test
*/
CREATE PROCEDURE [dbo].[LionGetCompanyName] 
	@company varchar(2000) output
AS
BEGIN
	SET NOCOUNT ON;
	set @company = ''
--	select top 1 @company = Company from ControlFile with (nolock)

	if exists(select * from LionAppSettings with (nolock) where Name='CompanyName' and Value is not null)
	BEGIN
		select @company=Value from LionAppSettings with (nolock) where Name='CompanyName' and Value is not null
	END
	ELSE
	
	if( @company = null or LTRIM(RTRIM(@company))='')
	BEGIN
		select top 1 @company = Company from ControlFile with (nolock)
	END

    
END

GO
