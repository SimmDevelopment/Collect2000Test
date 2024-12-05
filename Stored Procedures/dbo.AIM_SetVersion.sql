SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/15/2005
-- Description:	This will set the version for Exchange
-- =============================================

CREATE PROCEDURE [dbo].[AIM_SetVersion]
	-- Add the parameters for the stored procedure here
	@minor int,
	@major int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Delete from GlobalSettings
	where [Namespace]='Latitude.AIM'
	and [SettingName]='AIM.Version'

	Insert into GlobalSettings([NameSpace],[SettingName],[SettingType],[Description],[IntValue1],[IntValue2])
	Values
	('Latitude.AIM','AIM.Version',1,'Current version of AIM / PM',@major,@minor)
END

GO
