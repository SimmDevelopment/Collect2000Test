SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spTimeZoneInfo_Select*/
CREATE PROCEDURE [dbo].[spTimeZoneInfo_Select]
	@ZipCode varchar (5)

AS


select T_Z, STATE, COUNTY from Zipcodes with(nolock) where ZIP_CODE = @ZipCode

Return @@Error
GO
